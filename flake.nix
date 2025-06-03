{
  outputs = { self, nixpkgs }: {
    nixosModules.enable = ./modules/common.nix;
  };
}
