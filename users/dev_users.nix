{ config, pkgs, ... }:

{

  users = {
    mutableUsers = false;
    users.dev = {
      isNormalUser = true;
      extraGroups = [ "docker" ];
      # mkpasswd -m sha-512 password
      hashedPassword = "$6$C3jIZR0OEp32VPVq$hJrKEJgEE3J8TWhaJLMqyBmDmBCblBN3wfv/D8xrxL9823j/NSYewTNmEORcJpyYcsSO/OP0bZKrOKikAGX4p/";
      openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDnXnk1ab2rY/D+KMFfLP0gzEyrk5RWB89JyYLz6uzuhXXZVe9VAE5JNexy1s0WCzdcNKYHYlRXcvCHP+nbU1+Y7IlRf4pabyCu4B3lfcSxg4vKx+CC4At32+SpGgpVNKPuGpqZ70UEzuh+4JxageNb3QtxH7b9FuNd9Lk5QdmnOtvsM1+XqFW7/zAwLq9+RTyADEZ9zWYwRagAmmE9wTQQ8zMN/ZShd901NRL5U5XHBsO+ouPOmpav6onW9S13PE731BpjTLiTjto1A+OZUbHTf/cEFPcO70Zo9xlY+G0BmpVtbGy4xKjLC2a5/31J5fTo/YQOxju+TDMIEdzueXp+SUBl2bVmIi1SGZOyqA+T27fmJx3ae9GWGKv1Nd6fF9ghw+BthNQa+KFOwjlzQ9i+hbxzYipcXFui98DRZf2rv9954Dxy/6HjqjtwrYMWQt1iE6K8kpit/o3q2p/swzKPBRxReh+mHnVRT1dmbWLBSYTcDtpeO0F8I6BauD4bLK8= dev@fedora" ];
/*
      packages = with pkgs; [
        python38Full
        (
          python3.withPackages (
            ps: with ps; [
              #poetry
              pip
              powerline
              pygments
              pygments-markdown-lexer
              xstatic-pygments
              pylint
              numpy
              pynvim
            ]
          )
        )
        ];
*/
    };
  };

}