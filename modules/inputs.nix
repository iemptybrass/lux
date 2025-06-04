{ lib, ... }:

with lib;

{
  options.inputs = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether to enable inputs.";
  };

  config = {
    # Example of how you could use it
    assertions = [
      {
        assertion = config.inputs == true || config.inputs == false;
        message = "inputs must be a boolean.";
      }
    ];
  };
}
