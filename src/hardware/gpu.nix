{ ... }:
{
  # fixes display flip stalls and frame drops
  boot.kernelParams = [ "i915.enable_dc=0" ];
}
