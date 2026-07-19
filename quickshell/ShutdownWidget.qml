import "./components"
import "./config"
import "./services"
import Qt5Compat.GraphicalEffects
import QtQuick
import Quickshell
import Quickshell.Widgets

Rectangle {
    width: icon.implicitSize + 32
    implicitHeight: icon.implicitSize + 32
    radius: height / 2
    color: Theme.accent2
    border.width: activeFocus ? Theme.selectedBorderWidth : 0
    border.color: Theme.selectedBorder
    Keys.onPressed: (event) => {
        switch (event.key) {
        case Navigation.select:
            Context.shutdownMenu.setVisibility(true);
            break;
        default:
            return ;
        }
        event.accepted = true;
    }

    IconImage {
        id: icon

        implicitSize: 24
        anchors.centerIn: parent
        source: Quickshell.iconPath("system-shutdown")
        layer.enabled: true

        layer.effect: ColorOverlay {
            color: Theme.accent
        }

    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Context.shutdownMenu.setVisibility(true)
    }

}
