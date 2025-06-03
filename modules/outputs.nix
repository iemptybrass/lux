{ lib, ... }:

with lib;

{
  options.outputs.modules = lib.mkOption {
    type = lib.types.str;
    default = "";
  };

  config = {};
}
