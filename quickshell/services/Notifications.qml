pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property var notifications: []
    property alias clear : clear.running

    function loadHistory(json) {
        let raw = json.data[0]
        let list = []

        for (let i = 0; i < raw.length; i++) {
            let n = raw[i]

            // convert timestamp safely
            let ts = Number(n.timestamp.data)

            // dunst often uses microseconds → convert to ms if needed
            if (ts > 1e12) ts = ts / 1000

            let date = new Date(ts)

            let timeStr =
                date.getHours().toString().padStart(2, "0") + ":" +
                date.getMinutes().toString().padStart(2, "0")

            list.push({
                title: n.summary.data,
                body: n.body.data,
                app: n.appname.data,
                icon: n.icon_path.data,
                time: timeStr
            })
        }

        notifications = list
    }

    Process{
        id: clear
        command: ["dunstctl", "history-clear"]
        running: false
        stdout: StdioCollector {
            onStreamFinished : {
                notifications = []
            }
        }
    }

    Process{
        id: refresh
        command: ["dunstctl", "history"]
        running: true
        stdout: StdioCollector {
            onStreamFinished : {
                loadHistory(JSON.parse(this.text))
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: refresh.running = true
    }
}
