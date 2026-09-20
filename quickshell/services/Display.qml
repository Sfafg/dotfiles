import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Singleton {
    property real brightness: 0
    property real maxBrigtness: 0
    property var monitors: []
    property var prefferedMonitors: []
    property string pendingCommand: ""

    onPrefferedMonitorsChanged: {
        while (setMonitorInfo.running);
        let scriptPath = Qt.resolvedUrl("../scripts/monitorLayout.lua").toString().replace("file://", "");
        let command = "";
        for (const monitor of prefferedMonitors) {
            command += `lua "${scriptPath}" "${monitor.output}" ` + `transform=${monitor.transform} ` + `disabled=${monitor.disabled} ` + `scale=${monitor.scale} ` + `position=${Math.trunc(monitor.x)}x${Math.trunc(monitor.y)} ` + `mode=${monitor.mode} && `;
        }
        command += "hyprctl reload";
        if (!setMonitorInfo.running) {
            console.log(command);
            setMonitorInfo.exec(["sh", "-c", command]);
        } else {
            pendingCommand = command;
        }
    }
    onBrightnessChanged: {
        if (maxBrigtness != 0)
            setBrightness.exec(["ddcutil", "--sleep-multiplier", "0.001", "setvcp", "10", Math.floor(brightness * maxBrigtness).toString()]);

    }

    Connections {
        function onRunningChanged() {
            if (!setMonitorInfo.running && pendingCommand !== "") {
                let command = pendingCommand;
                pendingCommand = "";
                setMonitorInfo.exec(["sh", "-c", command]);
            }
        }

        target: setMonitorInfo
    }

    Process {
        id: getMonitorInfo

        function parseMonitors(text) {
            let monitors = [];
            for (let block of text.split(/\r?\n/)) {
                block = block.trim();
                if (!block)
                    continue;

                let monitor = {
                };
                for (let field of block.split(",")) {
                    field = field.trim();
                    let match = field.match(/^(\w+)\s+(.+)$/);
                    if (!match)
                        continue;

                    let key = match[1];
                    let value = match[2];
                    if (value === "true")
                        value = true;
                    else if (value === "false")
                        value = false;
                    else if (/^-?\d+(?:\.\d+)?$/.test(value))
                        value = Number(value);
                    monitor[key] = value;
                }
                monitors.push(monitor);
            }
            return monitors;
        }

        command: ["lua", Qt.resolvedUrl("../scripts/monitorLayout.lua").toString().replace("file://", "")]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                var mon = getMonitorInfo.parseMonitors(text);
                for (let m of mon) {
                    let position = m.position.match(/^(-?\d+)x(-?\d+)$/);
                    m.x = Number(position[1]);
                    m.y = Number(position[2]);
                    let mode = m.mode.match(/^(\d+)x(\d+)@([\d.]+)$/);
                    m.width = Number(mode[1]);
                    m.height = Number(mode[2]);
                    m.refreshRate = Number(mode[3]);
                    if ([1, 3, 5, 7].includes(m.transform)) {
                        m.displayWidth = m.height;
                        m.displayHeight = m.width;
                    } else {
                        m.displayWidth = m.width;
                        m.displayHeight = m.height;
                    }
                }
                monitors = mon;
            }
        }

    }

    Timer {
        interval: 3000
        running: false
        repeat: true
        onTriggered: getMonitorInfo.running = true
    }

    Process {
        id: setMonitorInfo
    }

    Process {
        id: setBrightness
    }

    Process {
        id: getBrightness

        command: ["ddcutil", "--sleep-multiplier", "0.001", "getvcp", "10"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                console.log("Get");
                console.log(text);
                const match = text.match(/current value =\s*(\d+), max value =\s* (\d+)/);
                if (match) {
                    const current = parseInt(match[1]);
                    const max = parseInt(match[2]);
                    brightness = current / max;
                    maxBrigtness = max;
                }
            }
        }

    }

}
