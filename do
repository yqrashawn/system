#! /usr/bin/env python3

import os
from enum import Enum
from typing import Iterable

import click
import distro

IS_DARWIN = distro.id().lower() == "darwin"


class FlakeOutputs(Enum):
    NIXOS = "nixosConfigurations"
    DARWIN = "darwinConfigurations"
    HOME_MANAGER = "homeManagerConfigurations"


class Colors(Enum):
    SUCCESS = "green"
    INFO = "blue"
    ERROR = "red"


def infer_platform():
    # if we're on nixos, this command should be in the path
    if os.system("command -v nixos-rebuild > /dev/null") == 0:
        return FlakeOutputs.NIXOS
    # if we're on darwin, we might have darwin-rebuild or the distro id will be 'darwin'
    elif os.system("command -v darwin-rebuild > /dev/null") == 0 or IS_DARWIN:
        return FlakeOutputs.DARWIN
    else:
        return FlakeOutputs.HOME_MANAGER


def fmt_command(cmd: str):
    return f"> {cmd}"


def test_cmd(cmd: str):
    return os.system(f"{cmd} > /dev/null") == 0


def run_cmd(cmd: str):
    click.secho(fmt_command(cmd), fg=Colors.INFO.value)
    return os.system(cmd)


@click.group()
def cli():
    # dummy command to group all subcommands
    pass


@cli.command(
    help="update all flake inputs, or a specific flake using the -f argument",
)
@click.option(
    "--flake",
    "-f",
    default="",
    metavar="[HOST]",
    multiple=True,
    help="specify an individual flake to be updated",
)
@click.option(
    "--commit", flag_value=True, is_flag=True, help="commit the updated lockfile"
)
def update(commit: bool, flake: Iterable[str]):
    flags = "--commit-lock-file" if commit else ""
    if not flake:
        click.echo("updating all flake inputs")
        cmd = f"nix flake update --recreate-lock-file {flags}"
        run_cmd(cmd)
    else:
        for input in flake:
            click.echo(f"updating {input}")
            cmd = f"nix flake update --update-input {input} {flags}"
            click.echo(fmt_command(cmd))
            os.system(cmd)


@cli.command(
    help="builds the specified flake output; infers correct platform to use if not specified",
    no_args_is_help=True,
)
@click.option("--nixos", flag_value=True, is_flag=True)
@click.option("--darwin", flag_value=True, is_flag=True)
@click.option("--home-manager", flag_value=True, is_flag=True)
@click.argument("host", default="")
def build(nixos: bool, darwin: bool, home_manager: bool, host: str):
    if not host:
        click.secho("Error: host configuration not specified.", fg=Colors.ERROR.value)
        return False
    else:
        cfg = infer_platform()
        if home_manager or cfg == FlakeOutputs.HOME_MANAGER:
            flake = f".#{FlakeOutputs.HOME_MANAGER.value}.{host}.activationPackage"
            cmd = f"nix build {flake}"
            run_cmd(cmd)
        elif darwin or cfg == FlakeOutputs.DARWIN:
            flake = f".#{host}"
            cmd = f"darwin-rebuild build {flake}"
            run_cmd(cmd)
        elif nixos or cfg == FlakeOutputs.NIXOS:
            flake = f".#{host}"
            cmd = f"sudo nixos-rebuild build {flake}"
            run_cmd(cmd)
        else:
            click.echo(
                "could not infer system type. aborting...", fg=Colors.ERROR.value
            )


@cli.command(
    help="builds and activates the specified flake output; infers correct platform to use if not specified",
    no_args_is_help=True,
)
@click.option("--nixos", flag_value=True, is_flag=True)
@click.option("--darwin", flag_value=True, is_flag=True)
@click.option("--home-manager", flag_value=True, is_flag=True)
@click.argument("host", default="")
def switch(nixos: bool, darwin: bool, home_manager: bool, host: str):
    if not host:
        click.secho("Error: host configuration not specified.", fg=Colors.ERROR.value)
        return False
    else:
        cfg = infer_platform()
        if home_manager or cfg == FlakeOutputs.HOME_MANAGER:
            flake = f".#{cfg.value}.{host}.activationPackage"
            cmd = f"nix build {flake} && ./result/activate"
            run_cmd(cmd)
        elif darwin or cfg == FlakeOutputs.DARWIN:
            flake = f".#{host}"
            cmd = f"darwin-rebuild switch --flake {flake} --show-trace"
            run_cmd(cmd)
        elif nixos or cfg == FlakeOutputs.NIXOS:
            flake = f".#{host}"
            cmd = f"sudo nixos-rebuild switch --flake {flake} --show-trace"
            run_cmd(cmd)
        else:
            click.echo(
                "could not infer system type. aborting...", fg=Colors.ERROR.value
            )


@cli.command(
    help="run garbage collection on unused nix store paths", no_args_is_help=True
)
@click.option(
    "--delete-older-than",
    "-d",
    metavar="[AGE]",
    default="14d",
    help="specify minimum age for deleting store paths",
)
@click.option(
    "--dry-run",
    flag_value=True,
    is_flag=True,
    help="test the result of garbage collection",
)
def gc(delete_older_than: str, dry_run: bool):
    cmd = f"nix-collect-garbage --delete-older-than {delete_older_than} {'--dry-run' if dry_run else ''}"
    run_cmd(cmd)


@cli.command(help="run formatter on all nix files")
def fmt():
    cmd = "nixfmt **/*.nix"
    run_cmd(cmd)


@cli.command(
    help="remove previously built configurations and symlinks from the current directory",
)
def clean():
    cmd = "for i in *; do [[ -L $i ]] && rm -f $i; done"
    run_cmd(cmd)


@cli.command(
    help="configure disk setup for nix-darwin",
    hidden=not IS_DARWIN,
)
def diskSetup():
    if not IS_DARWIN:
        click.secho(
            "nix-darwin does not apply on this platform. aborting...",
            fg=Colors.ERROR.value,
        )
        return

    if not test_cmd("grep -q '^run\\b' /etc/synthetic.conf 2>/dev/null"):
        click.secho("setting up /etc/synthetic.conf", fg=Colors.INFO.value)
        run_cmd(
            'echo -e "run\\tprivate/var/run" | sudo tee -a /etc/synthetic.conf >/dev/null'
        )
        run_cmd(
            "/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -B 2>/dev/null || true"
        )
        run_cmd(
            "/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t 2>/dev/null || true"
        )

    if not test_cmd("test -L /run"):
        click.secho("linking /run directory", fg=Colors.INFO.value)
        run_cmd("sudo ln -sfn private/var/run /run")

    click.secho("disk setup complete", fg=Colors.SUCCESS.value)


if __name__ == "__main__":
    cli()