{ config, lib, pkgs, inputs, modulesPath, vars, ... }:

{
  imports =
    [
      ../_all/configuration.nix
      (modulesPath + "/profiles/base.nix")
      ./hardware-configuration.nix
    ];

  modules = {
    sshd.enable = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.interfaces.enX0.useDHCP = lib.mkDefault true;

  users = {
    groups = {
      user.gid = 1000;
    };

    users = {
      user = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        initialPassword = "toor123";
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.xe-guest-utilities.enable = true;

  home-manager.users.user = ../../users/user/home.nix;
}

