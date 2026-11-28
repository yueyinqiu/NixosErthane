{ config, ... }:
let
  home = config.users.users.yueyinqiu.home;

  audit = [
    {
      path = ".config";
      mode = "0755";
      watch = false;
    }
    {
      path = ".config/autostart";
      mode = "0755";
      watch = true;
    }
    {
      path = ".config/environment.d";
      mode = "0755";
      watch = true;
    }
    {
      path = ".config/systemd";
      mode = "0755";
      watch = false;
    }
    {
      path = ".config/systemd/user";
      mode = "0755";
      watch = true;
    }

    {
      path = ".local";
      mode = "0755";
      watch = false;
    }
    {
      path = ".local/share";
      mode = "0755";
      watch = false;
    }
    {
      path = ".local/share/dbus-1";
      mode = "0755";
      watch = false;
    }
    {
      path = ".local/share/dbus-1/services";
      mode = "0755";
      watch = true;
    }
    {
      path = ".local/share/applications";
      mode = "0755";
      watch = true;
    }
    {
      path = ".local/share/nix";
      mode = "0755";
      watch = true;
    }
    {
      path = ".local/share/systemd";
      mode = "0755";
      watch = false;
    }
    {
      path = ".local/share/systemd/user";
      mode = "0755";
      watch = true;
    }
  ];
in
{
  users.users.yueyinqiu = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "networkmanager"
      "user-tun-controller"
    ];
  };

  security.audit.rules = map (w: "-w ${home}/${w.path} -p wa -k yueyinqiu") (builtins.filter (d: d.watch) audit);

  systemd.tmpfiles.rules = map (w: "d ${home}/${w.path} ${w.mode} yueyinqiu users -") audit;
}
