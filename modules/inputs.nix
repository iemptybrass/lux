{ lib, config, ... }:

with lib;

let
  cfg = config;

  nameRegex = "^[a-zA-Z]{1,32}$";
  followsRegex = "^[a-zA-Z]{1,32}$";
  urlRegex = "^[a-zA-Z]{1,39}:[a-zA-Z0-9-]{1,39}/[-a-zA-Z0-9._/]+$";

  checkNames = names: all (n: builtins.match nameRegex n != null) names;
  checkFollows = inputs:
    all (f: builtins.match followsRegex f != null)
      (map (i: i.follows) (attrValues inputs));
  checkUrls = inputs:
    all (i: builtins.match urlRegex i.url != null) (attrValues inputs);
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
        message = "All input names must be 1–32 letters (a-z, A-Z).";
      }
      {
        assertion = all (outerName:
          checkNames (attrNames cfg.inputs.${outerName}.inputs)
        ) (attrNames cfg.inputs);
        message = "All inner input names must be 1–32 letters (a-z, A-Z).";
      }
      {
        assertion = all (outerName:
          checkFollows (cfg.inputs.${outerName}.inputs)
        ) (attrNames cfg.inputs);
        message = "Each follows must be a non-empty string of 1–32 letters.";
      }
      {
        assertion = checkUrls cfg.inputs;
        message = "Each input.{name}.url must match 'owner:repo/path' format.";
      }
    ];
  };
}
