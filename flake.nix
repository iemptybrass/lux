{
  outputs = { self, nixpkgs }: {
    nixosModules.lux = ./modules/lux.nix;
  };
}
