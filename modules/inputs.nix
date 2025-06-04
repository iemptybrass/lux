{ lib, ... }:

with lib;

{
  options.inputs = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          url = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
          type = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
          owner = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
          repo = lib.mkOption {
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
