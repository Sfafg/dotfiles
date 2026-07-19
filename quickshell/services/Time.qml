pragma Singleton

import Quickshell
import QtQuick

Singleton{
    readonly property string time: {
        Qt.locale("pl_PL").toString(clock.date, "hh:mm")
    }

    readonly property string date: {
        Qt.locale("pl_PL").toString(clock.date, "d MMM")
    }
    
    readonly property real seconds: {
        clock.seconds
    }

    readonly property real minutes: {
        clock.minutes
    }

    SystemClock{
        id: clock
        precision: SystemClock.Seconds
    }

}
