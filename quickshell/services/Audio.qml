pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton{
    id: root
    property var defaultSink: tracker.objects[0]
    property var sources: []
    property var sinks: []

    PwObjectTracker {
        id: tracker
        objects: [Pipewire.defaultAudioSink]
    }


    Connections {
        target: Pipewire

        function onDefaultAudioSinkChanged() {
            tracker.objects = [Pipewire.defaultAudioSink]
            defaultSink = tracker.objects[0]
        }
    }
}

