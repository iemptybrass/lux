{ lib, ... }:

with lib;

{
  options.inputs = lib.mkOption {
    type = lib.types.attrsOf lib.types.strMatching "^[a-z0-9-]+$" (
      lib.types.submodule {
        options = {
          url = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
          follows = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
          nixosModules = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
        };
      }
    );
    default = {};
  };

  config = {};
}
