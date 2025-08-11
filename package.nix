{pkgs}:
pkgs.stdenv.mkDerivation {
  name = "nixos-rebuild";
  src = ./src;

  installPhase = ''
    ls
  '';
}
