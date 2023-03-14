{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.tmux;
in
{
  options.modules.tmux = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;


    };
    xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;
    xdg.configFile."tmux/theme.conf".source = ./theme.conf;
  };
}
