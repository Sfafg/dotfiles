import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "./components"
import "./config"
import "./services"

Widget{
    id: widget
    iconSource: Quickshell.iconPath("notifications-disabled")
    isActive: false
    mainText: "Do not disturb"
    secondaryText: isActive ? "on" : "off" 

    onClick:function(){
        isActive = !isActive
    }

    property alias widgetFocus: widget.focus

    // Keys.onPressed: (event) => {
    //     switch (event.key) {
    //         case Navigation.select: widget.isActive = !widget.isActive; break
    //         default: return
    //     }
    //     event.accepted = true
    // }
}
