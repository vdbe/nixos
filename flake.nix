{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    flake-utils.url = "github:numtide/flake-utils";
    deploy-rs.url = "github:serokell/deploy-rs";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    { self
    , nixpkgs
    , deploy-rs
    , flake-utils
    , nixos-generators
    , home-manager
    , devenv
    , ...
    }@inputs:
    let

      overlays = [
        (self: _super: {
          #inherit (devenv.packages.${self.system}) devenv;
        })
      ];

      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        #overlays = import ./overlays { inherit inputs; };
        overlays = overlays;
      };

      mkSystem = hostName: system: modules: users:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            {
              networking.hostName = hostName;
              nixpkgs.pkgs = mkPkgs system;
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users = users;
            }
          ] ++ modules;
          specialArgs = inputs;
        };
    in
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = nixpkgs.legacyPackages.${ system};
      in
      {

        packages = {
          #digitalocean = nixos-generators.nixosGenerate {
          #  system = "x86_64-linux";
          #  format = "do";
          #  modules = [
          #    ./modules/nixos/profiles/base
          #    ./users
          #  ];
          #};
        };

        devShells. default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [
            {
              packages = with pkgs; [
                deploy-rs.packages.${system}.deploy-rs
                nodePackages.typescript-language-server
                sops
              ];


              languages.nix.enable = true;

              pre-commit.hooks = {
                deadnix.enable = true;
                nixpkgs-fmt.enable = true;
                statix.enable = true;
              };
            }
          ];
        };

        formatter = pkgs.nixpkgs-fmt;
      }) // {
      nixosConfigurations = {
        nixos01 = mkSystem "nixos01" "x86_64-linux" [ ./hosts/nixos01/configuration.nix ] {
          "user" = ./users/user01/home.nix;
        };
        nixos02 = mkSystem "nixos02" "x86_64-linux" [ ./hosts/nixos01/configuration.nix ] { };
      };
      homeConfigurations = { };

      deploy.nodes = {
        nixos01 = {
          hostname = "nixos01.lab.home.arpa";
          sshUser = "user";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.nixos01;
          };
          #magicRollback = false;
          #autoRollback = false;
        };
        nixos02 = {
          hostname = "nixos02.lab.home.arpa";
          sshUser = "user";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.nixos02;
          };
          #magicRollback = false;
          #autoRollback = false;
        };

      };
    };
}

