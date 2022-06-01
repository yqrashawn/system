{ config, lib, pkgs, ... }: {
  programs.git = {
    userEmail = "holybasil@gmail.com";
    userName = "holybasil";
    signing = {
      key = "holybasil@gmail.com";
      signByDefault = true;
    };
  };
}
