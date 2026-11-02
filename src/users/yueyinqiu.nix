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
      "libvirtd"
      "libvirt"
      "kvm"
      "user-tun-controller"
    ];
  };

  # 该用户申请由 root 代为监控的路径，用于发现持久化
  # （systemd 用户单元、自启动项、nix profile）
  security.audit.rules = [
    "-w ${home}/.config/systemd/user -p wa -k yueyinqiu_systemd"
    "-w ${home}/.local/share/nix -p wa -k yueyinqiu_nix"
    "-w ${home}/.config/autostart -p wa -k yueyinqiu_autostart"
  ];

  # audit 的 watch 绑定的是加载规则那一刻的 inode：路径不存在时该条规则会被跳过，
  # 之后目录再出现也不会被监控。所以先保证被监控的目录存在。
  systemd.tmpfiles.rules = [
    "d ${home}/.config/systemd/user 0755 yueyinqiu users -"
    "d ${home}/.local/share/nix 0755 yueyinqiu users -"
    "d ${home}/.config/autostart 0755 yueyinqiu users -"
  ];
}
