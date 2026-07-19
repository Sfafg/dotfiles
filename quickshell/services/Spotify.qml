pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Services.Mpris

Singleton{
    readonly property var player: Mpris.players.values.find(
        p=>p.identity == "Spotify"
    )

    function formatTime(s) {
        var totalSeconds = Math.floor(s ? s : 0)
        var minutes = Math.floor(totalSeconds / 60)
        var seconds = totalSeconds % 60

        return minutes + ":" + (seconds < 10 ? "0" : "") + seconds
    }
}
