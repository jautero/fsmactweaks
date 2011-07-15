#!/bin/bash

gn() {
    growlnotify -n "fsmactweaks" -d "nu.dll.fsmactweaks" -a "F-Secure Mac Protection"
}

infected=""
clean=""
for f in "$@"
do
    echo "$f" | gn "Scanning file..."
    fsav --action1=rename --action2=none "$f" > /dev/null
    rc=$?
    if [ $rc -eq 3 ] ; then
	echo "WARNING: malware found in the following file(s): $f" | gn -s "Scan result"
	if [ -e $f.virus ] ; then
	    # rename successfull, don't backup malware.
	    xattr -w com.apple.metadata:com_apple_backup_excludeItem com.apple.backupd $f.virus
	fi
    elif [ $rc -eq 0 ] ; then 
	echo "Yay! No malware found in $f" | gn "Scan result"
    else
	echo "There was an error scanning $f" | gn "Scan result"
    fi
done
