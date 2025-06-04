{ lib, ... }:

with lib;

{
  options.inputs = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        freeformType = null; 
        options = {
          url = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
          nixosModules = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
          inputs = lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.submodule {
                options = {
                  follows = lib.mkOption {
                    type = lib.types.str;
                    default = "";
                  };
                };
              }
            );
            default = {};
          };
        };
      }
    );
    default = {};
  };

  config = {};
}
