{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux"];
    forAll = nixpkgs.lib.genAttrs systems;
  in {
    packages = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      script = builtins.readFile ./modules/rebuild/test.sh;
      real = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
    in {
      nixos-rebuild = pkgs.writeShellApplication {
        name = "nixos-rebuild";
        text = builtins.replaceStrings ["@NIXOS_REBUILD@"] [real] script;
      };
    });

    nixosModules.default = {pkgs, ...}: {
      environment.systemPackages = [self.packages.${pkgs.stdenv.hostPlatform.system}.nixos-rebuild];
    };

    lib.mkSystem = {
      system,
      modules ? [],
      ...
    } @ args:
      nixpkgs.lib.nixosSystem ({
          inherit system;
          modules = [self.nixosModules.default] ++ modules;
        }
        // (builtins.removeAttrs args ["system" "modules"]));
  };
}
