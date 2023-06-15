#!/bin/sh

# Get variables from config_wiz.sh

if ! mount | grep "/boot" then
    mount /dev/mmcblk0p1 /boot
fi

. /boot/config_wiz.sh

## Check first if boot is mounted

# Hostname

if [ $HOSTNAME != '' ] && [ $HOSTNAME != 'piscsi' ] then
    echo $HOSTNAME > /etc/hostname
    hostname -F /etc/hostname
fi

# IP

if [ $IP_METHOD != '' ] && [ $IP_METHOD != 'dhcp' ]
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

    cat > /etc/resolv.conf <<EOF
    nameserver $IP_DNS
EOF

fi

# Wifi

cat > /etc/wpa_supplicant.conf <<EOF
ctrl_interface=/var/run/wpa_supplicant
country=$WIFI_COUNTRY
ap_scan=1

network={
    ssid=$WIFI_SSID
	psk=$WIFI_PASS
}
EOF

# TZ

ln -sf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime

#==============================================================================#
# Clean config_wiz.sh

cat > /boot/config_wiz.sh <<EOF
#!/bin/sh

#==============================================================================#
#
# PiSCSI_OS Configuration Wizard
#
#==============================================================================#

# Welcome to PiSCSI
# This file serves to configure your small OS
# It is read at every startup
# Sensitive information is removed after reading (WIFI_*, ACCOUNT_*, SSH_*)
# The other fields, if changed, will update the configuration at boot

# Hostname of the machine
# Default: piscsi

HOSTNAME="piscsi"

# IP address of the machine
# Default:
#     - IP_METHOD="dhcp"
# Please change IP_METHOD to "static" to use the other fields, if IP_METHOD is
# set to "dhcp" or empty, IP_* are ignored.

IP_METHOD="dhcp"
IP_ADDRESS=""
IP_NETMASK=""
IP_GATEWAY=""
IP_DNS=""

# Wifi settings of the machine
# Wifi channels differ between countries, please set WIFI_COUNTRY with the
# corresponding ISO alpha-2. e.g. UK, US, FR, DE, JP, etc.
#
# List: https://github.com/raspberrypi/rpi-imager/blob/qml/src/countries.txt
# Wiki: https://en.wikipedia.org/wiki/List_of_WLAN_channels

WIFI_COUNTRY=""
WIFI_SSID=""
WIFI_PASS=""

# Time Zone of the machine
# e.g. "Europe/Zurich", "America/Phoenix", "Australia/Darwin"
# Valid entries: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

TIME_ZONE=""

# Account
# If wanted, you can create an account

ACCOUNT_NAME=""
ACCOUNT_PASS=""

# SSH public key
# The script can copy for you your public key to the machine
# Caution: If set, root password will be disabled
# e.g. "ssh-rsa AAAAB3N...KB7g8lg user@machine"

SSH_PUBLIC_KEY=""
EOF
