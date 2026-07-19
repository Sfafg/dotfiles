import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Singleton {
    function shutDown() {
        shutDown_.running = true;
    }

    function reboot() {
        reboot_.running = true;
    }

    function logOut() {
        logOut_.running = true;
    }

    Process {
        id: shutDown_

        command: ["systemctl", "poweroff"]
        running: false
    }

    Process {
        id: reboot_

        command: ["systemctl", "reboot"]
        running: false
    }

    Process {
        id: logOut_

        command: ["sh", "-c", "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"]
        running: false
    }

}
