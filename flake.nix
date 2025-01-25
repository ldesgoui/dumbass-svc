{
  inputs = {
    devenv-root.url = "file+file:///dev/null";
    devenv-root.flake = false;

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: I don't use this, look into disabling the module that needs it
    nix2container.url = "github:nlewo/nix2container";
    nix2container.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [ inputs.devenv.flakeModule ];

      perSystem = { lib, pkgs, ... }: {
        devenv.shells.default = {
          devenv.root = let x = builtins.readFile inputs.devenv-root.outPath; in lib.mkIf (x != "") x;

          packages = [
            pkgs.sqitchPg
          ];
        };
      };
    };
}
