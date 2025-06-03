{
  outputs = { self, nixpkgs }: {
    nixosModules.lux = ./modules/lux.nix;
    nixosModules.inputs = ./modules/inputs.nix;
  };
}
