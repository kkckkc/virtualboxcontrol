virtualBoxStart() {
	STATE="unknown"
	while [ $STATE != "running" ]; do
	    STATE=`VBoxManage showvminfo "$VIRTUALBOX_VM_NAME" \
			| grep State \
			| awk '{print $2}'`

		echo "State is $STATE"

		if [ $STATE == "restoring" ]; then
			sleep 2
		fi

		if [ $STATE == "saved" ]; then
			VBoxManage startvm "$VIRTUALBOX_VM_NAME" > /dev/null
			sleep 2
		fi

		if [ $STATE == "powered" ]; then
			VBoxManage startvm "$VIRTUALBOX_VM_NAME" > /dev/null
			zenity --info --title "VirtualBox" --text "Starting virtual machine... wait, log on and try again"
			exit
		fi
	done

	winid=`wmctrl -l -x -i \
		| grep "$VIRTUALBOX_VM_NAME" \
		| grep "[Running"] \
		| awk '{print $1}'`
	wmctrl -i -a "$winid"
	
	tail=$1
	idx=$(( ${#1} / 80 ))
	while [ "${#tail}" -gt "0" ]; do
		st=$(( ${#tail} - 80 ))

		if [ "$st" -lt "0" ]; then
			st=0
		fi

		if [ "$idx" -eq "0" ]; then
			VBoxManage guestproperty set "$VIRTUALBOX_VM_NAME" open "${tail:$st}" > /dev/null
		else
			VBoxManage guestproperty set "$VIRTUALBOX_VM_NAME" open$idx "${tail:$st}" > /dev/null
		fi
		tail=${tail:0:$st}
		idx=$(( idx - 1 ))
	done

}
