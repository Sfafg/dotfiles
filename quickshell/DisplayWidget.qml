import "./components"
import "./config"
import "./services"
import "./utils"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Widget {
    id: widget

    property alias widgetFocus: widget.focus

    iconSource: Quickshell.iconPath("preferences-desktop-display")
    isActive: false
    mainText: "Display"
    secondaryText: Display.monitors[0].mode
    implicitWidth: 260
}
