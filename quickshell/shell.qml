import "./services"
import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    ShowBar {
        Component.onCompleted: {
            console.lod(Display.monitors.length);
        }
    }

    Bar {
    }

    AppRunner {
    }

    Item {
        Component.onCompleted: {
            console.log(Wallpaper.currentWallpaper);
        }
    }

}
