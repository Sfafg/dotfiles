import "./services"
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope {
    PanelWindow {
        id: statusBar

        property bool shouldBeVisible: false
        property bool beingHovered: false

        visible: false
        Component.onCompleted: Context.statusBar = statusBar
        color: "transparent"
        implicitHeight: clockWidget.height + 10
        exclusiveZone: 0
        exclusionMode: ExclusionMode.Ignore

        anchors {
            top: true
            left: true
            right: true
        }

        ClockWidget {
            id: clockWidget

            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            timeText: Time.time
            dateText: controlCenter.visible ? Time.date : ""

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (!controlCenter.visible)
                        Context.statusBar.visible = true;

                    controlCenter.visible = !controlCenter.visible;
                    controlCenter.focusGrab = controlCenter.visible;
                    if (controlCenter.visible) {
                        Context.appRunner.setVisibility(false);
                        Context.shutdownMenu.setVisibility(false);
                    }
                    if (!controlCenter.visible)
                        Context.statusBar.visible = Context.statusBar.shouldBeVisible;

                }
            }

            HoverHandler {
                id: hover

                onHoveredChanged: {
                    statusBar.beingHovered = hovered;
                }
            }

        }

        mask: Region {
            item: clockWidget
        }

    }

    ControlCenter {
        id: controlCenter

        anchor.window: statusBar
        anchor.rect.x: statusBar.width / 2 - controlCenter.width / 2
        anchor.rect.y: statusBar.height + 13
        onVisibleChanged: {
            statusBar.WlrLayershell.layer = controlCenter.visible ? WlrLayer.Overlay : WlrLayer.Top;
        }
    }

    ShutdownMenu {
        id: shutdownMenu

        anchor.window: statusBar
        anchor.rect.x: statusBar.width / 2 - shutdownMenu.width / 2
        anchor.rect.y: statusBar.height + 13
        onVisibleChanged: {
            statusBar.WlrLayershell.layer = shutdownMenu.visible ? WlrLayer.Overlay : WlrLayer.Top;
        }
    }

    IpcHandler {
        function toggle() {
            if (!controlCenter.visible)
                Context.statusBar.visible = true;

            controlCenter.visible = !controlCenter.visible;
            controlCenter.focusGrab = controlCenter.visible;
            if (controlCenter.visible) {
                Context.appRunner.setVisibility(false);
                Context.shutdownMenu.setVisibility(false);
            }
            if (!controlCenter.visible)
                Context.statusBar.visible = Context.statusBar.shouldBeVisible;

        }

        target: "controlCenter"
    }

    IpcHandler {
        function toggle() {
            statusBar.shouldBeVisible = !statusBar.shouldBeVisible;
            statusBar.visible = statusBar.shouldBeVisible;
        }

        target: "statusBar"
    }

}
