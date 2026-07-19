pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string activeWirelessConnection: ""
    property var availableNetworks: []
    property bool isOn: false

    Process {
        id: getActiveConnection
        command: ["sh", "-c", "nmcli -t -f NAME,TYPE connection show --active | grep wireless"]
        running: true

        stdout: StdioCollector {
            onStreamFinished : {
                root.activeWirelessConnection = text.split(":")[0]
            }
        }
    }

    Process {
        id: getConnections
        command: ["sh", "-c","nmcli -t -f SSID,SIGNAL device wifi list -rescan no | sort -t: -k1,1 -k2,2nr | awk -F: '!seen[$1]++'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished : {
                root.availableNetworks = text.split("\n")
                                 .filter(line => line.length > 0)
                                 .map(line => {
                                     const parts = line.split(":")
                                     return {
                                         ssid: parts[0],
                                         strength: Number(parts[1])
                                     }
                             })
            }
        }
    }

    Process{
        id: connectTo
    }

    Process{ id: setOnOff }
    
    onIsOnChanged: {
        if(root.isOn) setOnOff.exec(["nmcli", "radio", "wifi", "on"])
        else setOnOff.exec(["nmcli","radio", "wifi", "off"])
    }

    onActiveWirelessConnectionChanged:{
        if(availableNetworks.includes(activeWirelessConnection))
        connectTo.exec(["nmcli", "connection", "up", activeWirelessConnection])
    }

    Process{
        id: checkIsOn
        command: ["nmcli", "radio", "wifi"]
        running: true
        stdout: StdioCollector {
            onStreamFinished : {
                root.isOn = text.startsWith("e")
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            checkIsOn.running = true
            getActiveConnection.running = true
            getConnections.running = true
        }
    }
}
