{
  outputs = { self, nixpkgs }: {
    nixosModules = {
      common = ./modules/common.nix;
    };
  };
}
