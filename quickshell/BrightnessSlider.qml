import "./components"
import "./config"
import "./services"
import Quickshell

Slider {
    id: slider

    property alias sliderFocus: slider.focus

    iconSource: value < 0.2 ? Quickshell.iconPath("brightness-low") : Quickshell.iconPath("brightness-high")
    value: Display.brightness
    onMoved: (v) => {
        Display.brightness = v;
    }
}
