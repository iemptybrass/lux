{ lib, ... }:

with lib;

{
  options.inputs = lib.mkOption {
    type = lib.types.unspecified;
    default = "";
  };

  config = {
    assertions = [
      {
        assertion = config.inputs == "" || builtins.match "^[a-zA-Z]$" config.inputs != null;
       }
    ];
  };
}
