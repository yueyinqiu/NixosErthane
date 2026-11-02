{ config, ... }:
let
  home = config.users.users.yueyinqiu.home;
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

  security.audit.rules = [
    "-w ${home}/.config/systemd/user -p wa -k yueyinqiu_systemd"
    "-w ${home}/.local/share/nix -p wa -k yueyinqiu_nix"
    "-w ${home}/.config/autostart -p wa -k yueyinqiu_autostart"
  ];

  systemd.tmpfiles.rules = [
    "d ${home}/.config/systemd/user 0755 yueyinqiu users -"
    "d ${home}/.local/share/nix 0755 yueyinqiu users -"
    "d ${home}/.config/autostart 0755 yueyinqiu users -"
  ];
}
