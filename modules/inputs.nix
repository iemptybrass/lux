{ lib, config, ... }:

with lib;

let
  cfg = config;

  reg = "^[a-zA-Z0-9_-]{1,32}$";
  url = "^[a-zA-Z]{1,39}:[a-zA-Z0-9-]{1,39}/[-a-zA-Z0-9._/]+$";

  regex = x: y:
    if builtins.isList y 
      then
        all (a: builtins.match x a != null) y
      else
        builtins.match x y != null;

  get = x: y: map (i: i.${x}) (attrValues y);

  check = x: y: z:
    let
      a = 
        if x == "names" 
          then
            attrNames
          else
            inputs: map (i: i.${x}) (attrValues inputs);
    in
      all (b:
        regex y (a z.${b}.inputs)
      ) (attrNames z);

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
