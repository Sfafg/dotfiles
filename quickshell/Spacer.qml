import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQml.Models
import QtQuick.Layouts

Item{
    implicitWidth: parent.width
    implicitHeight: 2
    Rectangle{
        width: parent.width-80
        implicitHeight:1
        anchors.centerIn: parent
        color: Qt.rgba(1,1,1,0.1)
    }
}
