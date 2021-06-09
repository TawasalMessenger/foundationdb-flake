{
  description = "FoundationDB flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    rocksdb-src = {
      url = "github:facebook/rocksdb/v6.10.2";
      flake = false;
    };
    src = {
      url = "github:apple/foundationdb/6.3.13";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, rocksdb-src, src }:
    let
      sources = with builtins; (fromJSON (readFile ./flake.lock)).nodes;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      fdb = import ./build.nix {
        inherit rocksdb-src pkgs src;
        version = sources.src.original.ref;
      };
      derivation = { inherit fdb; };
    in
    with pkgs; rec {
      packages.${system} = derivation;
      defaultPackage.${system} = fdb;
      legacyPackages.${system} = extend overlay;
      devShell.${system} = pkgs.mkShell {
        name = "fdb-env";
        buildInputs = [ fdb ];
      };
      nixosModule = {
        imports = [
          ./configuration.nix
        ];
        nixpkgs.overlays = [ overlay ];
        services.fdb.package = lib.mkDefault fdb;
      };
      overlay = final: prev: derivation;
    };
}
