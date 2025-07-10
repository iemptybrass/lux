{
  imports = [
  ./inputs.nix
  ];

  environment.variables.PATH = [
    "/etc/rebuild"
    "$PATH"
  ];

  security.sudo.extraConfig = ''
    Defaults secure_path="/etc/rebuild:/run/wrappers/bin:/run/current-system/sw/bin"
    Defaults env_keep += "PATH"
  '';

  environment.etc."rebuild".source = ./rebuild;
}
