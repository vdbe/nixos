{ inputs, outputs, lib, config, pkgs, vars, ... }:
let
  hm = inputs.home-manager.lib.hm;
  user = config.home.username;
in
{
  imports = [
    ../modules/home-manager
  ];

  home.stateVersion = vars.stateVersion;
}
