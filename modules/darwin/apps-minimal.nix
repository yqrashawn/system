{ config, lib, pkgs, ... }: {
  homebrew = {
    casks = [
      # "1password-beta"
      # "bartender"
      "firefox-beta"
      "alacritty"
      "kitty"
      "raycast"
      # "stats"
      "visual-studio-code"
    ];
  };
}
