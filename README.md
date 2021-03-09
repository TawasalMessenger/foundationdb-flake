# Install

## Global installation for NixOS

/etc/nixos/configuration.nix:

```nix
{
# ...
  imports = [
    (import (fetchTarball {
      url = "https://github.com/TawasalMessenger/foundationdb-flake/archive/6.3.11.tar.gz";
      sha256 = "19visg8vabv3fvmw9irh8qclgsssh5nvb5dbzkvwi4dq05ma6jhs";
    })).nixosModule
  ];
  services.foundationdb.enable = true;
# ...
}
```
