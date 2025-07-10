{
  imports = [
  ./inputs.nix
  ];

  environment.variables.PATH = [
    "/etc/rebuild/bin"
    "$PATH"
  ];

  security.sudo.extraConfig = ''
    Defaults secure_path="/etc/rebuild/bin:/run/wrappers/bin:/run/current-system/sw/bin"
    Defaults env_keep += "PATH"
  '';
}
