{
    environment.etc."rebuild/hooks/pre-rebuild.sh" = {
      text = ''
        #!/usr/bin/env bash
        echo "preprocessing configuration files..."
      '';
      mode = "0755";
    };

    environment.etc."rebuild/bin/nixos-rebuild.sh" = {
      text = ''
        #!/usr/bin/env bash
        /etc/rebuild/hooks/pre-rebuild.sh || {
          echo "preprocessor failed aborting rebuild..."
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
}
