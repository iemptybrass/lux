{pkgs, ...}: {
  imports = [
    ./inputs.nix
  ];

  #environment.variables.PATH = [
  #  "/etc/rebuild"
  #  "$PATH"
  #];
#
  #security.sudo.extraConfig = ''
  #  Defaults secure_path="/etc/rebuild:/run/wrappers/bin:/run/current-system/sw/bin"
  #  Defaults env_keep += "PATH"
  #'';

environment.systemPackages = [
  (let
     script = builtins.readFile ./rebuild/test.sh;
     real = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
   in pkgs.writeShellApplication {
     name = "nixos-rebuild";
     text = builtins.replaceStrings [ "@NIXOS_REBUILD@" ] [ real ] script;
   })
];

  #environment.etc."rebuild".source = pkgs.runCommand "rebuild-scripts" {} ''
  #  mkdir -p $out
  #  cp -r ${./rebuild}/* $out/
  #  find $out -type f -exec chmod +x {} \;
  #'';
}
