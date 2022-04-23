{ config, inputs, pkgs, lib, ... }: {
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./starship.nix
    ./fzf.nix
    ./direnv.nix
    ./bat.nix
    ./mcfly.nix
  ];
  home.packages = [ pkgs.tree ];
  programs = {
    jq.enable = true;
    htop.enable = true;
    gpg.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
      aliases = {
        ignore =
          "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
      };
    };
    go.enable = true;
    exa = {
      enable = true;
      enableAliases = true;
    };
    nix-index.enable = true;
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
