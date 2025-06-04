{ lib, ... }:

with lib;

{
  options.inputs = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule ({ config, ... }: {
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
          nixosModules = lib.mkOption {
            type = lib.types.unspecified;
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

        config = lib.mkMerge [
          (lib.mkIf true (
            lib.mkAssert (
              (config.url != "") || 
              (config.type != "" && config.owner != "" && config.repo != "")
            ) "You must set either `url`, or all of `type`, `owner`, and `repo` for each input."
          ))
        ];
      })
    );
    default = {};
  };

  config = {};
}
