import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../config"

ListView{
    property int maxShownItemCount: 4
    property int itemHeight: 40
    property bool outOfBounds: false
    id: view
    spacing: 10
    Layout.preferredHeight: (itemHeight+spacing)*Math.min(view.count, maxShownItemCount) + (view.count > maxShownItemCount ? spacing / 2 : - spacing)
    Layout.fillWidth: true
    clip: true

    Keys.onPressed: (event) => {
        outOfBounds=false
        switch (event.key) {
            case Navigation.down:
            positionViewAtIndex(currentIndex, ListView.Visible)
            if(currentIndex >= count-1) return
            currentIndex = currentIndex + 1
            break

            case Navigation.up:
            positionViewAtIndex(currentIndex, ListView.Visible)
            if(currentIndex <= 0) {
                outOfBounds= true
                return
            }
            currentIndex = currentIndex - 1
            break
            default: return
        }
        event.accepted = true
    }
}
