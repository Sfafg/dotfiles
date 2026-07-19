import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQml.Models
import Quickshell.Bluetooth
import QtQuick.Layouts
import Quickshell.Io
import Qt5Compat.GraphicalEffects
import "./config"
import "./services"

ClippingRectangle{
    visible: Spotify.player != null
    radius: 20
    color: Theme.primary4

    border.width: activeFocus ? Theme.selectedBorderWidth : 0
    border.color: Theme.selectedBorder
    Keys.onPressed: (event) => {
        switch (event.key) {
            case Navigation.right: Spotify.player?.next(); break
            case Navigation.left: Spotify.player?.previous(); break
            case Navigation.selectAlternative: Spotify.player?.togglePlaying(); break
            default: return
        }
        event.accepted = true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Spotify.player?.togglePlaying()
    }

    Image{
        source: Spotify.player?.trackArtUrl ?? ""
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
    }
    Rectangle{
        id: track
        radius: height/2
        height: 3
        width: parent.width-80
        anchors.margins: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        color: Theme.primary2

        MouseArea {
            anchors.centerIn: parent
            width: parent.width
            height: 20
            cursorShape: Qt.PointingHandCursor

            onPressed: (mouse) => {
                let v = mouse.x / track.width
                v = Math.max(0, Math.min(1, v))
                Spotify.player.position = Spotify.player?.length*v
            }
        }
    }
    Rectangle{
        id: fill
        radius: height/2
        height: 3
        width: (parent.width-80)*(Spotify.player?.position/Spotify.player?.length)
        anchors.bottom: track.bottom
        anchors.left: track.left
        color: Theme.accent1
    }

    Text{
        text: Spotify.formatTime(Spotify.player?.position)
        color: Theme.text
        font.pixelSize: Fnt.fontSize5
        font.family: Fnt.fontFamily
        anchors.right: track.left
        anchors.verticalCenter: track.verticalCenter
        anchors.margins:5
    }

    Text{
        text: Spotify.formatTime(Spotify.player?.length)
        color: Theme.text
        font.family: Fnt.fontFamily
        font.pixelSize: Fnt.fontSize5
        anchors.left: track.right
        anchors.verticalCenter: track.verticalCenter
        anchors.margins:5
    }

    Rectangle{
        color: Qt.rgba(0,0,0,0.3)
        height: buttonRow.implicitHeight+10
        width: buttonRow.implicitWidth+30 
        radius: height/2
        anchors.bottom: track.top
        anchors.horizontalCenter: track.horizontalCenter
        anchors.margins:5

        RowLayout{
            id: buttonRow
            anchors.centerIn:parent
            spacing: 16
            Rectangle{
                width: backIcon.implicitSize+4
                height: backIcon.implicitSize+4
                color: "transparent"
                IconImage {
                    id: backIcon
                    anchors.centerIn:parent
                    source: Quickshell.iconPath("media-skip-backward")
                    implicitSize: 16
                    layer.enabled: true
                    layer.effect: ColorOverlay {
                        color: Theme.primary
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Spotify.player?.previous()
                }
            }
            
            Rectangle{
                width: playIcon.implicitSize+4
                height: playIcon.implicitSize+4
                color: "transparent"
                IconImage {
                    id: playIcon
                    anchors.centerIn:parent
                    source:  Quickshell.iconPath(Spotify.player?.isPlaying ? "media-playback-pause":"media-playback-start")
                    implicitSize: 20
                    layer.enabled: true
                    layer.effect: ColorOverlay {
                        color: Theme.primary
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Spotify.player?.togglePlaying()
                }
            }

            Rectangle{
                width: nextIcon.implicitSize+4
                height: nextIcon.implicitSize+4
                color: "transparent"
                IconImage {
                    id: nextIcon
                    anchors.centerIn:parent
                    source: Quickshell.iconPath("media-skip-forward")
                    implicitSize: 16
                    layer.enabled: true
                    layer.effect: ColorOverlay {
                        color: Theme.primary
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Spotify.player?.next()
                }
            }
        }
    }


    ColumnLayout{
        id: textColumn
        anchors.top:parent.top
        anchors.left:parent.left
        anchors.margins: 10
        spacing: 0

        Text{
            text: Spotify.player?.trackTitle ?? ""
            color: Theme.text
            font.pixelSize: Fnt.fontSize2
            font.family: Fnt.fontFamily
            font.bold: true
            style: Text.Outline
            styleColor: Theme.textOutline
        }
        Text{
            text: Spotify.player?.trackArtist ?? ""
            color: Theme.text1
            font.pixelSize: Fnt.fontSize3
            font.family: Fnt.fontFamily
            style: Text.Outline
            styleColor: Theme.text1Outline
        }
    }
}
