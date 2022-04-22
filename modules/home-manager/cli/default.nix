{ config, inputs, pkgs, lib, ... }:
let
  functions = builtins.readFile ./functions.sh;
  useSkim = true;
  useFzf = !useSkim;
  fuzz = let fd = "${pkgs.fd}/bin/fd";
  in rec {
    defaultCommand = "${fd} -H --type f";
    defaultOptions = [ "--height 50%" ];
    fileWidgetCommand = "${defaultCommand}";
    fileWidgetOptions = [
      "--preview '${pkgs.bat}/bin/bat --color=always --plain --line-range=:200 {}'"
    ];
    changeDirWidgetCommand = "${fd} --type d";
    changeDirWidgetOptions =
      [ "--preview '${pkgs.tree}/bin/tree -C {} | head -200'" ];
    # historyWidgetOptions = [ "--tac" "--exact" ];
    historyWidgetOptions = [ ];
  };
  aliases = lib.mkIf pkgs.stdenvNoCC.isDarwin {
    # darwin specific aliases
    ibrew = "arch -x86_64 brew";
    abrew = "arch -arm64 brew";
    d = "cd ~/Downloads/";
    wo = "cd ~/workspace/office";
    wt = "cd ~/workspace/third";
    wh = "cd ~/workspace/home";
    o = "open";
    p2 = "percol";
    cleanup = "find . -type f -name '*.DS_Store' -ls -delete";
    reload = "exec $SHELL -l";
    rreload = "rm -rf ~/.cache/prezto/zcompdump && exec $SHELL -l";
    cd = "z";
    j = "z";

    l = "exa -al";
    # ls = "exa -a";
    lsa = "exa -abghl --git --color=automatic";
    lsd = "exa -l --color=automatic | grep --color=never '^d'";
    lst = "exa --sort=created --time=created --long --all -r | sed 15q";
  };
in {
  home.packages = [ pkgs.tree ];
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      # enableZshIntegration = true;
      nix-direnv.enable = true;
      stdlib = ''
        # stolen from @i077; store .direnv in cache instead of project dir
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            echo "''${direnv_layout_dirs[$PWD]:=$(
                echo -n "${config.xdg.cacheHome}"/direnv/layouts/
                echo -n "$PWD" | shasum | cut -d ' ' -f 1
            )}"
        }
      '';
    };
    skim = {
      enable = useSkim;
      enableBashIntegration = useSkim;
      enableZshIntegration = useSkim;
      enableFishIntegration = useSkim;
    } // fuzz;
    fzf = {
      enable = useFzf;
      enableBashIntegration = useFzf;
      enableZshIntegration = useFzf;
      enableFishIntegration = useFzf;
    } // fuzz;
    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        color = "always";
      };
    };
    mcfly = {
      enable = true;
      keyScheme = "vim";
      enableFuzzySearch = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
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
    bash = {
      enable = true;
      shellAliases = aliases;
      initExtra = ''
        ${functions}
      '';
      profileExtra = ''
          ${
            lib.optionalString pkgs.stdenvNoCC.isLinux
            "[[ -e /etc/profile ]] && source /etc/profile"
          }
          [[ ! -f ~/Dropbox/sync/sync.zsh ]] || source ~/Dropbox/sync/sync.zsh
        export JAVVA_INDEX='https://github.com/yqrashawn/jabba/raw/master/index.json'
        [ -s $HOME/.jabba/jabba.sh ] && source $HOME/.jabba/jabba.sh && jabba use adopt@1.11.0-11
      '';
    };
    nix-index.enable = true;
    zsh = let
      mkZshPlugin = { pkg, file ? "${pkg.pname}.plugin.zsh" }: rec {
        name = pkg.pname;
        src = pkg.src;
        inherit file;
      };
    in {
      enable = true;
      autocd = true;
      # enableSyntaxHighlighting = true;
      enableAutosuggestions = true;
      shellGlobalAliases = {
        UUID = "$(uuidgen | tr -d \\n)";
        G = "| grep";
      };
      dirHashes = {
        home = "$HOME";
        docs = "$HOME/Documents";
        vids = "$HOME/Videos";
        dl = "$HOME/Downloads";
      };
      localVariables = {
        LANG = "en_US.UTF-8";
        GPG_TTY = "/dev/ttys000";
        DEFAULT_USER = "${config.home.username}";
        CLICOLOR = 1;
        EDITOR = "emacsclient";
        VISUAL = "emacsclient";
        LS_COLORS = "ExFxBxDxCxegedabagacad";
        TERM = "xterm-256color";
      };
      shellAliases = aliases;
      initExtra = ''
        # Stop TRAMP (in Emacs) from hanging or term/shell from echoing back commands
        #if [[ $TERM == dumb || -n $INSIDE_EMACS ]]; then
        #  unsetopt zle prompt_cr prompt_subst
        #  whence -w precmd >/dev/null && unfunction precmd
        #  whence -w preexec >/dev/null && unfunction preexec
        #  PS1='$ '
        #fi

        ${functions}
        ${lib.optionalString pkgs.stdenvNoCC.isDarwin ''
          if [[ -d /opt/homebrew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
          fi
        ''}
        unset RPS1
        [[ ! -f ~/.local.zsh ]] || source ~/.local.zsh
      '';
      profileExtra = ''
          ${
            lib.optionalString pkgs.stdenvNoCC.isLinux
            "[[ -e /etc/profile ]] && source /etc/profile"
          }
          [[ ! -f ~/Dropbox/sync/sync.zsh ]] || source ~/Dropbox/sync/sync.zsh
        export JAVVA_INDEX='https://github.com/yqrashawn/jabba/raw/master/index.json'
        [ -s $HOME/.jabba/jabba.sh ] && source $HOME/.jabba/jabba.sh && jabba use adopt@1.11.0-11
      '';
      plugins = [
        {
          name = "fast-syntax-highlighting";
          file = "fast-syntax-highlighting.plugin.zsh";
          src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
        }
        {
          # https://github.com/starship/starship/issues/1721#issuecomment-780250578
          # stop eating lines this is not pacman
          name = "zsh-vi-mode";
          file = "zsh-vi-mode.plugin.zsh";
          src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode/";
        }
        {
          name = "alias-tips";
          src = inputs.zsh-alias-tips;
        }
        # {
        #   name = "zsh-abbrev-alias";
        #   src = inputs.zsh-abbrev-alias;
        #   file = "abbrev-alias.plugin.zsh";
        # }
      ];
      oh-my-zsh = {
        enable = true;
        plugins = [ "direnv" "aliases" "emacs" "yarn" "globalias" ];
      };
      prezto = { enable = true; };
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    starship = {
      enable = true;
      package = pkgs.stable.starship;
    };
    tmux = {
      enable = true;
      extraConfig = "source ~/.tmux/.tmux.conf";
      # extraConfig = builtins.readFile "${config.home.homeDirectory}/.tmux.conf";
    };

  };
}
