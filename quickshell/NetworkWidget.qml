import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "./components"
import "./config"
import "./services"
import "./utils"

ColumnLayout{
    property alias widgetFocus: widget.focus
    Widget{
        id: widget
        iconSource: Quickshell.iconPath("network-wireless")
        isActive: Wifi.isOn
        mainText: "Wi-Fi"
        secondaryText: Utils.limitStr(Wifi.activeWirelessConnection, 16) 
        onMore: isActive? function(){view.visible=!view.visible} : null
        onClick: function(){
            Wifi.isOn = !Wifi.isOn
            if(!Wifi.isOn) Wifi.activeWirelessConnection = ""
        }
        Keys.onPressed: (event) => {
            switch (event.key) {
                case Navigation.down:if(!view.visible)return; view.focus=true; break
                case Navigation.child: view.visible=!view.visible; view.focus=view.visible; break
                default: return
            }
            event.accepted = true
        }
    }

    ItemList{
        id: view
        visible: false
        model: Wifi.availableNetworks

        maxShownItemCount: 3
        itemHeight: 40

        Keys.onPressed: (event) => {
            switch (event.key) {
                case Navigation.up:if(!outOfBounds)return; widget.focus=true; break
                case Navigation.parent: view.visible=false; widget.focus=true; break
                default: return
            }
            event.accepted = true
        }

        delegate:
        ListItem{
            RowLayout{
                anchors.verticalCenter:parent.verticalCenter
                spacing: 10
                Item{}
                BusyIndicator{
                    id: busy
                    visible: false
                    running:true
                    layer.enabled: true
                    layer.effect: ColorOverlay { color: "white" }
                }
                IconImage {
                    visible: !busy.visible
                    source: Quickshell.iconPath("network-wireless-" + Math.round(modelData.strength / 20.0)*20)
                    implicitSize: 30
                    layer.enabled: true
                    layer.effect: ColorOverlay { color: "white" }
                }

                Text{
                    font.family: Fnt.fontFamily
                    font.pixelSize: Fnt.fontSize2
                    color: Theme.text
                    text: Utils.limitStr(modelData.ssid, 20)
                }
            }
            MouseArea{
                id: mouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Wifi.activeWirelessConnection = modelData.ssid
            }
            Keys.onPressed: (event) => {
                switch (event.key) {
                case Navigation.select:
                    Wifi.activeWirelessConnection = modelData.ssid
                    break
                default: return
                }
                event.accepted = true
            }
        }
    }
}
