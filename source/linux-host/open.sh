#!/bin/bash

source $( dirname $(readlink -f $0) )/../../etc/settings.conf
source $( dirname $(readlink -f $0) )/common.sh

fullpath="$( dirname "$1" )/$( basename $1 )"

VBoxManage showvminfo "$VIRTUALBOX_VM_NAME" > /tmp/vminfo.txt

prefix=$fullpath

while [ "$prefix" != "/" ]
do
	mapped_to=$( 
		cat /tmp/vminfo.txt | \
		grep "Host path: '$prefix'" | \
		sed "s/Name: '\([a-z]*\)',.*/\1/" )
	if [ -n "$mapped_to" ]; then
		mapped_prefix=$prefix
		break
	fi
	prefix=`dirname "$prefix"`
done

if [ -n "$mapped_to" ]; then
	f=$(echo "\\\\VBOXSVR\\${fullpath/$prefix/$mapped_to}" | 
	    sed "s/\//\\\\/g" )
	echo $f
	virtualBoxStart "$f"
else
	zenity --info --title "VirtualBox" --text "Could not find mapped folder"
fi

rm /tmp/vminfo.txt
