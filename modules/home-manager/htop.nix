{ config, lib, pkgs, home-manager, ... }:

with lib;

let
  cfg = config.modules.htop;
in
{
  options.modules.htop = {
    enable = lib.mkEnableOption "Enable base htop settings";
  };

  config = mkIf cfg.enable {
    programs.htop = {
      enable = true;
      settings = {
        hide_kernel_threads = 1;
        hide_userland_threads = 1;

        show_thead_names = 1;
        show_program_path = 1;

        highlight_base_name = 1;

        show_cpu_frequency = 1;
        show_cpu_temperature = 1;

        hide_function_bar = 1;
      };
    };
  };
}
