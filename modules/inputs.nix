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
        assertion = all (name:
          builtins.match "^[a-zA-Z]{1,32}$" name != null
        ) (builtins.attrNames cfg.inputs);
        message = "All input names must be 1–32 letters (a-z, A-Z) only.";
      }
      {
        assertion = all (name:
          let value = cfg.inputs.${name}.url; in
            builtins.isString value &&
            builtins.match "^[a-zA-Z]{1,39}:[a-zA-Z0-9-]{1,39}/[a-zA-Z0-9-._/]$" value != null
        ) (builtins.attrNames cfg.inputs);
        message = "Each input.url must match 'owner:repo/path' format.";
      }
    ];
  };
}
