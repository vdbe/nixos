{ config, sops-nix, ... }:

{
  imports = [
    ../../nix
  ];

  modules = {
    nix.enable = true;
  };

  boot = {
    tmpOnTmpfs = true;
  };

  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    firewall.enable = true;
    useDHCP = false;
    dhcpcd.wait = "background";
  };

  users = {
    mutableUsers = false; # TODO: change this
    users = {
      root = {
        hashedPassword = "*";
      };
    };
  };

  system.stateVersion = "23.05";
}
