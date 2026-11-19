{
  nixConfig = {
    extra-substituters = [
      "https://yueyinqiu.cachix.org"
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
