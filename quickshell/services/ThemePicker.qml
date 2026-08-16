import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Singleton {
    id: root

    property var theme: ""

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            let hour = new Date().getHours();
            if (hour >= 6 && hour < 11)
                root.theme = "morning";
            else if (hour >= 11 && hour < 17)
                root.theme = "noon";
            else if (hour >= 17 && hour < 21)
                root.theme = "evening";
            else
                root.theme = "night";
        }
    }

}
