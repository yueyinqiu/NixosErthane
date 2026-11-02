{ ... }:
{
  security.audit.enable = true;
  security.auditd.enable = true;

  security.audit.backlogLimit = 8192;

  security.audit.rules = map (path: "-w ${path} -p wa -k system") [
    "/etc/passwd"
    "/etc/shadow"
    "/etc/group"
    "/etc/sudoers"
    "/etc/pam.d"
    "/etc/ssh"
    "/etc/modprobe.d"
    "/etc/modules-load.d"
    "/etc/udev"
    "/etc/sysctl.d"
    "/etc/tmpfiles.d"
    "/root"
  ];
}
