{
  nixConfig = {
    extra-substituters = [
      "https://yueyinqiu.cachix.org"
    ];
    extra-trusted-public-keys = [
      "yueyinqiu.cachix.org-1:iooLFYpS7e6KAU4+QM5Zoj6Tq76jRGo+kjeAbu8JxAc="
    ];
  };

  inputs = {
    import-tree.url = "github:denful/import-tree";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-daemon-proxy.url = "github:yueyinqiu/NixDaemonProxy-Nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    user-tun.url = "github:yueyinqiu/UserTun";
  };

  outputs = inputs: {
    nixosConfigurations.erthane =
      let
        system = "x86_64-linux";
      in
      inputs.nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {
        };
        modules = [
          inputs.nix-daemon-proxy.nixosModules.nix-daemon-proxy
          inputs.nixos-hardware.nixosModules.dell-latitude-7490
          inputs.user-tun.nixosModules.user-tun
          (inputs.import-tree ./src)
        ];
      };

    devShells = inputs.nixpkgs.lib.genAttrs inputs.nixpkgs.lib.systems.flakeExposed (system: {
      default = import ./dev {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      };
    });
  };
}
