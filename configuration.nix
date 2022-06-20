# nix-channel --add https://nixos.org/channels/nixos-unstable nixos
# nix-channel --update
#
{ config, pkgs, lib, ... }:
let
  secrets = import ./secrets.nix;
  hostname = "github.com";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  swapDevices = [
    { device = "/var/swapfile";
      size = 2048; # MiB
    }
  ];

  networking.hostName = builtins.replaceStrings ["."] ["-"] "${hostname}";

  networking.firewall =  {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  users.extraUsers.root = {
    openssh.authorizedKeys.keys = [ secrets.pubkey ];
  };

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    vim
  ];

  services.gitea = {
    enable = true;
    appName = "${hostname}";
    domain = "${hostname}";
    rootUrl = "https://${hostname}";
    disableRegistration = true;
    settings = {
      "ui" = {
        DEFAULT_THEME = "gitea";
      };
      "attachment" = {
        ENABLED = true;
        ALLOWED_TYPES = "*/*";
      };
      "other" = {
        SHOW_FOOTER_VERSION = false;
      };
      "repository.signing" = {
        DEFAULT_TRUST_MODEL = "committer";
      };
    };
  };

  security.acme.email = "benjophp@gmail.com";
  security.acme.acceptTerms = true;

  services.nginx = {
    enable = true;
    virtualHosts."${hostname}" = {
      enableACME = true;
      forceSSL = true;

      locations."/".proxyPass = "http://127.0.0.1:3000";
    };
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  system.stateVersion = "19.03";

  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
