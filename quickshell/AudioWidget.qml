import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import "./components"
import "./config"
import "./services"
import "./utils"

ColumnLayout{
    property alias widgetFocus: widget.focus
    property alias moreActive: view.visible
    property alias onMore: widget.onMore
    property alias more: view
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
                case Navigation.down:if(!view.visible)return;view.focus=true; break
                case Navigation.child: view.visible=!view.visible; break
                default: return
            }
            event.accepted = true
        }
    }

    ItemList{
        id: view
        visible: false
        model: Pipewire.nodes.values
            .filter(n => n.audio && n.description.length > 0)
            .sort((a, b) => {
                // Sinks first
                if (a.isSink !== b.isSink)
                    return a.isSink ? -1 : 1

                // Default sink first
                if (a.isSink && b.isSink) {
                    const aDefault = Pipewire.defaultAudioSink === a
                    const bDefault = Pipewire.defaultAudioSink === b

                    if (aDefault !== bDefault)
                        return aDefault ? -1 : 1
                }

                return 0
            })
        maxShownItemCount: 6
        itemHeight: 40

        Keys.onPressed: (event) => {
            switch (event.key) {
                case Navigation.up:if(!outOfBounds)return; widget.focus=true; break
                case Navigation.parent: widget.focus=true; break
                default: return
            }
            event.accepted = true
        }

        delegate:
        ListItem{
            RowLayout{
                anchors.verticalCenter:parent.verticalCenter
                spacing: 5
                Item{} 
                IconImage {
                    source: Quickshell.iconPath(modelData.isSink ? "audio-headphones" : "audio-input-microphone")
                    implicitSize: 30
                }
                Text{
                    font.family: Fnt.fontFamily
                    font.pixelSize: Fnt.fontSize2
                    text: Utils.limitStr(modelData.description, 24)
                    color: modelData.isSink ?
                            Pipewire.defaultAudioSink == modelData ? Theme.text : Theme.text1:
                            Pipewire.defaultAudioSource == modelData ? Theme.text : Theme.text1
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: modelData.isSink ?
                            Pipewire.preferredDefaultAudioSink = modelData:
                            Pipewire.preferredDefaultAudioSource = modelData
            }
            Keys.onPressed: (event) => {
                switch (event.key) {
                case Navigation.select: modelData.isSink ? 
                                Pipewire.preferredDefaultAudioSink = modelData:
                                Pipewire.preferredDefaultAudioSource = modelData
                    break
                default: return
                }
                event.accepted = true
            }
        }
    }
}
