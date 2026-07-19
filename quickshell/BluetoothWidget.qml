import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Bluetooth
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import "./config"
import "./components"
import "./services"
import "./utils"

ColumnLayout{
property alias widgetFocus: widget.focus
Widget{
    id:widget
    iconSource: Quickshell.iconPath("network-bluetooth")
    isActive: Bluetooth.defaultAdapter?.enabled ?? false
    mainText: "Bluetooth"
    secondaryText: isActive ? "on" : "off"
    onMore: isActive? function(){view.visible=!view.visible} : null
    onClick:function(){
        isActive = !isActive
        Bluetooth.defaultAdapter.enabled = isActive
        Bluetooth.defaultAdapter.pairable = true;
    }

    onIconClick:function(){
        Bluetooth.defaultAdapter.discovering = true;
        Bluetooth.defaultAdapter.pairable = true;
        Bluetooth.defaultAdapter.discoverable = true;
    }

    Keys.onPressed: (event) => {
        switch (event.key) {
            case Navigation.down:if(!view.visible)return;view.focus=true; break
            case Navigation.child: view.visible=!view.visible; view.focus=view.visible; break
            default: return
        }
        event.accepted = true
    }
}

ItemList{
    id: view
    visible: false
    model: ScriptModel {
        values: [...Bluetooth.devices.values]
        .filter(d=> d.deviceName.length > 0)
        .sort((a, b) => (b.connected - a.connected) || (b.paired - a.paired) || a.name.localeCompare(b.name))
    }

    maxShownItemCount: 4
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
                visible: modelData.state == BluetoothDeviceState.Disconnecting || modelData.state == BluetoothDeviceState.Connecting || modelData.pairing
                running:true
                layer.enabled: true
                layer.effect: ColorOverlay { color: "white" }
            }
            IconImage {
                visible: !busy.visible
                source: Quickshell.iconPath(modelData.icon || "computer")
                implicitSize: 30
            }
            Text{
                font.pixelSize: Fnt.fontSize2
                font.family: Fnt.fontFamily
                text: Utils.limitStr(modelData.deviceName || modelData.address, 18) 
                color: modelData.paired ? (modelData.connected ? Theme.text : Theme.text1) : Theme.textSecondary
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: function(mouse){
                if(mouse.button=== Qt.LeftButton)
                {
                    if(modelData.pairing) modelData.cancelPair()
                    else if(modelData.paired)
                        modelData.connected ? modelData.disconnect() : modelData.connect()
                    else
                        modelData.pair()
                }
                else if(mouse.button === Qt.RightButton)
                    modelData.forget()
            }
        }
        Keys.onPressed: (event) => {
            switch (event.key) {
            case Navigation.select:
                if(modelData.pairing) modelData.cancelPair()
                else if(modelData.paired) modelData.connected ? modelData.disconnect() : modelData.connect()
                else modelData.pair();
                break
            default: return
            }
            event.accepted = true
        }
    }
}
}
