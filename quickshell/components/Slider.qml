import QtQuick
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import "../config"

Item {
    property alias iconSource: icon.source
    property real value: 0.5 
    property var onMoved: null 

    implicitWidth: 100
    implicitHeight: 40

    Keys.onPressed: (event) => {
        switch (event.key) {
            case Navigation.left: if(!onMoved)return; onMoved(Math.max(0, Math.min(1, value-0.05))); break
            case Navigation.right: if(!onMoved)return; onMoved(Math.max(0, Math.min(1, value+0.05))); break
            default: return
        }
        event.accepted = true
    }

    ClippingRectangle {
        id: track
        anchors.fill:parent
        radius: height/2
        color: Theme.primary3

        border.width: parent.activeFocus ? Theme.selectedBorderWidth : 0
        border.color: Theme.selectedBorder

        Rectangle {
            id: fill
            width: track.width * value
            height: track.height
            radius: height/2
            color: Theme.accent
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onPositionChanged: (mouse) => {
            if(onMoved) onMoved(Math.max(0, Math.min(1, mouse.x / track.width)))
        }

        onPressed: (mouse) => {
            if(onMoved) onMoved(Math.max(0, Math.min(1, mouse.x / track.width)))
        }
    }


    Rectangle{
        anchors.fill: parent
        color: "transparent"
        anchors.margins: 8
        IconImage {
            id: icon
            implicitSize: 28
            anchors.verticalCenter: parent.verticalCenter
            layer.enabled: true
            layer.effect: ColorOverlay {
                color: Theme.primary2
            }
        }
    }
}
