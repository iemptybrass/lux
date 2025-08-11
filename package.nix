{pkgs}:
pkgs.stdenv.mkDerivation {
  name = "nixos-rebuild-test";
  src = ./src;

  installPhase = ''
    install -Dm755 nixos-rebuild.sh "$out/bin/nixos-rebuild"
    substituteInPlace "$out/bin/nixos-rebuild" \
      --replace '@NIXOS_REBUILD@' ${pkgs.nixos-rebuild}/bin/nixos-rebuild
  '';
}
