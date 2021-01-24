{ config, lib, pkgs, ... }:
let
  cfg = config.services.foundationdb;
in
with lib; mkIf cfg.enable {
  services.foundationdb.package = pkgs.foundationdb;
  systemd.services.foundationdb = {
    serviceConfig = {
      Restart = "always";
      RestartSec = lib.mkOverride 0 1;
      LimitNOFILE = 1048576;
    };
    unitConfig = {
      StartLimitIntervalSec = 3;
      StartLimitBurst = 0;
    };
  };
}
