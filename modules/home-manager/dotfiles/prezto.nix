{ config, lib, pkgs, ... }:

{
  programs.zsh.prezto = {
    caseSensitive = false;
    color = true;
    pmoduleDirs = [ "$HOME/.zprezto-contrib" ];
    extraConfig = "";
    extraModules = [ "attr" "stat" ];
    extraFunctions = [ "zargs" "zmv" ];
    pmodules = [
      "environment"
      "tmux"
      "terminal"
      "editor"
      "history"
      "directory"
      "utility"
      "archive"
      "docker"
      "homebrew"
      "osx"
      "node"
      "ssh"
      "git"
      "abbrev"
      "spectrum"
      "python"
      "ruby"
      "direnv"
      "alias-tips"
      "completion"
      "autosuggestions"
      "fast-syntax-highlighting"
      "history-substring-search"
    ];
    editor = {
      keymap = "emacs";
      dotExpansion = true;
      promptContext = true;
    };
    gnuUtility.prefix = "g";
    macOS.dashKeyword = "mand";
    python = {
      virtualenvAutoSwitch = true;
      virtualenvInitialize = true;
    };
    ssh.identities = [ "id_rsa" "id_rsa_holy" "id_rsa_website_jump" ];
  };
}
