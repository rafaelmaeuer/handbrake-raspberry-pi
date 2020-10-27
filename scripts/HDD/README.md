# HDD Spindown on Shutdown

As the mounting point of the HDD which should be spindown can change we need to store it in text file as on shutdown file system is read-only and drive already unmounted.

## Add service to store mounting point

1. Get device unit with

    ```sh
    systemctl list-units -t mount
    ```

2. Add device unit in HDD watcher service

    In `watchHDD.service` replace `{media-pi-Name\x20of\x204Drive.mount}` with device unit

3. Start HDD watcher service

    ```sh
    sudo systemctl enable watchHDD.service --now
    sudo systemctl daemon-reload
    ```

## Add service to spindown on shutdown

1. Replace HDD name in "{Name of Drive}" in

   - `scripts/HDD/ejectHDD.sh`
   - `scripts/HDD/startHDD.sh`

2. Start HDD spindown service

    ```sh
    sudo ln -s /home/pi/handbrake-pi/service/ejectHDD.service /etc/systemd/system/
    sudo systemctl daemon-reload
    ```

## Manually Eject HDD with spindown

1. Copy `ejectHDD.desktop` to `/home/pi/Desktop/`

2. Execute shortcut to unmount and spindown HDD

## Sources

[USB HDD poweroff (HDD abruptly stop spinning when running the shutdown command)](https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=247093&p=1508935#p1508935)

[External USB 3.0 HDD Spin down and power off when powering off or rebooting the Raspberry Pi 4B](https://stackoverflow.com/questions/61667357/external-usb-3-0-hdd-spin-down-and-power-off-when-powering-off-or-rebooting-the)

[How to run a script with systemd right before shutdown?](https://unix.stackexchange.com/questions/39226/how-to-run-a-script-with-systemd-right-before-shutdown/41756#41756)

[How to run a script when a specific flash-drive is mounted?](https://askubuntu.com/questions/25071/how-to-run-a-script-when-a-specific-flash-drive-is-mounted/679600#679600)

[Raspberry Pi: Festplatte automatisch in den Standby/Ruhemodus schalten mit hdparm](https://maker-tutorials.com/raspberry-pi-festplatte-automatisch-standby-hdparm/)