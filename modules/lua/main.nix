{
    environment.etc."lux/init.lua" = {
      text = ''
        #!/usr/bin/env bash
        echo "preprocessing configuration files..."
      '';
      mode = "0755";
    };
}