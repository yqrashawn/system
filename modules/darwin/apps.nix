{ config, lib, pkgs, ... }: {
  imports = [ ./apps-minimal.nix ];
  homebrew = {
    casks = [
      "xbar"
      "firefox"
      "gfxcardstatus"
      "uhk-agent"
      "slack"
      "bitwarden"
      "clickup"
      "fork"
      "iina"
      "gpg-suite-no-mail"
      "firefox-developer-edition"
      "todoist"
      "skim"
      # "syncthing"
      "zoom"
    ];
    masApps = { };
  };
}
