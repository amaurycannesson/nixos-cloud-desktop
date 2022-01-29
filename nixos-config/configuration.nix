{ modulesPath, pkgs, ... }: {
  imports = [ 
    "${modulesPath}/virtualisation/amazon-image.nix"
  ];

  ec2.hvm = true;

  networking = {
    hostName = "cloud-desktop";
    firewall.allowedTCPPorts = [ 22 3389 ];
  };

  users.extraUsers.amaury = {
    isNormalUser = true;
    extraGroups = [ "wheel"];
    shell = pkgs.zsh;
  };

  time.timeZone = "Europe/Paris";

  system = {
    stateVersion = "21.11";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };
}