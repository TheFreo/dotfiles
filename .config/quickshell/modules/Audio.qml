import Quickshell
import QtQuick
import qs.components
import Quickshell.Services.Pipewire 
import Quickshell.Io

BarText {
  id: root

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property var audio: sink?.audio
  readonly property var vol: audio?.volume * 100 ?? 0
  readonly property var mute: audio?.muted ?? false

  PwObjectTracker { objects: [root.sink] }

  text: mute ? "vol: mute " : `vol: ${Math.round(vol)}% `

  Process {
    id: mixer
    command: ["pavucontrol"]
  }

  MouseArea {
        anchors.fill: parent
        onClicked: mixer.running = true
    }
}
