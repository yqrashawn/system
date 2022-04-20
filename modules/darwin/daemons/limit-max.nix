{ config, lib, pkgs, ... }:

{
  launchd.daemons = {
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
  };
}
