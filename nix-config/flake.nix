{
  description = "NixOS + Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, zen-browser, niri-flake, nixos-wsl, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # Fedora 用 standalone home-manager
      homeConfigurations."aw5qm" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit zen-browser; };
        modules = [
          ./home
        ];
      };

      # NixOS USB (niri) - 実機起動用 (最小構成)
      nixosConfigurations."usb-niri" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit niri-flake; };
        modules = [
          ./hosts/usb-niri/configuration.nix
          niri-flake.nixosModules.niri
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aw5qm = { imports = [ ./home/niri-minimal.nix ./home/niri.nix ]; };
          }
        ];
      };

      # NixOS WSL
      nixosConfigurations."wsl" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/wsl/configuration.nix
          nixos-wsl.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aw5qm = { imports = [ ./home/wsl.nix ]; };
          }
        ];
      };

      # NixOS VM (niri)
      nixosConfigurations."vm-niri" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit zen-browser niri-flake; };
        modules = [
          ./hosts/vm-niri/configuration.nix
          niri-flake.nixosModules.niri
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit zen-browser; };
            home-manager.users.aw5qm = { imports = [ ./home ./home/niri.nix ]; };
          }
        ];
      };
    };
}
