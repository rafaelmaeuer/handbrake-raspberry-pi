# Monitor Handbrake process

## Start Handbrake-UI with watcher

1. Copy `fr.handbrake.ghb.desktop` to '/home/pi/Desktop'
2. Edit `scripts/watchHB.sh`

    ```sh
    # Set time to refresh watcher process
    refresh=10
    # Set CPU limit (400 = 100% with 4 Cores)
    limit=400
    ```

3. Execute Desktop shortcut and select `Run with Terminal`

## Send Push Notification when encoding finished

1. Select option in handbrake ``
2. Create Webhook Applet with IFTTT
3. Replace `{event_name}` and `{ifttt_key}` in `scripts/notify.sh`

    ```sh
    # Set timeout after which notification is sent
    timeout=10
    # Set ifttt applet event name
    event={event_name}
    # Set ifttt key
    key={ifttt_key}
    ```

## Automatic Shutdown

1. Set shutdown timeout in `scripts/shutdown.sh`

   ```sh
   # Set timeout after which system is shutdown
   timeout=120
   ```

## Sources

- [How to show and update echo on same line](https://stackoverflow.com/questions/12628327/how-to-show-and-update-echo-on-same-line/12628482#12628482)
- [Shell Script to read and warning CPU temp](https://www.raspberrypi.org/forums/viewtopic.php?t=191029#p1199727)
- [If command reach timeout execute other command](https://unix.stackexchange.com/questions/317007/if-command-reach-timeout-execute-other-command/317016#317016)