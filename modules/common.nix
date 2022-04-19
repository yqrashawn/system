{ inputs, config, lib, pkgs, ... }: {
  imports = [ ./primary.nix ./nixpkgs.nix ./overlays.nix ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
  };

  user = {
    description = "Rashawn Zhang";
    home = "${
        if pkgs.stdenvNoCC.isDarwin then "/Users" else "/home"
      }/${config.user.name}";
    shell = pkgs.zsh;
  };

  # bootstrap home manager using system config
  hm = import ./home-manager;

  # let nix manage home-manager profiles and use global nixpkgs
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    # backupFileExtension = "backup";
  };

  # environment setup
  environment = {
    systemPackages = with pkgs; [
      vim

      # clojure
      clojure
      clojure-lsp
      ispell
      isync
      babashka
      clj-kondo
      joker
      leiningen
      obb
      # nbb

      # tools
      notmuch
      tmux
      zsh
      bash
      git
      neovim
      mu
      # macvim # use vim
      bitwarden-cli
      # firefox
      # firefox-devedition-bin
      sqlite
      yabai
      sketchybar

      # cli tools
      ripgrep
      htop
      hub
      mcfly
      fnm
      shellcheck
      proselint
      trash-cli
      delta
      du-dust
      duf # du
      jq
      fd
      # httpie # failed to build
      tldr
      procs # ps
      bottom # btm htop
      thefuck
      curlie # httpie
      glances # htop
      xh # httpie
      shfmt
      hunspell
      enchant # ispell
      w3m
      starship
      broot # ranger
      direnv
      exa
      fasd
      fzf
      coreutils-full
      pngquant
      rbenv
      jless # json viewer
      gnupg
      zoxide # fasd
      lazygit
      watchexec
      wget
      curl
      # grip # markdown preview, failed to build
      multimarkdown
      brotli
      automake
      autoconf
      bat
      bat-extras.batdiff
      bat-extras.batgrep
      bat-extras.batman
      bat-extras.batwatch
      bat-extras.prettybat
      gnutls
      openssl
      ffmpeg
      pandoc
      cmake
      # goku
      nixfmt
      rnix-lsp

      # langs
      yarn
      lua
      deno
      fennel
      lua
      luarocks
      # zig # marked broken
      go
      plantuml
      rustup

      # entertainment
      youtube-dl
      yt-dlp
      streamlink
      mpv
      you-get

      # lib
      # libgccjit
      rlwrap
      readline
      llvm
      # texinfo # cllision to pod2texi
      pkg-config
      pcre

      # not available
      # du
      # percol
    ];
    etc = {
      home-manager.source = "${inputs.home-manager}";
      nixpkgs.source = "${pkgs.path}";
      stable.source = "${inputs.stable}";
    };
    # list of acceptable shells in /etc/shells
    shells = with pkgs; [ bash zsh fish ];
  };

  fonts.fonts = with pkgs; [ jetbrains-mono ];
}
