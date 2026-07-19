import "./services"
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope {
    PanelWindow {
        id: window

        color: "transparent"
        implicitHeight: 60
        exclusiveZone: 0
        exclusionMode: ExclusionMode.Ignore

        anchors {
            top: true
            left: true
            right: true
        }

        Rectangle {
            id: region

            height: parent.height
            width: 200
            anchors.centerIn: parent
            color: "transparent"

            HoverHandler {
                id: hover

                onHoveredChanged: {
                    if (hovered) {
                        Context.statusBar.visible = true;
                        timer.running = false;
                    } else {
                        timer.running = true;
                    }
                }
            }

        }

        mask: Region {
            item: region
        }

    }

    Timer {
        id: timer

        interval: 500
        running: false
        repeat: false
        onTriggered: {
            if (Context.shutdownMenu.visible || Context.controlCenter.visible || Context.statusBar.beingHovered) {
                restart();
                return ;
            }
            Context.statusBar.visible = Context.statusBar.shouldBeVisible;
        }
    }

}
