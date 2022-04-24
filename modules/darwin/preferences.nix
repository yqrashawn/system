{ config, pkgs, ... }: {
  system.defaults = {
    universalaccess = {
      reduceTransparency = true;
      # Use scroll gesture with the Ctrl (^) modifier key to zoom
      closeViewScrollWheelToggle = true;
      # zoom view focus follow keyboard
      closeViewZoomFollowsFocus = true;
    };
    # login window settings
    loginwindow = {
      # disable guest account
      GuestEnabled = false;
      # show name instead of username
      SHOWFULLNAME = false;
    };

    # file viewer settings
    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = true;
      _FXShowPosixPathInTitle = true;
    };

    # trackpad settings
    trackpad = {
      # silent clicking = 0, default = 1
      ActuationStrength = 0;
      # enable tap to click
      Clicking = true;
      # firmness 0 for light clicking, 1 for medium, 2 for firm.
      FirstClickThreshold = 1;
      # firmness level for force touch
      SecondClickThreshold = 1;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
    };

    # firewall settings
    alf = {
      # 0 = disabled 1 = enabled 2 = blocks all connections except for essential services
      globalstate = 0;
      loggingenabled = 0;
      # stealthenabled = 1;
    };

    # dock settings
    dock = {
      # auto show and hide dock
      autohide = true;
      # remove delay for showing dock
      autohide-delay = "0.0";
      # how fast is the dock showing animation
      autohide-time-modifier = "0.0";
      dashboard-in-overlay = false;
      expose-animation-duration = "0.01";
      expose-group-by-app = false;
      orientation = "bottom";
      show-process-indicators = true;
      show-recents = true;
      minimize-to-application = false;
      mru-spaces = false;
      launchanim = false;
      tilesize = 50;
      static-only = false;
      showhidden = false;
    };

    NSGlobalDomain = {
      # tap to click
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.sound.beep.feedback" = 0;
      # Sets the beep/alert volume level from 0.000 (muted) to 1.000 (100% volume).
      "com.apple.sound.beep.volume" = "0.6065307";
      "com.apple.trackpad.enableSecondaryClick" = true;
      # trackpad tracking speed 0-3
      "com.apple.trackpad.scaling" = "2.8";
      # Enable spring loading for directories
      "com.apple.springing.enabled" = true;
      # Remove the spring loading delay for directories
      "com.apple.springing.delay" = "0";
      # allow key repeat
      ApplePressAndHoldEnabled = false;
      AppleShowAllFiles = true;
      AppleMeasurementUnits = "Centimeters";
      AppleTemperatureUnit = "Celsius";

      # trackpad swipe nav
      # AppleEnableSwipeNavigateWithScrolls = false

      # magic mouse swipe nav
      AppleEnableMouseSwipeNavigateWithScrolls = false;

      # Enable subpixel font rendering on non-Apple LCDs
      # Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
      AppleFontSmoothing = 1;

      # dark light auto
      AppleInterfaceStyle = null;
      AppleInterfaceStyleSwitchesAutomatically = true;

      AppleKeyboardUIMode = 3;

      KeyRepeat = 1;
      InitialKeyRepeat = 10;

      # disable auto terminalion of inactive app
      NSDisableAutomaticTermination = true;

      # save doc to icloud
      NSDocumentSaveNewDocumentsToCloud = false;

      # expand save panel by default
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;

      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;

      # window open/close animation
      NSAutomaticWindowAnimationsEnabled = false;
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Automatic";
      # Sets the size of the finder sidebar icons: 1 (small), 2 (medium) or 3 (large). The default is 3.
      NSTableViewDefaultSizeMode = 2;
      # Whether to display ASCII control characters using caret notation in standard text views. The default is false.
      NSTextShowsControlCharacters = true;
      # Whether to enable the focus ring animation. The default is true.
      NSUseAnimatedFocusRing = false;
      # Whether to enable smooth scrolling. The default is true.
      NSScrollAnimationEnabled = true;
      NSWindowResizeTime = "0.001";
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
}
