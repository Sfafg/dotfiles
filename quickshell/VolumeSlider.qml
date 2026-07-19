import Quickshell
import QtQuick
import "./components"
import "./services"

Slider{
    property alias sliderFocus: slider.focus
    id: slider
    iconSource: value == 0 || Audio.defaultSink?.audio.muted   ? Quickshell.iconPath("audio-volume-muted") :
                value < 0.2  ? Quickshell.iconPath("audio-volume-low") :
                value < 0.66 ? Quickshell.iconPath("audio-volume-medium"):
                               Quickshell.iconPath("audio-volume-high")
    
    value: Audio.defaultSink?.audio.volume ?? 0
    onMoved: (v) => {
        Audio.defaultSink.audio.volume = v
    }
}
