{pkgs}:
pkgs.stdenv.mkDerivation {
  name = "nixos-rebuild";
  src = ./src;

  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 test.sh "$out/bin/nixos-rebuild"
  '';
}
