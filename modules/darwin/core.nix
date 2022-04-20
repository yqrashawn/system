{ inputs, config, pkgs, ... }:
let
  home = builtins.getEnv "HOME";
  prefix = "/run/current-system/sw/bin";
  tmpdir = "/tmp";
  localconfig = import <localconfig>;
  xdg_configHome = "${home}/.config";
  xdg_dataHome = "${home}/.local/share";
  xdg_cacheHome = "${home}/.cache";
in {
  # environment setup
  environment = {
    loginShell = pkgs.zsh;
    # backupFileExtension = "backup";
    etc = {
      darwin.source = "${inputs.darwin}";
      profile = { source = ./root-profile; };
    };
    variables = { EDITOR = "emacsclient"; };

    # launchDaemons = {
    #   "limit.maxfile.plist" = { source = ./limit.maxfile.plist; };
    #   "limit.maxproc.plist" = { source = ./limit.maxproc.plist; };
    #   "set-nix-path.plist" = { source = ./set-nix-path.plist; };
    # };

    # Use a custom configuration.nix location.
    # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix

    # packages installed in system profile
    # systemPackages = [ ];
  };

  launchd = let
    iterate = StartInterval: {
      inherit StartInterval;
      Nice = 5;
      LowPriorityIO = true;
      AbandonProcessGroup = true;
    };
    runCommand = command: {
      inherit command;
      serviceConfig.RunAtLoad = true;
      serviceConfig.KeepAlive = true;
    };
  in {
    daemons = {
      limit-maxfiles = {
        script = "/bin/launchctl limit maxfiles 65536 65536";
        serviceConfig.RunAtLoad = true;
        serviceConfig.KeepAlive = false;
      };
      limit-maxproc = {
        script = "/bin/launchctl limit maxproc 4176 4176";
        serviceConfig.RunAtLoad = true;
        serviceConfig.KeepAlive = false;
      };
      set-path = {
        script = ''
          export PATH=/run/current-system/sw/bin:$PATH
        '';
        serviceConfig.RunAtLoad = true;
        serviceConfig.KeepAlive = false;
      };
    };
  };

  fonts.fontDir.enable = true;
  nix.nixPath = [ "darwin=/etc/${config.environment.etc.darwin.target}" ];
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # auto manage nixbld users with nix darwin
  users.nix.configureBuildUsers = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system = {
    stateVersion = 4;
    defaults = {
      NSGlobalDomain = {
        ApplePressAndHoldEnabled = false;
        AppleKeyboardUIMode = 3; # full keyboard control
        _HIHideMenuBar = false; # auto hide menubar
      };

      ".GlobalPreferences" = {
        "com.apple.sound.beep.sound" = "/System/Library/Sounds/Funk.aiff";
      };

      dock = {
        autohide = true;
        launchanim = false;
        orientation = "bottom";
      };
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  documentation = {
    enable = false;
    doc.enable = false;
    info.enable = false;
    man.enable = false;
  };
}
