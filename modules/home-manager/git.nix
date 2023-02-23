{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.git;
in
{
  options.modules.git = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "vdbewout";
      userEmail = "vdbewout@gmail.com";

      signing = {
        key = "482AEE74BFCFD294EBBB4A247019E6C8EFE72BF0";
        signByDefault = true;
      };

      extraConfig = {
        init = { defaultBranch = "main"; };
      };
    };
  };
}
