{ config, lib, pkgs, ... }: {
  programs.git = {
    userEmail = "kennan@case.edu";
    userName = "Rashawn Zhang";
    signing = {
      key = "kennan@case.edu";
      signByDefault = true;
    };
  };
}
