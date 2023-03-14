{ config, lib, ... }:

with lib;
let
  cfg = config.modules.nix;
in
{

  options.modules.nix = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {

    nix = {
      extraOptions = ''
        experimental-features = nix-command flakes
        min-free = ${toString (100 * 1024 * 1024)}
        max-free = ${toString (1024 * 1024 * 1024)}
      '';

      gc = {
        automatic = true;
        persistent = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      settings = {
        trusted-users = [ "root" "@wheel" ];
      };
    };

    system.stateVersion = "23.05";
    #system.stateVersion = vars.stateVersion;
  };
}
