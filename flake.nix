{
  nixConfig = {
    extra-substituters = "https://cache.garnix.io";
    extra-trusted-public-keys = "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=";
  };

  inputs = {
    emanote.url = "github:srid/emanote";
    emanote.inputs.emanote-template.follows = "";
    nixpkgs.follows = "emanote/nixpkgs";
    flake-parts.follows = "emanote/flake-parts";
  };

  outputs = inputs@{ self, flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ inputs.emanote.flakeModule ];
      perSystem = { config, self', pkgs, system, ... }: {
        emanote = {
          # By default, the 'emanote' flake input is used.
          # package = inputs.emanote.packages.${system}.default;
          sites."default" = {
            layers = [{ path = ./.; pathString = "."; }];
            port = 8080;
            baseUrl = "/docs/"; # Change to "/" (or remove it entirely) if using CNAME
            # prettyUrls = true;
          };
        };
        apps.preview.program = pkgs.writeShellApplication {
          name = "emanote-static-preview";
          meta.description = ''
            Run a locally running preview of the statically generated docs.
          '';
          runtimeInputs = [ pkgs.nodePackages.live-server ];
          text = ''
            set -x
            live-server ${self'.packages.default} --mount="/docs:${self'.packages.default}" "$@"
          '';
        };
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nixpkgs-fmt
            pkgs.just
          ];
        };
        formatter = pkgs.nixpkgs-fmt;
      };
    };
}
