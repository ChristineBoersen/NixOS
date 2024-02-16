#!/usr/bin/env bash

shopt -s nocasematch
while true; do
  read  -n 1 -p $'\nCreate Partitions?  (Y/N/L)'  createpartinfo

  if [ "$createpartinfo" == "y" ]
  then
	export drv=(/dev/disk/by-path/acpi-VMBUS\:00-vmbus-*-lun-0)
	export drvp1=("$drv-part1")
	export drvp2=("$drv-part2")
	sudo sfdisk -X gpt -w always --delete $drv
	sudo sfdisk --disk-id  $drv $(uuidgen)
	echo -e 'size=500M, type=U, name=NIXBOOT\nsize=+, type=L, name=NIXROOT\n' | sudo sfdisk $drv
	sudo sfdisk -l
	sudo mkfs.fat -F 32 $drvp1
	sudo fatlabel $drvp1 NIXBOOT
	sudo mkfs.ext4 $drvp2 -L NIXROOT
	break
  elif [ "$createpartinfo" == "l" ]
  then
    sudo sfdisk -l
  elif [ "$createpartinfo" == "n" ]
  then
    exit
  fi
  printf '\a'
done

