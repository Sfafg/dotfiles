import Quickshell
import QtQuick
import QtQuick.Layouts
import "../config"
Rectangle{
    focus:true
    id:rect
    color: Theme.primary3
    width: ListView.view.width
    height: ListView.view.itemHeight
    radius: 15
    border.width: activeFocus ? Theme.selectedBorderWidth : 0
    border.color: Theme.selectedBorder
}
