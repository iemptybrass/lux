{ lib, ... }:

with lib;

{
  options.outputs.modules = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.attrsOf (     
        lib.types.attrsOf (   
          lib.types.unspecified 
        )
      )
    );
    default = {};
  };

  config = {};
}
