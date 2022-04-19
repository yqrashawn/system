{ config, lib, pkgs, ... }: {
  homebrew = {
    casks = [
      "setapp"
      "notion"
      "hammerspoon"
      "rectangle"
      "monitorcontrol"
      # "1password-beta"
      # "bartender"
      "karabiner-elements"
      "google-chrome"
      "alacritty"
      "kitty"
      "keybase"
      "raycast"
      # "stats"
      "visual-studio-code"
    ];
  };
}
