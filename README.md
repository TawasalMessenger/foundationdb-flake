# Install

## Global installation for NixOS

/etc/nixos/configuration.nix:

```nix
{
# ...
  imports = [
    (import (fetchTarball {
      url = "https://github.com/TawasalMessenger/foundationdb-flake/archive/5a42b9153260ab38860eba58811c7230ef2e7728.tar.gz";
      sha256 = "0hhp2n9q6j041038mshf766vimbkibwwh4pb7hygychf1w5wlddf";
    })).nixosModule
  ];
  services.foundationdb.enable = true;
# ...
}
```
