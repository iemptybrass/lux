{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    lux = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf config.lux.enable {
    environment.etc."rebuild/hooks/pre-rebuild.sh" = {
      text = ''
        #!/usr/bin/env bash
        LUX_FILE="/etc/rebuild/lux"
        if [[ -f "$LUX_FILE" && "$(cat "$LUX_FILE")" == "1" ]]; then
          :
        else
          echo "[LUX] First time activation, rerun for changes to take effect..."
          echo "1" > "$LUX_FILE"
        fi
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
