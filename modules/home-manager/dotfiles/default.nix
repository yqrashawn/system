{ inputs, config, pkgs, lib, ... }: {
  home.file = {
    # hammerspoon = lib.mkIf pkgs.stdenvNoCC.isDarwin {
    #   source = ./hammerspoon;
    #   target = ".hammerspoon";
    #   recursive = true;
    # };
    # ".hammerspoon".source = inputs.spacehammer;
    # spoons = {
    #   source = ./Spoons;
    #   target = ".hammerspoon/Spoons";
    #   recursive = true;
    # };
    spacehammer = {
      source = ./.spacehammer;
      target = ".spacehammer";
      recursive = true;
    };
    ripgrep = {
      source = ./.ripgreprc;
      target = ".ripgreprc";
    };
    editorconfig = {
      source = ./.editorconfig;
      target = ".editorconfig";
    };
    local-bins = {
      source = ./local-bins;
      target = "local/bin";
      recursive = true;
    };
    raycast = lib.mkIf pkgs.stdenvNoCC.isDarwin {
      source = ./raycast;
      target = ".local/bin/raycast";
      recursive = true;
    };
    zfunc = {
      source = ./zfunc;
      target = ".zfunc";
      recursive = true;
    };
    # npmrc = {
    #   text = ''
    #     prefix = ${config.home.sessionVariables.NODE_PATH};
    #   '';
    #   target = ".npmrc";
    # };
  };

  xdg.enable = true;
  xdg.configFile = {
    "nixpkgs/config.nix".source = ../../config.nix;
    yabai = lib.mkIf pkgs.stdenvNoCC.isDarwin {
      source = ./yabai;
      recursive = true;
    };
    alacritty = lib.mkIf pkgs.stdenvNoCC.isDarwin {
      source = ./alacritty;
      recursive = true;
    };
    "clojure".source = inputs.clojure-deps-edn;
  };
}
