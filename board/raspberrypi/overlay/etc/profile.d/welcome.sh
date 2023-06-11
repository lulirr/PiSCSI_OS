#/bin/sh

#############################
# PiSCSI_OS welcome message
#############################

VAR1="No devices currently attached."
VAR2=$(scsictl -l)

echo "+----+-----+------+-------------------------------------"
echo "|"
echo "| Welcome to PiSCSI_OS"
echo "|"

if [ "$VAR1" = "$VAR2" ]; then
    echo "+----+-----+------+-------------------------------------"
    echo "| "$VAR1
    echo "+----+-----+------+-------------------------------------"
else
    scsictl -l
fi
