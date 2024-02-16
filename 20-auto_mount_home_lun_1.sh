#!/usr/bin/env bash


shopt -s nocasematch
while true; do
  read  -n 1 -p $'\nMount lun 1 (as /home)  (Y/N)'  mountpart

  if [ "$mountpart" == "y" ]
  then

	export drv=(/dev/disk/by-path/acpi-VMBUS\:00-vmbus-*-lun-1)
	export drvp1=("$drv-part1")

	#sudo sfdisk -X gpt -w always --delete $drv
	#sudo sfdisk --disk-id  $drv $(uuidgen)
	#echo -e 'size=500M, type=U, name=NIXBOOT\nsize=+, type=L, name=NIXROOT\n' | sudo sfdisk $drv
	sudo sfdisk -l

	sudo mkdir -p /mnt/home
	sudo mount $drvp1 /mnt/home

 elif [ "$mountpart" == "n" ]
  then
    exit
  fi
  printf '\a'

done
