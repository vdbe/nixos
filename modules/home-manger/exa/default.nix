{ config, lib, ... }:

with lib;
let
  cfg = config.modules.exa;
in
{
  options.modules.exa = {
    enable =
      mkEnableOption "exa, a modern replacement for <command>ls</command>";

    enableAliases = mkOption {
      default = true;
      description = "recommended exa aliases (ls, ll…)";
      type = types.bool;
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ "--group-directories-first" ];
      example = [ "--group-directories-first" "--header" ];
      description = ''
        Extra command line options passed to exa.
      '';
    };

    icons = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Display icons next to file names (<option>--icons</option> argument).
      '';
    };

    git = mkOption {
      type = types.bool;
      default = config.modules.git.enable;
      description = ''
        List each file's Git status if tracked or ignored (<option>--git</option> argument).
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.exa = {
      inherit (cfg) enable enableAliases extraOptions icons git;
    };
  };

}
