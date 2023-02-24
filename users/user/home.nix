{ inputs, outputs, lib, config, pkgs, vars, ... }:
let
  hm = inputs.home-manager.lib.hm;
  user = config.home.username;
in
{

  imports = [
    ../home.nix
  ];

  modules = {
    bash.enable = true;
    htop.enable = true;
    gpg.enable = true;
    git.enable = true;
    starship.enable = true;
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
    fd
    gcc
    git-crypt
    neovim
    neovim
    nload
    nodejs
    ripgrep
    tmux
    cargo
    rustc
  ];
}
