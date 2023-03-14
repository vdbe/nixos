{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.sshd;
in
{
  options.modules.sshd = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
      extraConfig = ''
        StreamLocalBindUnlink yes
      '';
      #ports = [ 9999 ];
    };
  };
}
