{ config, lib, pkgs, ... }: {
  imports = [ ./apps-minimal.nix ];
  homebrew = {
    casks = [
      "figma"
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
      "telegram"
      "discord"
      "dropbox"
      "calibre"
      "ngrok"
      "adguard-nightly"
      # "syncthing"
      "stats"
      "zoom"
      "warp"
    ];
    masApps = { };
  };
}
