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
            description = "Fake flake input URL.";
          };
          type = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Source type (e.g., github, git, etc).";
          };
          owner = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Repository owner.";
          };
          repo = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Repository name.";
          };
          inputs = lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.submodule {
                options = {
                  follows = lib.mkOption {
                    type = lib.types.str;
                    default = "";
                    description = "Fake follows for nested inputs.";
                  };
                };
              }
            );
            default = {};
            description = "Nested fake flake inputs.";
          };
        };
      }
    );
    default = {};
    description = "Fake Flake-like inputs with url, type, owner, repo, and nested follows.";
  };

  config = {};
}
