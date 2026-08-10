import "./services"
import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    ShowBar {
    }

    Bar {
    }

    AppRunner {
    }

    Item {
        Component.onCompleted: {
            console.log(Wallpaper.getWallpaper());
        }
    }

}
