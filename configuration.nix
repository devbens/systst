{ config, pkgs, ... }:

{

  imports = [
    ./services/nixos-auto-update.nix
  ];

  fileSystems."/" = { options = [ "noatime" "nodiratime" ]; };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        version = 2;
        efiSupport = true;
        enableCryptodisk = true;
        device = "nodev";
      };
    };
    initrd.luks.devices = {
      crypt = {
        device = "/dev/vda2";
        preLVM = true;
      };
    };
  };

  networking = {
    useDHCP = false;
    interfaces.enp1s0.useDHCP = true;
    hostName = "fedora"; # Define your hostname.
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 2022 ];
      allowedUDPPorts = [ 53 ];
      allowPing = true;
    };
  };

  time.timeZone = "Europe/Sarajevo";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  services = {
    nixos-auto-update.enable = true;
    logrotate = {
      enable = true;
      extraConfig = ''
        compress
        create
        daily
        dateext
        delaycompress
        missingok
        notifempty
        rotate 31
      '';
    };
    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
      forwardX11 = true;
      ports = [ 2022 ];
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
      enableOnBoot = true;
    };
  };

  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  users = {
    mutableUsers = false;
    users.dev = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      shell = pkgs.fish;
      # mkpasswd -m sha-512 password
      hashedPassword = "$6$C3jIZR0OEp32VPVq$hJrKEJgEE3J8TWhaJLMqyBmDmBCblBN3wfv/D8xrxL9823j/NSYewTNmEORcJpyYcsSO/OP0bZKrOKikAGX4p/";
      openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDnXnk1ab2rY/D+KMFfLP0gzEyrk5RWB89JyYLz6uzuhXXZVe9VAE5JNexy1s0WCzdcNKYHYlRXcvCHP+nbU1+Y7IlRf4pabyCu4B3lfcSxg4vKx+CC4At32+SpGgpVNKPuGpqZ70UEzuh+4JxageNb3QtxH7b9FuNd9Lk5QdmnOtvsM1+XqFW7/zAwLq9+RTyADEZ9zWYwRagAmmE9wTQQ8zMN/ZShd901NRL5U5XHBsO+ouPOmpav6onW9S13PE731BpjTLiTjto1A+OZUbHTf/cEFPcO70Zo9xlY+G0BmpVtbGy4xKjLC2a5/31J5fTo/YQOxju+TDMIEdzueXp+SUBl2bVmIi1SGZOyqA+T27fmJx3ae9GWGKv1Nd6fF9ghw+BthNQa+KFOwjlzQ9i+hbxzYipcXFui98DRZf2rv9954Dxy/6HjqjtwrYMWQt1iE6K8kpit/o3q2p/swzKPBRxReh+mHnVRT1dmbWLBSYTcDtpeO0F8I6BauD4bLK8= dev@fedora" ];
      packages = with pkgs; [
        python39Full
      ];
    };
  };

  programs = {
    ssh.startAgent = false;
    vim.defaultEditor = true;
    fish.enable = true;
    nano.nanorc = ''
      unset backup
      set nonewlines
      set nowrap
      set tabstospaces
      set tabsize 4
      set constantshow
    '';
  };

  environment = {
    systemPackages = with pkgs; [
      google-cloud-sdk-gce
      git
      gh
      pulumi-bin
      #unstable.pulumi-bin
      inotify-tools
      nodejs
      kubernetes
      kubernetes-helm
      kubeseal
      helmfile
      helmsman
      unstable.kind
      unstable.kube3d
      argo
      argocd
      kustomize
      k9s
      kubectx
      binutils
      gnutls
      wget
      curl
      bind
      mkpasswd
      cachix
    ];

    shellAliases = {
      cp = "cp -i";
      diff = "diff --color=auto";
      dmesg = "dmesg --color=always | lless";
      egrep = "egrep --color=auto";
      fgrep = "fgrep --color=auto";
      grep = "grep --color=auto";
      mv = "mv -i";
      ping = "ping -c3";
      ps = "ps -ef";
      sudo = "sudo -i";
      vdir = "vdir --color=auto";
    };
  };

  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnfree = true;
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    useSandbox = true;
    autoOptimiseStore = true;
    readOnlyStore = false;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "@wheel" ];
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d --max-freed $((64 * 1024**3))";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };
  system = {
    stateVersion = "21.11"; # Did you read the comment?
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      flake = "github:devbaze/systst";
      flags = [
        "--recreate-lock-file"
        "--no-write-lock-file"
        "-L" # print build logs
      ];
      dates = "daily";
    };
  };
}
