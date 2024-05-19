#!/bin/bash -x

source lib/common.sh

machine=$(determine_os)
if [ $? -eq 1 ]; then
	echo $machine
	exit 1
fi

case $machine in
	linux)
		source lib/ubuntu/setup.sh
		;;
	mac)
		source lib/mac/setup.sh
		;;
esac
