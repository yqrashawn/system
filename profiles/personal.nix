{ config, lib, pkgs, ... }: {
  user.name = "yqrashawn";
  hm = { imports = [ ./home-manager/personal.nix ]; };
}
