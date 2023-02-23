{ config, lib, pkgs, inputs, modulesPath, vars, secrets, systemName, ... }:

{
  imports = [
    ../../modules/nixos/profiles/vm.nix

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
      user = secrets.users."user@${systemName}" // {
        #user = secrets.users // {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  #environment.systemPackages = with pkgs; [
  #];

  home-manager.users.user = ../../users/user/home.nix;
}

