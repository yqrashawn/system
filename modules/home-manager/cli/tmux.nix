{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    extraConfig = "source ~/.tmux/.tmux.conf";
    # extraConfig = builtins.readFile "${config.home.homeDirectory}/.tmux.conf";
  };
}
