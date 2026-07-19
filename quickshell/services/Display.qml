pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property real brightness: 0
    property real maxBrigtness: 0
    property var monitors: []
    property var prefferedMonitors: []

    Process{
        id: getMonitorInfo
        command: ["hyprctl", "monitors", "-j"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var mon = JSON.parse(text)
                for(let m of mon){
                    if([1,3,5,7].includes(m.transform))
                    {
                        const t = m.height
                        m.height = m.width
                        m.width = t
                    }
                }
                monitors = mon
            }
        }
    }
    
    Process{
        id: setPositions
    }
    onPrefferedMonitorsChanged: {
        let command = ""
        let scriptPath = Qt.resolvedUrl("../scripts/monitorLayout.lua").toString().replace("file://", "")
        for(const monitor of prefferedMonitors)
            command += `lua ${scriptPath} ${monitor.name} -p ${monitor.x}x${monitor.y} &&`
        command = command.slice(0, -2)
        setPositions.exec([
            "sh",
            "-c",
            command
        ])
    }

    Timer{
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            getMonitorInfo.running = true
        }
    }

    Process {
        id: setBrightness
    }

    onBrightnessChanged: {
        if(maxBrigtness != 0)
            setBrightness.exec([
                "ddcutil", "--sleep-multiplier", "0.001","setvcp", "10", Math.floor(brightness*maxBrigtness).toString()
            ])
    }

    Process{
        id: getBrightness
        command: ["ddcutil","--sleep-multiplier", "0.001","getvcp", "10"]
        running: true
        stdout: StdioCollector{
            onStreamFinished: {
                const match = text.match(/current value =\s*(\d+), max value =\s* (\d+)/);

                if (match) {
                    const current = parseInt(match[1]);
                    const max = parseInt(match[2]);
                    brightness = current / max;
                    maxBrigtness = max
                }
            }
        }
    }
}
