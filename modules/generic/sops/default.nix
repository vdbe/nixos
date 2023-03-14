{ sops-nix, lib, config, ... }:
with lib;
let
  cfg = config.modules.sops;
in
{
  imports = [ sops-nix.nixosModules.sops ];

  options.modules.sops = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };

    defaultSopsFile = mkOption {
      default = ../../../secrets/default.yaml;
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    sops.defaultSopsFile = cfg.defaultSopsFile;
  };
}

