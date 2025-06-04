{ lib, ... }:

with lib;

{
  options.inputs = lib.mkOption {
    type = lib.types.str;
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
