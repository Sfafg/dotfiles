import "../services"
import QtQuick
import Quickshell
pragma Singleton

Singleton {
    property color selectedBorder: Qt.rgba(1, 1, 1, 1)
    property int selectedBorderWidth: 2
    property color background: Qt.hsva(0, 0, 0, 0.7)
    property color primary: Qt.hsva(0, 0, 0.8, 1)
    property color primary1: Qt.hsva(0, 0, 0.5, 1)
    property color primary2: Qt.hsva(0, 0, 0.3, 1)
    property color primary3: Qt.hsva(0, 0, 0.1, 1)
    property color primary4: Qt.hsva(0, 0, 0.08, 1)
    property color accent: {
        if (ThemePicker.theme == "morning")
            return Qt.hsva(0.497, 0.64, 0.99, 1);

        if (ThemePicker.theme == "noon")
            return Qt.hsva(0.597, 0.4, 0.99, 1);

        if (ThemePicker.theme == "evening")
            return Qt.hsva(0.06, 0.6, 0.9, 1);

        if (ThemePicker.theme == "night")
            return Qt.hsva(0.63, 0.5, 0.7, 1);

    }
    property color accent1: Qt.hsva(accent.hsvHue, accent.hsvSaturation - 0.04, accent.hsvValue - 0.18, 1)
    property color accent2: Qt.hsva(accent.hsvHue, accent.hsvSaturation - 0.33, accent.hsvValue - 0.52, 1)
    property color text: Qt.hsva(0, 0, 1, 1)
    property color text1: Qt.hsva(0, 0, 0.7, 1)
    property color textInverted: Qt.hsva(0, 0, 0, 1)
    property color textSecondary: Qt.hsva(0, 0, 0.4, 1)
    property color textSecondaryInverted: Qt.hsva(0, 0, 0.2, 1)
    property color textOutline: Qt.hsva(0, 0, 0, 0)
    property color text1Outline: Qt.hsva(0, 0, 0.2, 1)
}
