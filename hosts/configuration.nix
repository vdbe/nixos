{ inputs, outputs, lib, config, pkgs, vars, systemName, secrets, ... }:
#{ config, lib, pkgs, nixpkgs, self, inputs, vars, systemName, ... }:

{
  imports = [
    ../../modules/nixos/nix.nix
    ../../modules/nixos/sshd.nix
  ];

  modules = {
    nix.enable = true;
  };

  boot = {
    #cleanTmpDir = true;
    tmpOnTmpfs = true;
  };

  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.firewall.enable = true;
  networking.useDHCP = false;
  networking.dhcpcd.wait = "background";

  # Speed up boot / shut down
  systemd.services.systemd-udev-settle.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.extraConfig = "DefaultTimeoutStopSec=30s";

  # Delete old logs
  services.journald.extraConfig = "MaxRetentionSec=14day";

  documentation = {
    enable = true;
    doc.enable = false;
    info.enable = false;
    nixos.enable = true;
  };

  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPassword = "*";
      };
    };
  };

  system.name = systemName;
  system.stateVersion = vars.stateVersion;
  system.configurationRevision = self.rev or "dirty";
}
