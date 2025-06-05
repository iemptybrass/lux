{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    lua = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf config.lua.enable {
    environment.etc."lux/init.lua" = {
      text = ''
        #!/usr/bin/env bash
        echo "preprocessing configuration files..."
      '';
      mode = "0755";
    };  };
}
