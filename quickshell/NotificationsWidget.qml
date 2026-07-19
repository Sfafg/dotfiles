import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQml.Models
import Qt5Compat.GraphicalEffects
import "./components"
import "./config"
import "./services"


ColumnLayout{
    property alias notificationList: view
    visible:  Notifications.notifications.length > 0

    RowLayout{
        Text{ 
            text: "Notifications"
            font.pixelSize: Fnt.fontSize3
            font.family: Fnt.fontFamily
            color: Theme.text1
        }
        Item { Layout.fillWidth: true }
        Text{ 
            text: "Clear All"
            font.pixelSize: Fnt.fontSize4
            font.family: Fnt.fontFamily
            color: Theme.accent1
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Notifications.clear = true
            }
        }
    }

    ItemList{
        id: view
        model: Notifications.notifications
        maxShownItemCount: 2
        itemHeight: 80

        delegate:
        ListItem{
            color: Theme.primary4

            RowLayout{
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10
                Item{}
                IconImage {
                    source: Quickshell.iconPath(modelData.icon)
                    implicitSize: 50
                }
                Column{
                    spacing:4

                    Text{
                        font.pixelSize: Fnt.fontSize4
                        font.family: Fnt.fontFamily
                        text:modelData.app
                        color: Theme.text1
                    }
                    Text{
                        font.pixelSize: Fnt.fontSize2
                        font.family: Fnt.fontFamily
                        text:modelData.title
                        color: Theme.text
                    }
                    Text{
                        font.pixelSize: Fnt.fontSize5
                        font.family: Fnt.fontFamily
                        text:modelData.time
                        color: Theme.textSecondary
                    }
                }
            }
        }
    }
}
