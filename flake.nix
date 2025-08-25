{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
    ...
  }: 
  let
    systems = function:
      nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in function pkgs
      );
  in {
    packages = systems (pkgs: {
      nixos-rebuild = pkgs.callPackage ./package.nix { inherit pkgs; };
      default = self.packages.${pkgs.hostPlatform.system}.nixos-rebuild;
  });

    nixosModules.default = {pkgs, ...}: {
      environment.systemPackages = [self.packages.${pkgs.stdenv.hostPlatform.system}.nixos-rebuild];
    };
    test = { nixosConfigurations.nixos; }
}
