# Install

## Global installation for NixOS

/etc/nixos/configuration.nix:

```nix
{
# ...
  imports = [
    (import (fetchTarball {
      url = "https://github.com/TawasalMessenger/foundationdb-flake/archive/6.3.10.tar.gz";
      sha256 = "1aql0jdbk1ixcp32jgwyxyv61n5k24y4nj0kgra12kgfi110gg2r";
    })).nixosModule
  ];
  services.foundationdb.enable = true;
# ...
}
```
