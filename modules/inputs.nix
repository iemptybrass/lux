{ lib, config, ... }:

with lib;


let
  cfg = config;
in
{
  options.inputs = lib.mkOption {
    type = lib.types.unspecified;
    default = "";
  };

  config = {
    assertions = [
      {
        assertion = cfg.inputs == "" || builtins.match "^[a-zA-Z]{1,32}$" cfg.inputs != null;
        message = " test ";
       }
    ];
  };
}
