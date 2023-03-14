{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.starship;
in
{
  options.modules.starship = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
    };
  };
}
