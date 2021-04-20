{
  description = "FoundationDB flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    rocksdb-src = {
      url = "github:facebook/rocksdb/v6.10.2";
      flake = false;
    };
    src = {
      url = "github:apple/foundationdb/6.3.12";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-compat, rocksdb-src, src }:
    let
      sources = with builtins; (fromJSON (readFile ./flake.lock)).nodes;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      foundationdb = import ./build.nix {
        inherit rocksdb-src pkgs src;
        version = sources.src.original.ref;
      };
      derivation = { inherit foundationdb; };
    in
    with pkgs; rec {
      packages.${system} = derivation;
      defaultPackage.${system} = foundationdb;
      legacyPackages.${system} = extend overlay;
      devShell.${system} = pkgs.mkShell {
        name = "foundationdb-env";
        buildInputs = [ foundationdb ];
      };
      nixosModule = {
        imports = [
          ./configuration.nix
        ];
        nixpkgs.overlays = [ overlay ];
        services.foundationdb.package = lib.mkDefault foundationdb;
      };
      overlay = final: prev: derivation;
    };
}
