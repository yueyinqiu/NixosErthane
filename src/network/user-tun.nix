{ ... }:
{
  services.user-tun.single-user = {
    enable = true;
    upstreamPort = 16884;
  };

  services.openssh.enable = true;
}