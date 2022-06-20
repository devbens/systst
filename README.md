# devbaze/systst

[Download NixOS installation ISO](https://nixos.org/nixos/download.html)

Notes:
1. I assume that latest **stable** (e.g. 19.03) ISO will be used for installation.
2. You need to change hostname in `configuration.nix:9`.

## Installation

    parted /dev/vda mklabel msdos
    parted /dev/vda mkpart primary ext4 0% 100%
    mkfs.ext4 -L system /dev/vda1
    mount /dev/vda1 /mnt/

    nix-env -iA nixos.gitMinimal
    git clone https://github.com/devbaze/systst.git /mnt/etc/nixos/

    nix-channel --add https://nixos.org/channels/nixos-unstable nixos
    nix-channel --update

    nixos-generate-config --root /mnt

    nixos-install
    reboot

## After install

    nix-channel --add https://nixos.org/channels/nixos-unstable nixos
    nix-channel --update
