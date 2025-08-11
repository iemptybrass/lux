{pkgs}:
pkgs.stdenv.mkDerivation {
  name = "nixos-rebuild-test";
  src = ./src;

  installPhase = ''
    install -Dm755 test.sh "$out/bin/nixos-rebuild-test"
    substituteInPlace "$out/bin/nixos-rebuild-test" \
      --replace '@NIXOS_REBUILD@' ${pkgs.nixos-rebuild}/bin/nixos-rebuild
    mv print.sh "$out/bin/"
  '';
}
