{ ... }:
{
  services.user-tun.single-user = {
    enable = true;
  };

  services.openssh.enable = true;
}