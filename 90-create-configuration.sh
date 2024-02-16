#!/usr/bin/env bash


shopt -s nocasematch
while true; do
  read  -n 1 -p $'\nCreate Configuration  (Y/N)'  createconfig

  if [ "$createconfig" == "y" ]
  then

    sudo mkdir -p -v /mnt/etc/nixos
    sudo cp -f $(pwd)/*.nix /mnt/etc/nixos
    sudo nixos-generate-config --root /mnt

    sudo touch /mnt/etc/passwordFile-mcladmin
    mkpasswd --method=SHA-512 -s | sudo tee -a /mnt/etc/passwordFile-mcladmin
    sudo chmod 600 /mnt/etc/passwordFile-mcladmin

    sudo nano /mnt/etc/nixos/configuration.nix

    cd /mnt

    # won't work since we aren't allowing root password #sudo passwd --root /mnt
    echo -e "now run the following when ready to install:\n\n    sudo nixos-install --no-root-passwd  ";
    break
elif [ "$createconfig" == "n" ]
  then
    exit
  fi
  printf '\a'

done
