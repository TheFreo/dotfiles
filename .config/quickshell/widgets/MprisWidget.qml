import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs.config

Rectangle {
    id: root

    readonly property var player: {
        const l = Mpris.players.values.filter(p => p.identity !== "playerctld")
        return l.find(p => p.isPlaying) ?? l.find(p => p.trackTitle) ?? null
    }

    visible: player !== null
    color: NotifStyle.playerBg
    implicitHeight: visible ? col.implicitHeight + 24 : 0

    ColumnLayout {
        id: col
        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; margins: 12 }
        spacing: 4

        Text {
            Layout.fillWidth: true
            text: root.player?.trackTitle || "—"
            color: NotifStyle.text
            elide: Text.ElideRight
            font { family: NotifStyle.font; pixelSize: 16; weight: Font.DemiBold }
        }
        Text {
            Layout.fillWidth: true
            text: root.player?.trackArtist ?? ""
            visible: text !== ""
            color: NotifStyle.text
            elide: Text.ElideRight
            font { family: NotifStyle.font; pixelSize: 13 }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 24

            Repeater {
                model: [
                    { icon: 0xf048, act: "prev" },
                    { icon: root.player?.isPlaying ? 0xf04c : 0xf04b, act: "toggle" },
                    { icon: 0xf051, act: "next" }
                ]
                delegate: Text {
                    id: t
                    required property var modelData
                    text: String.fromCodePoint(modelData.icon)
                    color: ma.containsMouse ? NotifStyle.accent : NotifStyle.text
                    font { family: NotifStyle.font; pixelSize: 20 }
                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if (!root.player) return
                            if (t.modelData.act === "prev") root.player.previous()
                            else if (t.modelData.act === "next") root.player.next()
                            else root.player.togglePlaying()
                        }
                    }
                }
            }
        }
    }
}
