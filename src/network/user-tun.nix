{ ... }:
{
  services.user-tun.single-user = {
    enable = true;
    upstreamPort = 43007;
  };

  services.openssh.enable = true;
}