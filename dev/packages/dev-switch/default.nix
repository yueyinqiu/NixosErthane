{
  name,
  pkgs,
  ...
}:
pkgs.writeShellApplication {
  name = name;
  text = ''
    run0 nix shell nixpkgs#git -c nixos-rebuild switch --flake .
  '';
}
