import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Singleton {
    property alias usage: adapter.usageList

    FileView {
        id: fileView

        path: Qt.resolvedUrl("../data/app_usage.txt")
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: adapter

            property var usageList: ({
            })
        }

    }

}
