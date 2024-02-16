# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./gnome-configuration.nix
      #./netbox-configureation.nix
      #./simple-nixos-mailserver-configuration.nix
      #./zabbix-configuration.nix
    ];

  # Allows flakes (think currated package of packages + version lock , similar to node.js packages.json.lock
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set networking
  networking.networkmanager.enable = true;
  networking.useDHCP = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

   # Let's make hyperV happy and give a realistic screen size
  boot.kernelParams = ["video=hyperv_fb:1920x1080"];  # https://askubuntu.com/a/399960
  virtualisation.hypervGuest.enable = true;
  virtualisation.hypervGuest.videoMode = "1920x1080";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl."vm.overcommit_memory" = "1"; # https://github.com/NixOS/nix/issues/421;


  # Enable networking
  networking.hostName = "nixgold1"; # Define your hostname.
  networking.domain = "mclsystems.com";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services.xserver.desktopManager.gnome.enable = true;

  # Enable sound with pipewire.
  sound.enable = false;


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    mtr.enable = true;
    nano = {
      enable = true;
      nanorc = ''
        set tabstospaces
        set tabsize 2
        set linenumbers
        set trimblanks
        set unix
'';
    };
  };

  security = {
    sudo.extraConfig = ''
    Defaults:ALL timestamp_timeout=15
'';   # extends defalt sudo timeout


  };


  services = {
    avahi.enable = lib.mkDefault false;  # Media discovery not needed
    openssh.enable = lib.mkDefault true; # Enable the OpenSSH daemon.
    printing.enable = false;    # Change to True to Enable CUPS to print documents.
    timesyncd.servers = [ "10.2.0.164" "10.2.0.126" ];    # Override hard coded nixos NTP servers
  };

  # Set your time zone.
  time.timeZone = "America/New_York";


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    # environment.etc
    etc = {
          # use this section to insert items into the etc dir. The keyname is the filename without the /etc/ prepended to the path
    };

    # environment.systemPackages   INCLUDE INCLUDE INCLUDE  #Add your packages here
    systemPackages = (with pkgs; [
        wget
        git
        mdr # Markdown reader
        nvd
    ]);
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      mcladmin = {
        isNormalUser = true;
        description = "mcladmin";
        extraGroups = [  "networkmanager" "wheel" "video"];  # For an interactive user to logon, they need networkmanager and video.  wheel is needed for SUDO permission
        packages = with pkgs; [
            # Any user specific packages

        ];
        passwordFile = "/etc/passwordFile-mcladmin";  # Gets prompted for during install.sh
      };
      root.hashedPassword = "!";
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
