{ lib, config, ... }:

with lib;

let
  cfg = config;
in
{
  options.inputs = lib.mkOption {
    default = {};
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        inputs = lib.mkOption {
          default = {};
          type = lib.types.attrsOf (lib.types.submodule {
            options = {
              follows = lib.mkOption {
                type = lib.types.str;
                default = "";
              };
            };
          });
        };
        url = lib.mkOption {
          type = lib.types.str;
          default = "";
        };
      };
    });
  };

  config = {

    assertions = [



      {
        assertion = all (outerName:
          builtins.match "^[a-zA-Z]{1,32}$" outerName != null
        ) (builtins.attrNames cfg.inputs);
        message = "All input names must be 1–32 letters (a-z, A-Z).";
      },
      {
        assertion = all (outerName:
          let
            innerNames = builtins.attrNames cfg.inputs.${outerName}.inputs;
          in
            all (innerName:
              builtins.match "^[a-zA-Z]{1,32}$" innerName != null
            ) innerNames
        ) (builtins.attrNames cfg.inputs);
        message = "All input names must be 1–32 letters (a-z, A-Z).";
      },

      {
        assertion = all (outerName:
          let
            innerNames = builtins.attrNames cfg.inputs.${outerName}.inputs;
          in
            all (innerName:
              let
                value = cfg.inputs.${outerName}.inputs.${innerName}.follows;
              in
                builtins.match "^[a-zA-Z]{1,32}$" value != null
            ) innerNames
        ) (builtins.attrNames cfg.inputs);
        message = "Each follows must be a non-empty string of 1–32 letters.";
      },



      {
        assertion = all (outerName:
          let 
            value = cfg.inputs.${outerName}.url; 
          in
            builtins.match "^[a-zA-Z]{1,39}:[a-zA-Z0-9-]{1,39}/[-a-zA-Z0-9._/]+$" value != null
        ) (builtins.attrNames cfg.inputs);
        message = "Each input.{name}.url must match 'owner:repo/path' format.";
      }, 



    ];

  };
}
