import "./config"
import QtQuick
import Quickshell
import Quickshell.Hyprland

Rectangle {
    id: root
    implicitWidth: 100
    implicitHeight: 25
    radius: height / 2
    color: "transparent"
    property bool reduced: false
    property string activeSpecial: ""

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activespecial") 
                activeSpecial = event.data.split(',')[0];
            
            if (event.name === "workspace") 
                activeSpecial = "";            
        }
    }
    Row {
        anchors.centerIn: parent

        spacing: 5
        Repeater {
            id: repeater
            model: ScriptModel {
                values: [...Hyprland.workspaces.values]
                .filter(r=> r.id >=0)
            }
            Item{
                height: 28
                width: (root.width / repeater.model.values.length - 5)
                property real radius: height/2
                property real innerRadius: reduced ?radius:3
                property real spacing: reduced ? 0:2
                property var specialWorkspace: Hyprland.workspaces.values.find(w =>  w.name === "special:magic"+modelData.id)
                Rectangle {
                    anchors.left: parent.left
                    width:parent.width/(reduced?1:2)-spacing/2
                    height:parent.height
                    radius:parent.innerRadius
                    topLeftRadius:parent.radius
                    bottomLeftRadius:parent.radius
                    color: Theme.primary3
                    border.width: 2
                    border.color: modelData.focused && (!(activeSpecial == specialWorkspace?.name) || reduced) ? Theme.primary1:Theme.primary3

                    Text {
                        anchors.centerIn: parent
                        text: modelData.name
                        color: modelData.active ? Theme.accent : Theme.text
                        font.family: Fnt.fontFamily
                        font.pixelSize: Fnt.fontSize2
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked:{ 
                            if (activeSpecial) {
                                Hyprland.dispatch(
                                    "hl.dsp.workspace.toggle_special("+activeSpecial.slice(8)+")"
                                )
                                Hyprland.dispatch(
                                    "hl.dsp.workspace.toggle_special("+activeSpecial.slice(8)+")"
                                )
                            }
                            modelData.activate()
                        }
                    }
                }


                Rectangle{
                    visible:!reduced
                    anchors.right: parent.right
                    width:parent.width/2-spacing/2
                    height:parent.height
                    radius:parent.innerRadius
                    topRightRadius:parent.radius
                    bottomRightRadius:parent.radius
                    color: specialWorkspace ? Theme.primary3 : Theme.primary3 
                    border.width: 2
                    border.color: activeSpecial == specialWorkspace?.name && modelData.focused ? Theme.primary1:Theme.primary3

                    Text {
                        anchors.centerIn: parent
                        text: specialWorkspace ? "s" : ""
                        color: Theme.text
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            modelData.activate();
                            if (specialWorkspace) specialWorkspace.activate()
                        }
                    }
                }

            }
        }
    }
}
