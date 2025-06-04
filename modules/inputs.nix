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
            description = "URL of the flake input.";
          };
          type = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Type of the flake input (e.g., github).";
          };
          owner = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Owner of the repository.";
          };
          repo = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Repository name.";
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
      }
    );
    default = {};
  };

  config = {};
}
