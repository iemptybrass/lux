{ lib, config, ... }:

with lib;

{
  options.inputs = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether to enable inputs.";
  };

  config = {
    assertions = [
      {
        assertion = config.inputs == true || config.inputs == false;
      }
    ];
  };
}
