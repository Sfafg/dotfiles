import QtQuick
import Quickshell
pragma Singleton

Singleton {
    property string dbPath: Quickshell.dataPath("usage.json")
    property var usage: ({
    })

    function load() {
        let data = Quickshell.readFile(dbPath);
        usage = data ? JSON.parse(data) : {
        };
    }

    function save() {
        Quickshell.writeFile(dbPath, JSON.stringify(usage));
    }

    function record(app) {
        if (!usage[app])
            usage[app] = 0;

        usage[app] += 1;
        save();
    }

    Component.onCompleted: load()
}
