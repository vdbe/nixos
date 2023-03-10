{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.gpg;
in
{
  options.modules.gpg = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      mutableKeys = true;
      mutableTrust = true;
      publicKeys = [
        {
          source = ./pub.key;
          trust = "ultimate";
        }
      ];
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };

}
