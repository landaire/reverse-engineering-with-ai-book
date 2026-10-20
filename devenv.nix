{ pkgs, ... }:

{
  packages = with pkgs; [
    actionlint
    mdbook
    nixfmt
  ];

  scripts = {
    book-build.exec = "mdbook build";
    book-serve.exec = ''mdbook serve "$@"'';
  };

  tasks."ci:lint" = {
    exec = ''
      actionlint
      nixfmt --check devenv.nix
    '';
    before = [ "devenv:enterTest" ];
  };

  tasks."book:build" = {
    exec = "mdbook build";
    before = [ "devenv:enterTest" ];
  };
}
