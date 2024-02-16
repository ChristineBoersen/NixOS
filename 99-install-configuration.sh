#!/usr/bin/env bash


shopt -s nocasematch
while true; do
  read  -n 1 -p $'\nInstall Configuration  (Y/N/L)'  installconfig

  if [ "$installconfig" == "y" ]
  then
    cd /mnt
    sudo nixos-install --no-root-passwd
  elif [ "$installconfig" == "l" ]
  then
    less configuration.nix *.nix
  elif [ "$installconfig" == "n" ]
  then
    exit
  fi
  printf '\a'

done
