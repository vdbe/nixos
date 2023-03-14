{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.vim;
in
{
  options.modules.vim = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };

    customConfig = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable
    {
      programs.vim = {
        defaultEditor = true;
      };

      # TODO: this still requires gtk for some reason
      # environment.systemPackages = with pkgs; mkIf cfg.customConfig [
      #   (vim-full.override {
      #     features = "tiny";
      #     guiSupport = "";
      #     perlSupport = false;
      #     nlsSupport = false;
      #     tclSupport = false;
      #     #multibyteSupport = false;
      #     luaSupport = false;
      #     pythonSupport = false;
      #     rubySupport = false;
      #     cscopeSupport = false;
      #     netbeansSupport = false;
      #     ximSupport = false;
      #     ftNixSupport = false;
      #   })
      #   (vim-full.customize {
      #     name = "vim";
      #     vimrcConfig.customRC = ''
      #       set cc=80
      #     '';
      #     #vimrcConfig.packages.nixbundle = with pkgs.vimPlugins; {
      #     #  start = [ ];
      #     #  opt = [ ];
      #     #};
      #   })
      # ];


    };
}

