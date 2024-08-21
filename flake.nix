{
  description = "Flash Manager API Server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devenv.flakeModule ];
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = { config, pkgs, ... }: {
        devenv.shells.default = {
          dotenv.disableHint = true;

          languages.rust.enable = true;
          languages.rust.channel = "nightly";
          languages.rust.rustflags = "-Z threads=8 -Z macro-backtrace";

          pre-commit.hooks.clippy.enable = true;
          pre-commit.hooks.rustfmt.enable = true;

          services.minio.enable = true;
          services.redis.enable = true;
          services.postgres = {
            enable = true;
            initialDatabases = [{ name = "dev"; }];
            listen_addresses = "localhost";
          };

          packages = with pkgs; [
            sqlx-cli
            cargo-expand
            cargo-features-manager
            cargo-machete
            cargo-nextest
          ];
        };
      };
    };
}
