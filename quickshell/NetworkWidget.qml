import "./components"
import "./config"
import "./services"
import "./utils"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

ColumnLayout {
    property alias widgetFocus: widget.focus
    property alias moreActive: view.visible
    property alias onMore: widget.onMore
    property alias more: view

    Widget {
        id: widget

        iconSource: Quickshell.iconPath("network-wireless")
        isActive: Wifi.isOn
        mainText: "Wi-Fi"
        secondaryText: Utils.limitStr(Wifi.activeWirelessConnection, 16)
        onMore: isActive ? function() {
            view.visible = !view.visible;
        } : null
        onClick: function() {
            Wifi.isOn = !Wifi.isOn;
            if (!Wifi.isOn)
                Wifi.activeWirelessConnection = "";

        }
        Keys.onPressed: (event) => {
            switch (event.key) {
            case Navigation.down:
                if (!view.visible)
                    return ;

                view.focus = true;
                break;
            case Navigation.child:
                if (!Wifi.isOn || Wifi.availableNetworks.length == 0)
                    return ;

                view.visible = !view.visible;
                break;
            default:
                return ;
            }
            event.accepted = true;
        }
    }

    ItemList {
        id: view

        visible: false
        model: Wifi.availableNetworks
        maxShownItemCount: 3
        itemHeight: 40
        Keys.onPressed: (event) => {
            switch (event.key) {
            case Navigation.up:
                if (!outOfBounds)
                    return ;

                widget.focus = true;
                break;
            case Navigation.parent:
                view.visible = false;
                widget.focus = true;
                break;
            default:
                return ;
            }
            event.accepted = true;
        }

        delegate: ListItem {
            Keys.onPressed: (event) => {
                switch (event.key) {
                case Navigation.select:
                    Wifi.activeWirelessConnection = modelData.ssid;
                    break;
                default:
                    return ;
                }
                event.accepted = true;
            }

            RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                Item {
                }

                BusyIndicator {
                    id: busy

                    visible: false
                    running: true
                    layer.enabled: true

                    layer.effect: ColorOverlay {
                        color: "white"
                    }

                }

                IconImage {
                    visible: !busy.visible
                    source: Quickshell.iconPath("network-wireless-" + Math.round(modelData.strength / 20) * 20)
                    implicitSize: 30
                    layer.enabled: true

                    layer.effect: ColorOverlay {
                        color: "white"
                    }

                }

                Text {
                    font.family: Fnt.fontFamily
                    font.pixelSize: Fnt.fontSize2
                    color: Theme.text
                    text: Utils.limitStr(modelData.ssid, 20)
                }

            }

            MouseArea {
                id: mouseArea

                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Wifi.activeWirelessConnection = modelData.ssid
            }

        }

    }

}
