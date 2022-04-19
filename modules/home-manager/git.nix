{ config, lib, pkgs, ... }: {
  home.packages = [ pkgs.github-cli ];
  programs.git = {
    userName = "Rashawn Zhang";
    extraConfig = {
      credential.helper =
        if pkgs.stdenvNoCC.isDarwin then
          "osxkeychain"
        else
          "cache --timeout=1000000000";
      commit.verbose = true;
      fetch.prune = true;
      http.sslVerify = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      push.followTags = true;
    };
    aliases = {
      fix = "commit --amend --no-edit";
      oops = "reset HEAD~1";
      sub = "submodule update --init --recursive";
    };
    delta = {
      enable = true;
      options = {
        side-by-side = true;
        line-numbers = true;
      };
    };
    lfs.enable = true;
  };
}
