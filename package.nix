{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "nixos-rebuild";
  src = ./src;

  installPhase = ''
    ls
  '';
}
