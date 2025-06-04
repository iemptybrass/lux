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
              let
                urlSet = config.url != "";
                typeSet = config.type != "";
                ownerSet = config.owner != "";
                repoSet = config.repo != "";

                anySet = typeSet || ownerSet || repoSet;
                allSet = typeSet && ownerSet && repoSet;

                invalid =
                  if anySet then
                    urlSet || (!allSet)
                  else
                    !urlSet;
              in
                !invalid
            ) ''
              Invalid flake input setup:
              - If `type`, `owner`, or `repo` are set, `url` must be unset and all of `type`, `owner`, `repo` must be set.
              - Otherwise, `url` must be set and `type`, `owner`, `repo` must be unset.
            ''
          ))
        ];
      })
    );
    default = {};
  };

  config._forceInputsEval = lib.mkForce config.inputs;
}
