pragma Singleton

import Quickshell
import QtQuick

Singleton {
    property int left: Qt.Key_H
    property int right: Qt.Key_L
    property int up: Qt.Key_K
    property int down: Qt.Key_J
    property int child: Qt.Key_Tab
    property int parent: Qt.Key_Escape
    property int select: Qt.Key_Return
    property int selectAlternative: Qt.Key_Space
}
