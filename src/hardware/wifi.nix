{ ... }:
{
  # fixes 'ath10k_pci 0000:02:00.0 AER: Error of this Agent is reported first'.
  boot.kernelParams = [ "pcie_aspm=off" ];
}
