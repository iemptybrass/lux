{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.lux;
in
{
  options.lux = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable pre-rebuild hook and nixos-rebuild wrapper.";
    };
  };

  config = mkIf cfg.enable {
    environment.etc."rebuild/hooks/pre-rebuild.sh" = {
      text = ''
        #!/usr/bin/env bash
        echo "[FREAKY] activating tickle monster..."
      '';
      mode = "0755";
    };

    environment.etc."rebuild/bin/nixos-rebuild" = {
      text = ''
        #!/usr/bin/env bash
        /etc/rebuild/hooks/pre-rebuild.sh || {
          echo "[HOOK] Failed. Aborting rebuild."
          exit 1
        }
        exec /run/current-system/sw/bin/nixos-rebuild "$@"
      '';
      mode = "0755";
    };

    environment.variables.PATH = [
      "/etc/rebuild/bin"
      "$PATH"
    ];

    security.sudo.extraConfig = ''
      Defaults secure_path="/etc/rebuild/bin:/run/wrappers/bin:/run/current-system/sw/bin"
      Defaults env_keep += "PATH"
    '';
  };
}
