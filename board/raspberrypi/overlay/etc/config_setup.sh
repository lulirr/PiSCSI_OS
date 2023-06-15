#!/bin/sh

# Exits if any of the commands had an error
set -e

# Create function for pretty print

prettyp () {
    echo $@
}

# Get variables from config_wiz.sh

if [ ! -d /boot ]
then
    mkdir /boot
fi

if ! mount | grep "/boot"
then
    mount /dev/mmcblk0p1 /boot
fi

. /boot/config_wiz.sh

# Hostname

if [ $HOSTNAME != '' ] && [ $HOSTNAME != 'piscsi' ]
then
    echo $HOSTNAME > /etc/hostname
    hostname -F /etc/hostname
    prettyp "Configure hostname as: $HOSTNAME"
fi

# IP

if [ $IP_METHOD != '' ] && [ $IP_METHOD != 'dhcp' ]
then
    cat > /etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto wlan0
iface wlan0 inet static
    address $IP_ADDRESS
    netmask $IP_NETMASK
    gateway $IP_GATEWAY
	pre-up wpa_supplicant -D nl80211 -i wlan0 -c /etc/wpa_supplicant.conf -B
	post-down killall -q wpa_supplicant
EOF
    prettyp "Configure IP as a static address ($IP_ADDRESS)"
fi

if [ $IP_DNS != '' ]
then
    cat > /etc/resolv.conf <<EOF
nameserver $IP_DNS
EOF
    prettyp "Configure DNS as $IP_DNS"
fi

# Wifi

if [ $WIFI_SSID != '' ]
then
    cat > /etc/wpa_supplicant.conf <<EOF
ctrl_interface=/var/run/wpa_supplicant
country=$WIFI_COUNTRY
ap_scan=1

network={
    ssid="$WIFI_SSID"
    psk="$WIFI_PASS"
}
EOF
    prettyp "Stored Wi-Fi credentials for $WIFI_SSID"
fi

# TZ

if [ $TIME_ZONE != '' ]
then
    ln -sf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime
    prettyp "Defined time zone as $TIME_ZONE"
fi

# SSH

if [ $SSH_PUBLIC_KEY != '' ]
then
    if [ ! -d /root/.ssh ]
    then
        mkdir /root/.ssh
    fi
    echo $SSH_PUBLIC_KEY >> /root/.ssh/authorized_keys
    prettyp "Stored SSH public key"
fi


#==============================================================================#
# Clean config_wiz.sh

cat config_wiz.sh > /boot/config_wiz.sh
