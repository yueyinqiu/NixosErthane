{ config, ... }:
{
  systemd.services.nix-store-verify = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${config.nix.package}/bin/nix store verify --all --no-trust";
      Nice = 19;
      IOSchedulingClass = "idle";
    };
  };

  systemd.timers.nix-store-verify = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };
}
