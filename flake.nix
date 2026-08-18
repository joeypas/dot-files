{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      environment.extraOutputsToInstall = [
        "doc"
        "dev"
      ];
      environment.pathsToLink = [
        "/bin"
        "/share/info"
        "/share/doc"
        "/share/man"
      ];

      users.users.josephliotta = {
          name = "josephliotta";
          home = "/Users/josephliotta";
      };

      system.primaryUser = "josephliotta";

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      # User-facing packages and dotfiles are managed in home.nix.
      homebrew = {
          enable = true;
          taps = [];
          brews = [ "rkhunter" ];
          casks = [
            "orbstack"
            "codex"
          ];
      };


      programs.zsh.enable = true;
      programs.zsh.enableGlobalCompInit = false;
      programs.zsh.promptInit = "";
      programs.bash.enable = false;
      environment.variables = {
        SHELL = "zsh";
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      nix.settings.trusted-users =
        [
          "root"
          "josephliotta"
        ];

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      security.pam.services.sudo_local.touchIdAuth = true;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      nix.enable = false;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#j0wn3d
    darwinConfigurations."j0wn3d" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.users.josephliotta = import ./home.nix;
        }
      ];
    };
  };
}
