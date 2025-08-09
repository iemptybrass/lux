{pkgs, ...}: {
  imports = [
    ./inputs.nix
  ];

  #environment.variables.PATH = [
  #  "/etc/rebuild"
  #  "$PATH"
  #];
#
  #security.sudo.extraConfig = ''
  #  Defaults secure_path="/etc/rebuild:/run/wrappers/bin:/run/current-system/sw/bin"
  #  Defaults env_keep += "PATH"
  #'';

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "nixos-rebuild";
      runtimeInputs = [ pkgs.nix ];
      text = ''
        #!/usr/bin/env bash
        set -euo pipefail
        REAL="${pkgs.nixos-rebuild}/bin/nixos-rebuild"
        exec "$REAL" "$@"
      '';

    })
  ];

  #environment.etc."rebuild".source = pkgs.runCommand "rebuild-scripts" {} ''
  #  mkdir -p $out
  #  cp -r ${./rebuild}/* $out/
  #  find $out -type f -exec chmod +x {} \;
  #'';
}
