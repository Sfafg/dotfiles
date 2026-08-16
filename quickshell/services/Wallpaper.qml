import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Singleton {
    id: root

    property string currentWallpaper

    Connections {
        function onThemeChanged() {
            changeWallpaper.change(ThemePicker.theme);
        }

        target: ThemePicker
    }

    Process {
        id: changeWallpaper

        property string currentWallpaper: ""

        function change(name) {
            if (name === currentWallpaper)
                return ;

            console.log(`/home/slawek/.config/hypr/assets/backgrounds/wallpaper_${name}.jpg`);
            currentWallpaper = name;
            command = ["awww", "img", `/home/slawek/.config/hypr/assets/backgrounds/wallpaper_${name}.jpg`, "--transition-fps", "255", "--transition-type", "outer", "--transition-duration", "0.8"];
            running = true;
        }

    }

}
