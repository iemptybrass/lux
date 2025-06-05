{ lib, config, ... }:

with lib;

let
  cfg = config;
in
{
  options.inputs = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        url = lib.mkOption {
          type = lib.types.str;
          default = "";
        };
      };
    });
    default = {};
  };

  config = {
    assertions = [
      {
        assertion = cfg.inputs == "" || builtins.match "^[a-zA-Z]{1,32}$" cfg.inputs != null);
        message = "";
      }
      {
        assertion = cfg.inputs == "" || builtins.match "^[a-zA-Z]{1,39}[:][a-zA-Z0-9-]{1,39}[/][a-zA-Z0-9-._/]$" cfg.inputs != null);
        message = "";
      }
    ];
  };
}
