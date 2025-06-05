{ lib, config, ... }:

with lib;

let
  cfg = config;

  reg = "^[a-zA-Z]{1,32}$";
  url = "^[a-zA-Z]{1,39}:[a-zA-Z0-9-]{1,39}/[-a-zA-Z0-9._/]+$";

  checkNames = names: all (n: builtins.match reg n != null) names;
  checkFollows = inputs:
    all (f: builtins.match reg f != null)
      (map (i: i.follows) (attrValues inputs));
  checkUrls = inputs:
    all (i: builtins.match url i.url != null) (attrValues inputs);
in
{
  options.inputs = mkOption {
    default = {};
    type = types.attrsOf (types.submodule {
      options = {
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
        url = mkOption {
          type = types.str;
          default = "";
        };
      };
    });
  };

  config = {
    assertions = [
      {
        assertion = checkNames (attrNames cfg.inputs);
        message = "All input names must be a maximum of 32 letters (a-z, A-Z).";
      }
      {
        assertion = all (outerName:
          checkNames (attrNames cfg.inputs.${outerName}.inputs)
        ) (attrNames cfg.inputs);
        message = "All input names must be a maximum of 32 letters (a-z, A-Z).";
      }
      {
        assertion = all (outerName:
          checkFollows (cfg.inputs.${outerName}.inputs)
        ) (attrNames cfg.inputs);
        message = "Each follows must be a non-empty string with maximum of 32 letters letters.";
      }
      {
        assertion = checkUrls cfg.inputs;
        message = "Each input.{name}.url must match 'owner:repo/path' format.";
      }
    ];
  };
}
