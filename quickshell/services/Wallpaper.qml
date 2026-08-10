import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Singleton {
    id: root

    function getWallpaper() {
        let hour = new Date().getHours();
        if (hour >= 6 && hour < 12)
            return "morning";
        else if (hour >= 12 && hour < 18)
            return "noon";
        else if (hour >= 18 && hour < 22)
            return "evening";
        else
            return "night";
    }

    Component.onCompleted: {
        changeWallpaper.change(getWallpaper());
    }

    Process {
        id: changeWallpaper

        property string currentWallpaper: ""

        function change(name) {
            if (name === currentWallpaper)
                return ;

            currentWallpaper = name;
            command = ["awww", "img", `/home/slawek/.config/hypr/assets/backgrounds/wallpaper_${name}.jpg`, "--transition-fps", "255", "--transition-type", "outer", "--transition-duration", "0.8"];
            running = true;
        }

    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            changeWallpaper.change(root.getWallpaper());
        }
    }

}
