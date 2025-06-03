{ lib, ... }:

with lib;

{
  options.outputs = mkOption {
    type = lib.types.submodule {
      options = {
        modules = mkOption {
          type = lib.types.listOf lib.types.unspecified;
          default = [];
        };
      };
    };
    default = {};
  };

  config = {};
}
