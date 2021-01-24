{ mkShell, foundationdb }:

mkShell {
  name = "foundationdb-env";

  buildInputs = [ foundationdb ];
}
