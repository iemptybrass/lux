{ lib, ... }:

with lib;

{
  options.outputs = mkOption {
    type = types.submodule {
      options = {
        modules = mkOption {
          type = types.listOf types.unspecified;
          default = [];
          description = "Fake outputs.modules list.";
        };
      };
    };
    default = {};
    description = "Fake Flake-like outputs with modules.";
  };

  config = {};
}
