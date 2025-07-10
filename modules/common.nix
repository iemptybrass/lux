{ pkgs, ... }:{
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

  environment.etc."rebuild".source = pkgs.runCommand "rebuild-scripts" {} ''
    mkdir -p $out
    cp -r ${./rebuild}/* $out/
    chmod +x $out/{nixos-rebuild, run/init.sh}
  '';
}
