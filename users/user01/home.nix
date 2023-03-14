{ lib, home-manager, pkgs, ... }:
let
  hm = home-manager.lib.hm;
in
{
  imports = [
    ../../modules/home-manger/profiles/base

    ../../modules/home-manger/gpg
    ../../modules/home-manger/starship
    ../../modules/home-manger/git
    ../../modules/home-manger/bash
    ../../modules/home-manger/exa
  ];

  modules = {
    gpg.enable = false;
    git.enable = true;
    starship.enable = true;
    bash.enable = true;
    exa.enable = true;
  };


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.

  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;

  home.packages = with pkgs; [
  ];
}
