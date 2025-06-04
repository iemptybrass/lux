{ lib, ... }:

with lib;

{
  options.inputs = lib.mkOption {
    type = lib.types.str;
    default = "a";
    description = "A single upper or lowercase letter.";
  };

  config = {
    assertions = [
      {
        assertion = builtins.match "^[a-zA-Z]$" config.inputs != null;
      }
    ];
  };
}
