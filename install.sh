#!/usr/bin/env bash






echo "Preparing for installation (Ctrl-C to abort)\n\n";
cd "$(dirname $0)";

while true; do

	while true; do
		read -p $'\nHostName: ' hn;
		if [ -n "${hn}" ]; then
		  break;
		fi
	done

	while true; do
		read -p $'\nDomain (everything after the hostname, excluding leading dot): ' dom;
		if [ -n "${dom}"  ]; then
		  break;
		fi
	done

	echo -e "\n";
	read -n 1 -p "Accept ${hn}.${dom} as FQDN (HostName + Domain) (Y/N) " acc;
	if [ "$acc" == "y" ]; then
		break;
	fi

done



for filename in  ./*.sh; do
  if  [ "$filename" != "./install.sh" ]
  then
    sudo $filename;
  fi
done
