import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "./components"
import "./config"
import "./services"

ClippingRectangle{
    id: root
    property real minX: Math.min(...Display.monitors.map(m => m.x))
    property real minY: Math.min(...Display.monitors.map(m => m.y))
    property real maxX: Math.max(...Display.monitors.map(m => m.x+m.width))
    property real maxY: Math.max(...Display.monitors.map(m => m.y+m.height))
    property real scale: width / (maxX-minX) * 0.85

    Layout.fillWidth:true
    implicitHeight: width * (maxY-minY)/(maxX-minX)
    radius: 10
    color: Theme.primary4

    Repeater{
        model: Display.monitors

        Rectangle{
            radius:10
            x: modelData.x*root.scale +(root.width-(maxX+minX)*root.scale)/2
            y: modelData.y*root.scale +(root.height-(maxY+minY)*root.scale)/2
            width: modelData.width*root.scale
            height: modelData.height*root.scale
            color: Theme.primary2
            border.width: 2
            border.color: Theme.accent

            property point dragStart

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onPressed: (mouse) => {
                    parent.dragStart = Qt.point(mouse.x, mouse.y)
                }

                onPositionChanged: (mouse) => {
                    if (pressed) {
                        modelData.x += mouse.x - parent.dragStart.x
                        modelData.y += mouse.y - parent.dragStart.y
                    }
                }

                onReleased: (mouse)=>{
                    let monitors = Display.monitors.slice()
                    // if(Math.abs(mouse.x - parent.dragStart.x) + Math.abs(mouse.y - parent.dragStart.y) < 2)
                    // {
                    //     for (let i = 0; i < monitors.length; i++) {
                    //         if (monitors[i].id === modelData.id)
                    //         {
                    //             monitors[i] = modelData
                    //         }
                    //     }
                    // }

                    let minx = Display.monitors[0].x
                    let miny = Display.monitors[0].y
                    for(const monitor of monitors){
                        if(monitor.id === modelData.id) continue
                        let xDist1 = modelData.x - monitor.x - monitor.width 
                        let xDist2 = modelData.x + modelData.width - monitor.x 
                        let xDist = Math.abs(xDist1) < Math.abs(xDist2) ? xDist1 : xDist2 

                        let yDist1 = modelData.y - monitor.y - monitor.height 
                        let yDist2 = modelData.y + modelData.height - monitor.y 
                        let yDist = Math.abs(yDist1) < Math.abs(yDist2) ? yDist1 : yDist2 

                        if(Math.abs(xDist) < Math.abs(yDist))
                            modelData.x -= xDist - (Math.abs(xDist1) < Math.abs(xDist2) ? 1: -1)
                        else
                            modelData.y -= yDist - (Math.abs(yDist1) < Math.abs(yDist2) ? 1: -1)


                        minx = Math.min(monitor.x, minx)
                        miny = Math.min(monitor.y, miny)
                    }

                    for (let i = 0; i < monitors.length; i++) {
                        if (monitors[i].id === modelData.id)
                            monitors[i] = modelData
                        
                        monitors[i].x -= minx
                        monitors[i].y -= miny
                        monitors[i].x = Math.round(monitors[i].x)
                        monitors[i].y = Math.round(monitors[i].y)
                    }

                    Display.prefferedMonitors = monitors
                }
            }
            ColumnLayout{
                anchors.centerIn: parent
                rotation: [1,3,5,7].includes(modelData.transform) ? 90:0
                Text{
                    Layout.alignment: Qt.AlignHCenter
                    text: modelData.name
                    color: Theme.text
                    font.pixelSize: Fnt.fontSize2
                    font.family: Fnt.fontFamily
                    font.bold: true
                }

                Text{
                    id: modeText
                    text: `${modelData.width}x${modelData.height}\n${modelData.refreshRate}Hz`
                    color: Theme.text1
                    font.pixelSize: Fnt.fontSize3
                    font.family: Fnt.fontFamily
                }
            }
        }
    }
}
