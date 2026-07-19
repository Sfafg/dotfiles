import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "./components"
import "./config"
import "./services"
import "./utils"

Widget{
    property alias widgetFocus: widget.focus
    id: widget
    iconSource: Quickshell.iconPath("preferences-desktop-display")
    isActive: false
    mainText: "Display"
    secondaryText: `${Display.monitors[0]?.width}x${Display.monitors[0]?.height}\@${Display.monitors[0]?.refreshRate}`
    implicitWidth: 260
}
