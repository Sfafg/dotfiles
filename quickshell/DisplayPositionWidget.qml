import "./components"
import "./config"
import "./services"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

ClippingRectangle {
    id: root

    property real minX: Math.min.apply(null, Display.monitors.map((m) => {
        return m.x;
    }))
    property real minY: Math.min.apply(null, Display.monitors.map((m) => {
        return m.y;
    }))
    property real maxX: Math.max.apply(null, Display.monitors.map((m) => {
        return m.x + m.displayWidth;
    }))
    property real maxY: Math.max.apply(null, Display.monitors.map((m) => {
        return m.y + m.displayHeight;
    }))
    property real scale: width / (maxX - minX) * 0.87

    Layout.fillWidth: true
    implicitHeight: width * (maxY - minY) / (maxX - minX)
    radius: 10
    color: Theme.primary4

    Repeater {
        model: Display.monitors

        Rectangle {
            property point dragStart

            radius: 10
            x: modelData.x * root.scale + (root.width - (maxX + minX) * root.scale) / 2
            y: modelData.y * root.scale + (root.height - (maxY + minY) * root.scale) / 2
            width: modelData.displayWidth * root.scale
            height: modelData.displayHeight * root.scale
            color: modelData.disabled ? Theme.primary3 : Theme.primary2_5
            border.width: 2
            border.color: modelData.disabled ? Theme.accent2 : Theme.accent

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressed: (mouse) => {
                    parent.dragStart = Qt.point(mouse.x, mouse.y);
                }
                onPositionChanged: (mouse) => {
                    if (pressed) {
                        modelData.x += mouse.x - parent.dragStart.x;
                        modelData.y += mouse.y - parent.dragStart.y;
                    }
                }
                onReleased: (mouse) => {
                    let monitors = Display.monitors.slice();
                    for (let monitor of monitors) {
                        if (monitor.output == modelData.output) {
                            monitor.x = Math.round(modelData.x);
                            monitor.y = Math.round(modelData.y);
                            break;
                        }
                    }
                    for (let monitor of monitors) {
                        monitor.x -= monitors[0].x;
                        monitor.y -= monitors[0].y;
                    }
                    for (let steps = 0; steps < 4; steps++) {
                        let noCollisons = true;
                        for (let monitorA of monitors) {
                            for (let monitorB of monitors) {
                                if (monitorA.output == monitorB.output)
                                    continue;

                                let xDepth1 = monitorB.x - (monitorA.x + monitorA.displayWidth);
                                let xDepth2 = monitorA.x - (monitorB.x + monitorB.displayWidth);
                                let yDepth1 = monitorA.y - (monitorB.y + monitorB.displayHeight);
                                let yDepth2 = monitorB.y - (monitorA.y + monitorA.displayHeight);
                                if (!(xDepth1 < 0 && xDepth2 < 0) || !(yDepth1 < 0 && yDepth2 < 0))
                                    continue;

                                noCollisons = false;
                                let xDepth = Math.abs(xDepth1) < Math.abs(xDepth2) ? xDepth1 : -xDepth2;
                                let yDepth = Math.abs(yDepth1) < Math.abs(yDepth2) ? -yDepth1 : yDepth2;
                                if (Math.abs(xDepth) < Math.abs(yDepth))
                                    monitorB.x = Math.round(monitorB.x - xDepth);
                                else
                                    monitorB.y = Math.round(monitorB.y - yDepth);
                            }
                        }
                        if (noCollisons)
                            break;

                    }
                    Display.prefferedMonitors = monitors;
                    Display.monitors = monitors;
                }
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 0
                rotation: [1, 3, 5, 7].includes(modelData.transform) ? 90 : 0

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: modelData.output
                    color: modelData.disabled ? Theme.text1 : Theme.text
                    font.pixelSize: Fnt.fontSize2
                    font.family: Fnt.fontFamily
                    font.bold: true
                }

                TextField {
                    id: modeText

                    leftPadding: 10
                    rightPadding: 10
                    text: modelData.mode
                    color: modelData.disabled ? Theme.textSecondary : Theme.text1
                    font.pixelSize: Fnt.fontSize3
                    font.family: Fnt.fontFamily
                    onAccepted: {
                        for (let monitor of Display.monitors) {
                            if (monitor.output == modelData.output) {
                                monitor.mode = text;
                                break;
                            }
                        }
                        Display.monitors = Display.monitors.slice();
                        Display.prefferedMonitors = Display.monitors;
                        focus = false;
                        root.focus = true;
                    }
                    Keys.onPressed: (event) => {
                        switch (event.key) {
                        case Navigation.parent:
                            text = modelData.mode;
                            focus = false;
                            root.focus = true;
                            break;
                        default:
                            return ;
                        }
                        event.accepted = true;
                    }

                    validator: RegularExpressionValidator {
                        regularExpression: /^\d+x\d+@\d+$/
                    }

                    background: Rectangle {
                        radius: 3
                        color: "transparent"
                        border.width: 1
                        border.color: Theme.selectedBorder
                        opacity: 0.1
                    }

                }

            }

            Item {
                rotation: [1, 3, 5, 7].includes(modelData.transform) ? 90 : 0
                anchors.centerIn: parent
                width: modelData.width * root.scale
                height: modelData.height * root.scale

                Button {
                    id: turnOff

                    onClick: function() {
                        for (let monitor of Display.monitors) {
                            if (monitor.output == modelData.output) {
                                monitor.disabled = !monitor.disabled;
                                break;
                            }
                        }
                        Display.monitors = Display.monitors.slice();
                        Display.prefferedMonitors = Display.monitors;
                    }
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: 6
                    focus: false
                    color: "transparent"
                    buttonSize: 24
                    iconSize: 24
                    iconSource: Quickshell.iconPath("system-shutdown")
                    iconColor: Theme.accent
                    glow: false
                }

                Button {
                    id: rotateButton

                    onClick: function() {
                        for (let monitor of Display.monitors) {
                            if (monitor.output == modelData.output) {
                                let isFlipped = monitor.transform >= 4;
                                monitor.transform = (monitor.transform + 1) % 4 + isFlipped * 4;
                                [monitor.displayWidth, monitor.displayHeight] = [monitor.displayHeight, monitor.displayWidth];
                                break;
                            }
                        }
                        Display.monitors = Display.monitors.slice();
                        Display.prefferedMonitors = Display.monitors;
                    }
                    anchors.top: parent.top
                    anchors.right: turnOff.left
                    anchors.margins: 6
                    anchors.rightMargin: 0
                    focus: false
                    color: "transparent"
                    buttonSize: 24
                    iconSize: 24
                    iconSource: Quickshell.iconPath("circular-arrow-shape")
                    iconColor: Theme.accent
                    glow: false
                }

                Button {
                    id: mirrorButton

                    onClick: function() {
                        for (let monitor of Display.monitors) {
                            if (monitor.output == modelData.output) {
                                let isFlipped = monitor.transform >= 4;
                                isFlipped = !isFlipped;
                                monitor.transform = monitor.transform % 4 + isFlipped * 4;
                                break;
                            }
                        }
                        Display.monitors = Display.monitors.slice();
                        Display.prefferedMonitors = Display.monitors;
                    }
                    anchors.top: parent.top
                    anchors.right: rotateButton.left
                    anchors.margins: 6
                    anchors.rightMargin: 0
                    focus: false
                    color: "transparent"
                    buttonSize: 24
                    iconSize: 24
                    iconSource: Quickshell.iconPath("osd-rotate-flip")
                    iconColor: Theme.accent
                    glow: false
                }

            }

        }

    }

}
