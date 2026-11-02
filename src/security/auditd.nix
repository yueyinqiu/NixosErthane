{ ... }:
{
  security.audit.enable = true;
  security.auditd.enable = true;
  security.audit.rules = [
    "-w /home/yueyinqiu/.config/systemd/user -p wa -k user_systemd"
    "-w /home/yueyinqiu/.local/share/nix -p wa -k user_nix"
    "-w /home/yueyinqiu/.local/share/nix/nix-update -p r -k user_nix_update_read"
    "-w /home/yueyinqiu/.config/autostart -p wa -k user_autostart"
  ];
}
