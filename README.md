# PiSCSI_OS

PiSCSI_OS is a minimal linux image to run (piscsi)[https://github.com/PiSCSI/piscsi]. It comes at the great advantage to boot in only a few seconds. It is based on (buildroot)[https://github.com/buildroot/buildroot].

At the moment, the project is a "proof of concept" state as it gives a minimal working OS with pisci. So far, I only tested it on a Raspberry Pi Zero W.

I am currently writing an extensive documentation for the project, this way it will be easier for further improvements.

## State of the project

**Done:**

- Base OS
    - Fast boot
    - Init system
    - Wifi
    - Avahi
    - SSH
    - Time sync
- Minimal piscsi (without web, oled or ctrlboard)

**To Do:**

- Full piscsi
    - Python
    - Python modules
    - Web server
    - Daynaport network config
- Netatalk
    - Time sync
    - CUPS
- Macproxy
- Resize filesystem at first boot
- Easy input of wifi credentials
- Update management (hifiberry example or swupdate)
