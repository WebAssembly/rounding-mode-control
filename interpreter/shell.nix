{ sources ? import ./nix/sources.nix {}
, pkgs ? import sources.nixpkgs {}
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    dune_3
    ocaml
    ocamlPackages.arg-complete
    ocamlPackages.findlib
    ocamlPackages.mopsa
    python3
  ];

  LC_ALL = "C.UTF-8";
  LANG = "C.UTF-8";
}
