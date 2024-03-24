{ pkgs }:

pkgs.writeShellScriptBin "my-awesome-script" ''
  echo "Hello, nix!" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
''
