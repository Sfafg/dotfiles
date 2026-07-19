import "./components"
import "./services"
import "./config"
import "./utils"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    property var query:""

    PanelWindow {
        id: appRunner
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        HyprlandFocusGrab {
          id: grab
          windows: [ appRunner ]
          active: true
        }
        property var setVisibility: function(vis){
            appRunner.visible = vis;
            grab.active = appRunner.visible
            if(appRunner.visible)
                inputField.text=""

            if(appRunner.visible)
            {
                Context.controlCenter.visible=false
                Context.shutdownMenu.setVisibility(false)
            }
        }
        Component.onCompleted:Context.appRunner=appRunner

        focusable: true
        color: "transparent"
        visible: false
        exclusiveZone: 0
        exclusionMode: ExclusionMode.Ignore

        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }
        Shortcut{
            sequence: "Escape"
            onActivated: appRunner.visible=false
        }
        Shortcut{
            sequence: "Return"
            onActivated: {
                view.itemAtIndex(0).activate()
            }
        }

        Rectangle {
            id: panel

            anchors.centerIn: parent
            width: 400
            height: 600
            radius: 10
            color: Theme.background

            ColumnLayout {
                anchors.fill: parent

                Item {
                    height: 20
                }

                TextField {
                    id: inputField
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredHeight: 50
                    Layout.preferredWidth: 350
                    placeholderText: "Search app"
                    focus: true
                    onTextChanged: {
                        query = text.toLowerCase();
                        view.positionViewAtIndex(0,ListView.Center)
                    }
                    palette.placeholderText: Theme.textSecondary
                    palette.text: Theme.text
                    horizontalAlignment: TextInput.AlignHCenter
                    font.family: Fnt.fontFamily
                    font.pixelSize: Fnt.fontSize

                    background: Rectangle {
                        radius: 8
                        color: Theme.primary4
                        border.width: 1
                        border.color: Theme.accent2
                    }

                }

                ListView {
                    id: view
                    model: ScriptModel {
                        values: [...DesktopEntries.applications.values]
                        .filter(e=> !e.noDisplay)
                        .sort((a, b) => Utils.score(b, query) - Utils.score(a,query))
                    }

                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: 10
                    clip: true

                    delegate: Rectangle {
                        anchors.horizontalCenter: parent?.horizontalCenter
                        color: Theme.primary4
                        width: 350
                        height: 75
                        radius: 10
                        function activate(){
                                Utils.run(modelData)
                                appRunner.visible = false;
                            }

                        RowLayout {
                            anchors.verticalCenter: parent.verticalCenter
                            ClippingRectangle{
                                radius:10
                                width:icon.implicitSize
                                height:icon.implicitSize
                                Layout.margins: 20
                                color:"transparent"
                                IconImage {
                                    id:icon
                                    implicitSize: 55
                                    source: Quickshell.iconPath(modelData.icon)
                                }

                            }

                            Text {
                                Layout.alignment: Qt.AlignVCenter
                                text: Utils.limitStr(modelData.name, 25)
                                color: Theme.text
                                font.family: Fnt.fontFamily
                                font.pixelSize: Fnt.fontSize1
                            }

                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: parent.activate()
                        }

                    }

                }

                Item {
                    height: 20
                }

            }

        }

        mask: Region {
            item: panel
        }

    }
    IpcHandler {
        function toggle() {
            appRunner.setVisibility(!appRunner.visible)
        }

        target: "appRunner"
    }

}
