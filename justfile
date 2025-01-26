default:
    @just --list

# Autoformat project tree
fmt:
    nix fmt

# Lock emanote on dark-mode
lock-dark:
    nix flake lock --override-input emanote "github:tarc/emanote/dark-mode-rebased"

# Run local server
run:
    nix run --accept-flake-config

# Build static site
build:
    nix build --accept-flake-config

# Preview the static site
serve:
    nix run nixpkgs#nodePackages.live-server -- ./result --mount="/docs:./result"

# Preview the static site
preview:
    nix run .#preview --accept-flake-config
