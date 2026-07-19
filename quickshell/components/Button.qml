import "../config"
import Qt5Compat.GraphicalEffects
import QtQuick
import Quickshell
import Quickshell.Widgets

Rectangle {
    id: shutdown

    property real buttonSize: 50
    property alias iconSource: icon.source
    property alias iconSize: icon.implicitSize
    property color iconColor: Theme.primary3
    property var onClick: null

    width: buttonSize
    height: buttonSize
    radius: buttonSize / 2
    color: Theme.primary2
    border.width: activeFocus ? Theme.selectedBorderWidth : 0
    border.color: Theme.selectedBorder
    Keys.onPressed: (event) => {
        switch (event.key) {
        case Navigation.select:
            if (!onClick)
                return ;

            onClick();
            break;
        default:
            return ;
        }
        event.accepted = true;
    }

    Glow {
        anchors.centerIn: icon
        width: icon.implicitSize / (36 * 2)
        height: icon.implicitSize
        source: icon
        color: iconColor
        samples: 33
        spread: 0.4
    }

    IconImage {
        id: icon

        anchors.centerIn: parent
        layer.enabled: true

        layer.effect: ColorOverlay {
            color: iconColor
        }

    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (onClick)
                onClick();

        }
    }

}
