{ ... }:
{
  boot.kernelParams = [
    # fixes 'ath10k_pci 0000:02:00.0 AER: Error of this Agent is reported first'.
    "pcie_aspm=off"

    # fixes display flip stalls and frame drops
    "i915.enable_dc=0"
  ];
}
