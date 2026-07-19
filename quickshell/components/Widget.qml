import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import "../config"

ClippingRectangle {
    id: root
    property alias iconSource: icon.source
    property alias mainText: mainText.text
    property alias secondaryText: secondaryText.text
    property var onClick: null
    property var onIconClick: null
    property bool isActive: true
    property var onMore: null 
    property alias more : moreButton

    implicitWidth: 240
    implicitHeight: layout.implicitHeight + 20
    radius: 30
    color: isActive ? Theme.accent : Theme.primary3

    border.width: activeFocus ? Theme.selectedBorderWidth : 0
    border.color: Theme.selectedBorder
    Keys.onPressed: (event) => {
        switch (event.key) {
            case Navigation.select:if(!onClick)return; onClick(); break
            case Navigation.selectAlternative: if(onIconClick)onIconClick(); break
            default: return
        }
        event.accepted = true
    }

    MouseArea {
        enabled: onClick
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: onClick()
    }

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.leftMargin: 10
        // spacing: -10

        Rectangle{
            id: iconButton
            implicitWidth: icon.implicitSize + 32
            implicitHeight: icon.implicitSize + 32
            radius: height/2
            color: isActive ? Theme.accent1 : Theme.accent2

            IconImage {
                id: icon
                implicitSize: 20
                anchors.centerIn: parent
                layer.enabled: true
                layer.effect: ColorOverlay {
                    color: isActive ? Theme.primary3 : Theme.accent
                }
            }

            MouseArea {
                enabled: isActive && onIconClick
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: onIconClick()
            }
        }

        ColumnLayout {
            spacing: -3
            Layout.alignment: Qt.AlignLeft
            Text {
                id: mainText
                font.pixelSize: Fnt.fontSize1
                font.family: Fnt.fontFamily
                font.bold: true
                color: isActive ? Theme.textInverted : Theme.text 
            }

            Text {
                id: secondaryText
                font.pixelSize: Fnt.fontSize2
                font.family: Fnt.fontFamily
                color: isActive ? Theme.textSecondaryInverted: Theme.textSecondary
            }
        }
        Item{ Layout.fillWidth: true}

    }

    Rectangle{
        id: moreButton
        visible:onMore
        implicitWidth: dotsText.implicitWidth + 40
        height: parent.height
        radius: root.radius
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        color:isActive ?
                Qt.rgba(Theme.accent1.r, Theme.accent1.g, Theme.accent1.b, 0.3) :
                Qt.rgba(Theme.primary2.r, Theme.primary2.g, Theme.primary2.b, 0.3)

        Text{
            id: dotsText
            anchors.centerIn: parent
            font.pixelSize: Fnt.fontSize1
            font.family: Fnt.fontFamily
            font.bold: true
            text: "⋮"
            color: isActive ? Theme.primary3 : Theme.accent
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: onMore()
        }
    }
}
