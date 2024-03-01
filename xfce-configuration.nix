{ config, lib, pkgs, options, ... }:


{

  
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      # alsa.support32Bit = true;
 #     pulse.enable = false;  # Use pipewire OR pulseaudio . They can't both control sound at once. See hardware.pulseaudio.enable
      # If you want to use JACK applications, uncomment this
      # jack.enable = true;
      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    xrdp = {
      defaultWindowManager = "/run/current-system/sw/bin/xfce4-session";
      enable = true;
      openFirewall = true;
    };

    xserver = {
      enable = true;   # Enable the X11 windowing system.
        
      ## Desktop Manager
      desktopManager = {
         xterm.enable = false;
         xfce.enable = true;         
      };

      ## Display Manager
      displayManager = {
        autoLogin.enable = false;
        defaultSession = "xfce";
        gdm = {
          autoSuspend = false;
          enable = true;
          wayland = true;
          banner = "${config.networking.fqdnOrHostName}";
        };
#        sessionCommands = ''
#test -f ~/.xinitrc && . ~/.xinitrc
#'';  # fixes bug where xinit isn't set correctly when homeManager isn't being used

      };
     
      excludePackages = [ pkgs.xterm ] ++ ( with pkgs.xorg; [
        xrandr
      ]);

      layout = "us";
      xkbVariant = "";

    };

  };

  systemd.services = {
    geoClue.enable = lib.mkForce false;  # No need
  };

  hardware.pulseaudio.enable = false;

  environment = {
    etc = {
      # Fixes issue with Gnome color manager asking for extra authentication upon xRDP login
#      "polkit-1/localauthority/50-local.d/45-allow-colord.pkla".text = ''
#[Allow Colord all Users]
#Identity=unix-user:*
#Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
#ResultAny=no
#ResultInactive=no
#ResultActive=yes
#'';
#
    };   # etc end

    # environment.systemPackages   INCLUDE INCLUDE INCLUDE
    systemPackages = (with pkgs; [
      firefox
      xrdp
      xfce.xfconf
    ]);

    # environment.gnome.exlcudePackages   EXCLUDE EXCLUDE EXCLUDE
    # Items that have no place on a dedicated server

  };

  programs.xfconf.enable = true;
  security = {
    pam.services.gdm.enableGnomeKeyring = true;
    rtkit.enable = true;
  };

  users.users.gdm = {
    extraGroups = [ "video"];  # gdm locks up with blank screen on start without this
  };
}

