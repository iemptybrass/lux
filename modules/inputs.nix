{ lib, config, ... }:

with lib;

let
  cfg = config;

  reg = "^[a-zA-Z0-9_-]+$";
  url = "^[a-zA-Z]{1,39}:[a-zA-Z0-9-]{1,39}/[-a-zA-Z0-9._/]+$";

  regex = pattern: value:
    if builtins.isList value 
      then
        all (str: builtins.match pattern str != null) value
      else
        builtins.match pattern value != null;

  get = field: value: map (i: i.${field}) (attrValues value);

  check = what: pattern: outerInputs:
    let
      extractor = 
        if what == "names" 
          then
            attrNames
          else
            inputs: map (i: i.${what}) (attrValues inputs);
    in
      all (outerName:
        regex pattern (extractor outerInputs.${outerName}.inputs)
      ) (attrNames outerInputs);

in
{
  options.inputs = mkOption {
    default = {};
    type = types.attrsOf (types.submodule {
      options = {
        url = mkOption {
          type = types.str;
          default = ""; };
        nixosModules = mkOption {
          type = types.str;
          default = ""; };
        inputs = mkOption {
          default = {};
          type = types.attrsOf (types.submodule {
            options = {
              follows = mkOption {
                type = types.str;
                default = ""; }; }; }  ); }; }; }  );
  };

  config = {
    assertions = [
      {
        assertion = regex reg (attrNames cfg.inputs);
        message = "All input names must be a maximum of 32 letters (a-z, A-Z).";
      }
      {
        assertion = check "names" reg cfg.inputs;
        message = "All inner input names must be a maximum of 32 letters (a-z, A-Z).";
      }
      {
        assertion = check "follows" reg cfg.inputs;
        message = "Each follows must be a non-empty string with a maximum of 32 letters.";
      }
      {
        assertion = regex url (get "url" cfg.inputs);
        message = "Each input.{name}.url must match 'owner:repo/path' format.";
      }
      {
        assertion = regex reg (get "nixosModules" cfg.inputs);
        message = "Each input.{name}.nixosModules must be a valid filename.";
      }
    ];
  };
}
