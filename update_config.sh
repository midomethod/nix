#!/usr/bin/env bash

# Run at the root of the repo

# Move home.nix & rebuild home
sudo cp home.nix ~/.config/home-manager/home.nix
home-manager switch

# Move configuration.nix & rebuild nix
sudo cp configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch
