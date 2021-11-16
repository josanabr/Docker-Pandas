#!/bin/sh
cd /workdir
if [ "${1}" == "" ]; then
	echo "No fue provisto un script"
	exit 1
fi
python3 ${1}
