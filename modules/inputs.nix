{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types attrNames attrValues all;

  cfg = config;

  reg = "^[a-zA-Z0-9_-]+$";
  url = "^[a-zA-Z]{1,39}:[a-zA-Z0-9-]{1,39}/[-a-zA-Z0-9._/]+$";

  error = "Check your .lix file for option formatting!";

  regex = regex: value:
    if builtins.isList value
    then all (str: builtins.match regex str != null) value
    else builtins.match regex value != null;

  get = field: value: map (i: i.${field}) (attrValues value);

  check = what: pattern: inputs: let
    extract =
      if what == "names"
      then attrNames
      else inputs: map (i: i.${what}) (attrValues inputs);
  in
    all (
      name:
        regex pattern (extract inputs.${name}.inputs)
    ) (attrNames inputs);
in {
  options.inputs = mkOption {
    default = {};
    type = types.attrsOf (types.submodule {
      options = {
        url = mkOption {
          type = types.str;
          default = "";
        };
        nixosModules = mkOption {
          type = types.str;
          default = "";
        };
        inputs = mkOption {
          default = {};
          type = types.attrsOf (types.submodule {
            options = {
              follows = mkOption {
                type = types.str;
                default = "";
              };
            };
          });
        };
      };
    });
  };

  config = {
    assertions = [
      {
        assertion = regex reg (attrNames cfg.inputs);
        message = error;
      }
      {
        assertion = regex url (get "url" cfg.inputs);
        message = error;
      }
      {
        assertion = regex reg (get "nixosModules" cfg.inputs);
        message = error;
      }
      {
        assertion = check "names" reg cfg.inputs;
        message = error;
      }
      {
        assertion = check "follows" reg cfg.inputs;
        message = error;
      }
    ];
  };
}
