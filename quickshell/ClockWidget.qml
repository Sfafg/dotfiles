import "./config"
import "./services"
import QtQuick
import Quickshell.Hyprland

Rectangle {
    property string timeText
    property string dateText

    radius: height / 2
    implicitHeight: 48 + (dateText == "" ? 0 : 22)
    width: text.implicitWidth + 80 + (dateText == "" ? 0 : 82)
    color: Theme.background

    Rectangle {
        x: parent.radius
        width: (parent.width - parent.radius * 2) * Math.min(Time.seconds / 60 + Time.minutes % 2, 1)
        height: 2
        color: Theme.accent
    }

    Rectangle {
        x: parent.radius
        width: (parent.width - parent.radius * 2) * Math.max(Time.seconds / 60 - (Time.minutes + 1) % 2, 0)
        height: 2
        color: Theme.background
    }

    Text {
        id: text

        font.pixelSize: Fnt.fontSize
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        text: timeText
        color: Theme.text
        font.family: Fnt.fontFamily
    }

    Text {
        visible: dateText != ""
        font.pixelSize: Fnt.fontSize2
        font.family: Fnt.fontFamily
        text: dateText
        anchors.top: text.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: Theme.textSecondary
    }

    WorkspaceWidget {
        id: workspaceWidget

        visible: false
        anchors.centerIn: parent
        implicitWidth: parent.width - 10
        anchors.bottom: parent.bottom
        scale: 0.9
        reduced: true
    }

    Connections {
        function onFocusedWorkspaceChanged() {
            if (Context.controlCenter.visible)
                return ;

            workspaceWidget.visible = true;
            text.visible = false;
            timer.running = false;
            timer.running = true;
        }

        target: Hyprland
    }

    Connections {
        function onVisibleChanged() {
            if (!Context.controlCenter.visible)
                return ;

            workspaceWidget.visible = false;
            text.visible = true;
            timer.running = false;
        }

        target: Context.controlCenter
    }

    Timer {
        id: timer

        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            workspaceWidget.visible = false;
            text.visible = true;
        }
    }

}
