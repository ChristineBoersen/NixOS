#!/usr/bin/env bash


shopt -s nocasematch
while true; do
  read  -n 1 -p $'\nMount lun 0 (boot and root)  (Y/N)'  mountpart

  if [ "$mountpart" == "y" ]
  then

	export drv=(/dev/disk/by-path/acpi-VMBUS\:00-vmbus-*-lun-0)
	export drvp1=("$drv-part1")
	export drvp2=("$drv-part2")
	sudo sfdisk -l

	sudo mount /dev/disk/by-label/NIXROOT /mnt
	sudo mkdir -p /mnt/boot
	sudo mount /dev/disk/by-label/NIXBOOT /mnt/boot

	sudo dd if=/dev/zero of=/mnt/.swapfile bs=1024 count=2097152
	sudo chmod 600 /mnt/.swapfile
	sudo mkswap /mnt/.swapfile
	sudo swapon /mnt/.swapfile
	break
  elif [ "$mountpart" == "n" ]
  then
    exit
  fi
  printf '\a'

done
