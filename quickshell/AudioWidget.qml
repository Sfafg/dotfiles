import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "./components"
import "./config"
import "./services"
import "./utils"

ColumnLayout{
    property alias widgetFocus: widget.focus
    Widget{
        id:widget
        iconSource: Quickshell.iconPath("audio-headphones")
        isActive: !Audio.defaultSink?.audio.muted ?? false
        mainText: "Audio"
        secondaryText: Utils.limitStr(Pipewire.defaultAudioSink?.description ?? "", 16) 
        onMore: function(){view.visible=!view.visible}
        onClick:function(){
            isActive = !isActive
            Audio.defaultSink.audio.muted = !isActive
        }

        Keys.onPressed: (event) => {
            switch (event.key) {
                case Navigation.down:if(!view.visible)return;sinksTitle.focus=true; break
                case Navigation.child: view.visible=!view.visible; sinksTitle.focus=view.visible; break
                default: return
            }
            event.accepted = true
        }
    }

    ColumnLayout{
        id: view
        visible: false
        Rectangle{
            id: sinksTitle
            height: 25
            Layout.fillWidth: true
            topLeftRadius: 10
            topRightRadius: 10
            radius: 3
            color: Theme.primary2

            border.width: activeFocus ? Theme.selectedBorderWidth : 1
            border.color: activeFocus ? Theme.selectedBorder : Theme.primary1
            Keys.onPressed: (event) => {
                switch (event.key) {
                    case Navigation.up: widget.focus=true; break
                    case Navigation.down: sourcesTitle.focus=true; break
                    case Navigation.child: sinksList.focus=true; break
                    case Navigation.parent:view.visible=false; widget.focus=true; break
                    default: return
                }
                event.accepted = true
            }

            Text{
                anchors.centerIn: parent
                font.family: Fnt.fontFamily
                font.pixelSize: Fnt.fontSize2
                text: "Sinks"
                color: Theme.text
            }
        }

        ItemList{
            id: sinksList
            model: Pipewire.nodes.values.filter(n=>n.isSink && n.audio && n.description.length > 0)
            maxShownItemCount: 2
            itemHeight: 30

            Keys.onPressed: (event) => {
                switch (event.key) {
                    case Navigation.up:if(!outOfBounds)return; sinksTitle.focus=true; break
                    case Navigation.parent: sinksTitle.focus=true; break
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
                    Text{
                        font.family: Fnt.fontFamily
                        font.pixelSize: Fnt.fontSize2
                        text: Utils.limitStr(modelData.description, 26)
                        color: Pipewire.defaultAudioSink == modelData ? Theme.text : Theme.text1
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Pipewire.preferredDefaultAudioSink = modelData
                }
                Keys.onPressed: (event) => {
                    switch (event.key) {
                    case Navigation.select:
                        Pipewire.preferredDefaultAudioSink = modelData
                        break
                    default: return
                    }
                    event.accepted = true
                }
            }
        }

        Item{}
        Rectangle{
            id: sourcesTitle
            height: 25
            Layout.fillWidth: true
            topLeftRadius: 10
            topRightRadius: 10
            radius: 3
            color: Theme.primary2

            border.width: activeFocus ? Theme.selectedBorderWidth : 1
            border.color: activeFocus ? Theme.selectedBorder : Theme.primary1
            Keys.onPressed: (event) => {
                switch (event.key) {
                    case Navigation.up: sinksTitle.focus=true; break
                    case Navigation.child: sourcesList.focus=true; break
                    case Navigation.parent:view.visible=false; widget.focus=true; break
                    default: return
                }
                event.accepted = true
            }

            Text{
                font.family: Fnt.fontFamily
                font.pixelSize: Fnt.fontSize2
                anchors.centerIn: parent
                text: "Sources"
                color: Theme.text
            }
        }

        ItemList{
            id: sourcesList
            visible: true
            model: Pipewire.nodes.values.filter(n=>!n.isSink && n.audio)
            maxShownItemCount: 2
            itemHeight: 30

            Keys.onPressed: (event) => {
                switch (event.key) {
                    case Navigation.up:if(!outOfBounds)return; sourcesTitle.focus=true; break
                    case Navigation.parent: sourcesTitle.focus=true; break
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
                    Text{
                        font.family: Fnt.fontFamily
                        font.pixelSize: Fnt.fontSize2
                        text: Utils.limitStr(modelData.description, 25)
                        color: Pipewire.defaultAudioSource == modelData ? Theme.text : Theme.text1
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Pipewire.preferredDefaultAudioSource = modelData
                }
                Keys.onPressed: (event) => {
                    switch (event.key) {
                    case Navigation.select:
                        Pipewire.preferredDefaultAudioSource = modelData
                        break
                    default: return
                    }
                    event.accepted = true
                }
            }
        }
    }
}
