import Quickshell
import QtQuick
import qs.components
import Quickshell.Services.Mpris
import qs.config

BarText {
    id: root

    readonly property int maxLen: 60

    readonly property var player: {
        const list = Mpris.players.values
        return list.find(p => p.isPlaying)
            ?? list.find(p => p.trackTitle)
            ?? null
    }

    readonly property bool playing: player?.isPlaying ?? false

    readonly property string info: [player?.trackTitle, player?.trackArtist]
        .filter(s => s)
        .join(" - ")

    visible: info !== "" && playing
    text: (info.length > maxLen ? info.slice(0, maxLen - 1) + "…" : info) + " |"
}
