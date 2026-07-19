import "./components"
import "./config"
import "./services"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

PopupWindow {
    id: shutdownMenu

    property var setVisibility: function(vis) {
        shutdownMenu.visible = vis;
        grab.active = shutdownMenu.visible;
        if (shutdownMenu.visible) {
            Context.controlCenter.visible = false;
            Context.appRunner.setVisibility(false);
        }
    }

    onVisibleChanged: {
        if (!visible && !Context.statusBar.beingHovered)
            Context.statusBar.visible = Context.statusBar.shouldBeVisible;

    }
    color: "transparent"
    visible: false
    implicitWidth: 200
    implicitHeight: 60
    Component.onCompleted: Context.shutdownMenu = shutdownMenu

    Shortcut {
        sequence: "Escape"
        onActivated: setVisibility(false)
    }

    HyprlandFocusGrab {
        id: grab

        windows: [shutdownMenu]
        active: false
        onActiveChanged: {
            if (!active)
                shutdownMenu.visible = false;

        }
    }

    Rectangle {
        id: panel

        property real buttonSize: 40
        property real iconSize: 30
        property color iconColor: Theme.accent
        property color buttonColor: Theme.primary2

        anchors.fill: parent
        radius: 10
        color: Theme.background

        RowLayout {
            anchors.centerIn: parent
            spacing: 30

            Button {
                id: shutdown

                focus: true
                color: panel.buttonColor
                buttonSize: panel.buttonSize
                iconSize: panel.iconSize
                iconSource: Quickshell.iconPath("system-shutdown")
                iconColor: panel.iconColor
                Keys.onPressed: (event) => {
                    switch (event.key) {
                    case Navigation.parent:
                        setVisibility(false);
                        break;
                    case Navigation.right:
                        reboot.focus = true;
                        break;
                    default:
                        return ;
                    }
                    event.accepted = true;
                }
                onClick: System.shutDown
            }

            Button {
                id: reboot

                color: panel.buttonColor
                buttonSize: panel.buttonSize
                iconSize: panel.iconSize
                iconSource: Quickshell.iconPath("system-reboot")
                iconColor: panel.iconColor
                Keys.onPressed: (event) => {
                    switch (event.key) {
                    case Navigation.parent:
                        setVisibility(false);
                        break;
                    case Navigation.left:
                        shutdown.focus = true;
                        break;
                    case Navigation.right:
                        logout.focus = true;
                        break;
                    default:
                        return ;
                    }
                    event.accepted = true;
                }
                onClick: System.reboot
            }

            Button {
                id: logout

                color: panel.buttonColor
                buttonSize: panel.buttonSize
                iconSize: panel.iconSize
                iconSource: Quickshell.iconPath("system-log-out-rtl")
                iconColor: panel.iconColor
                Keys.onPressed: (event) => {
                    switch (event.key) {
                    case Navigation.parent:
                        setVisibility(false);
                        break;
                    case Navigation.left:
                        reboot.focus = true;
                        break;
                    default:
                        return ;
                    }
                    event.accepted = true;
                }
                onClick: System.logOut
            }

        }

    }

    IpcHandler {
        function toggle() {
            if (!shutdownMenu.visible)
                Context.statusBar.visible = true;

            shutdownMenu.setVisibility(!shutdownMenu.visible);
            if (!shutdownMenu.visible)
                Context.statusBar.visible = Context.statusBar.shouldBeVisible;

        }

        target: "shutdownMenu"
    }

    mask: Region {
        item: panel
    }

}
