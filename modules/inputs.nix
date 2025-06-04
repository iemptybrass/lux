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

        anyOfTypeOwnerRepoSet = typeSet || ownerSet || repoSet;
        allOfTypeOwnerRepoSet = typeSet && ownerSet && repoSet;

        invalid = if anyOfTypeOwnerRepoSet then
          # If any of type/owner/repo are set
          (!(allOfTypeOwnerRepoSet) || urlSet)
        else
          # none set: require url set
          (!urlSet);
      in
        !invalid
    ) ''
      You must either:
      - Set only `url` (and leave `type`, `owner`, and `repo` empty), or
      - Set all of `type`, `owner`, and `repo` (and leave `url` empty).
    ''
  ))
];

      })
    );
    default = {};
  };

  config = {};
}
