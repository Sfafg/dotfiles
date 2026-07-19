import Quickshell
import "./components"
import "./config"
import "./services"

Slider{
    property alias sliderFocus: slider.focus
    id: slider
    iconSource: value < 0.2 ? Quickshell.iconPath("brightness-low") :
                              Quickshell.iconPath("brightness-high")
    value: Display.brightness
    onMoved: (v) => {
        Display.brightness = v
    }
}
