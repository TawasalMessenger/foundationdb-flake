# Install

## Global installation for NixOS

/etc/nixos/configuration.nix:

```nix
{
# ...
  imports = [
    (import (fetchTarball {
      url = "https://github.com/TawasalMessenger/foundationdb-flake/archive/6.3.10-1.tar.gz";
      sha256 = "0isw3jnrhds9nma7j1856zpxd5ah4h8sqvhd839fp2qhd553zfqj";
    })).nixosModule
  ];
  services.foundationdb.enable = true;
# ...
}
```
