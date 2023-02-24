# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.

{
  imports = [
    ./bash.nix
    ./git.nix
    ./gpg.nix
    ./htop.nix
    ./starship.nix
  ];
}
