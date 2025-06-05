{
  imports = [
    ./
  ];
    environment.etc."rebuild/test/file" = {
      text = ''
        worked
      '';
      mode = "0755";
    };
}
