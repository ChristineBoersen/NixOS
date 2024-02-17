{ config, lib, pkgs, options, ... }:


{
   programs = {
    dconf = {
      enable = true;
      profiles = {
        user.databases = [{
          settings = with lib.gvariant; {
            "org/gnome/desktop/interface".color-scheme = "prefer-dark";
            "org/gnome/desktop/privacy".remember-recent-files = false;
            "org/gnome/desktop/session".idle-delay = mkUint32 300;
            "org/gnome/desktop/screensaver".lock-delay = mkUint32 30;
            "org/gnome/shell/favorite-apps" = "['org.gnome.Nautilus.desktop', 'org.gnome.Console.desktop','firefox.desktop', 'gparted.desktop', 'nixos-manual.desktop']";
            "org/gnome/mutter" = {
               edge-tiling = true;
               attach-modal-dialogs = true;
               experimental-features = [ "scale-monitor-framebuffer" ];
             };

         "org/gnome/settings-daemon/plugins/media-keys" = {
                shutdown="";
                custom-keybindings=''
[  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ]
'';
             };

         "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
               name="logout";
               command="/sbin/shutdown -h now";
               binding="<Control><Alt>Delete";
             };

             "org/gnome/settings-daemon/plugins/power" = {         # Suspend only on battery power, not while charging.
               sleep-inactive-ac-timeout = "0";
               sleep-inactive-ac-type = "nothing";
               sleep-button-action = "nothing";
               power-button-action = "interactive";
             };

          };


        }];
      };
    };

  };

  services = {
    #avahi.enable = false;  # Media discovery not needed

    gnome = {
       games.enable = false;
       evolution-data-server.enable = lib.mkForce false;
    };
    # libinput.enable = true;    # Enable touchpad support (enabled default in most desktopManager).

    pipewire = {
      enable = true;
      alsa.enable = true;
    # alsa.support32Bit = true;
      pulse.enable = false;
      # If you want to use JACK applications, uncomment this
    #  jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

     xrdp = {
      defaultWindowManager = "/run/current-system/sw/bin/gnome-session";
      enable = true;
      openFirewall = true;
    };

    xserver = {
       enable = true;   # Enable the X11 windowing system.

       ## Desktop Manager
       desktopManager = {
         xterm.enable = false;
         gnome.enable = true;
       };

       ## Display Manager
       displayManager = {
         autoLogin.enable = false;
         defaultSession = "gnome";
         gdm = {
           autoSuspend = false;
           enable = true;
           wayland = false;
           banner = "${config.networking.fqdnOrHostName}";
         };
         sessionCommands = ''
  test -f ~/.xinitrc && . ~/.xinitrc
'';  # fixes bug where xinit isn't set correctly when homeManager isn't being used
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
  # environment.etc
    etc = {

     # Fixes issue with Gnome color manager asking for extra authentication upon xRDP login
      "polkit-1/localauthority/50-local.d/45-allow.colord.pkla".text = ''
[Allow Colord all Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes
'';



    };   # etc end

    # environment.systemPackages   INCLUDE INCLUDE INCLUDE
    systemPackages = (with pkgs; [
        firefox
        gnome.gnome-session
        xrdp
        gparted
    ]);

    # environment.gnome.exlcudePackages   EXCLUDE EXCLUDE EXCLUDE
    # Items that have no place on a dedicated server
    gnome.excludePackages = ( with pkgs; [
    #    gnome-photos
      geoclue2
      gnome-tour
      snapshot
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-calendar
      gnome-characters

      #gnome-color-manager

      gnome-contacts
      gnome-maps
      gnome-music
      gnome-terminal

      gnome-weather
#  gedit # text editor
      epiphany # web browser
      geary # email reader
#      evince # document viewer
      simple-scan
      totem
      yelp
     ]);

  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {

  };

  security = {

    pam.services.gdm.enableGnomeKeyring = true;
    rtkit.enable = true;
  };



  users.users.gdm = {
    extraGroups = [ "video"];  # gdm locks up with blank screen on start without this
  };

}
