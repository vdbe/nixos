# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, home-manger, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../modules/nixos/profiles/base

    ../../modules/generic/sops

    ../../modules/nixos/sshd
    ../../modules/nixos/vim
  ];

  modules = {
    sshd.enable = true;
    sops.enable = true;
    vim = {
      enable = true;
      customConfig = true;
    };
  };
  sops.secrets.hashed_password.neededForUsers = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #networking.hostName = "nixos01"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    passwordFile = config.sops.secrets.hashed_password.path;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBB774/7KJ/Y5k9jVF8YACJiyPKzU4PZs3brXbnMHtmq user@buckbeak"
    ];

    packages = with pkgs; [
      # firefox
      # thunderbird
    ];
  };

  security.sudo.extraRules = [
    {
      users = [ "user" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
        }
      ];
    }
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nload
    htop
    #neovim
    ripgrep
    fd
    #exa
    # wget
  ];

  services.xe-guest-utilities.enable = true;
  #home-manager.users.user = ../../users/user01/home.nix;
}

