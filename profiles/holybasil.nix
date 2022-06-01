{ config, lib, pkgs, ... }: {
  user.name = "bolybasil";
  hm = { imports = [ ./home-manager/yqrashawn.nix ]; };
}
