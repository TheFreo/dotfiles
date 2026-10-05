import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services

Rectangle {
    id: root
    color: NotifStyle.gridBg
    implicitHeight: 56

    readonly property var actions: [
        { icon: "",  cmd: "~/.config/swaync/scripts/screen.sh" },
        { icon: "󰸉", cmd: "qs ipc call wallpaper toggle" },
        { icon: String.fromCodePoint(0xf008),  cmd: "~/.config/quickshell/scripts/record.sh" },
        { icon: String.fromCodePoint(0xf0020), cmd: "qs ipc call reminder toggle" }
    ]

    RowLayout {
        anchors { fill: parent; margins: 4 }
        spacing: 0

        Repeater {
            model: root.actions
            delegate: Rectangle {
                id: b
                required property var modelData
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: area.containsMouse ? NotifStyle.hover : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: b.modelData.icon
                    color: NotifStyle.text
                    font { family: NotifStyle.font; pixelSize: 16 }
                }
                MouseArea {
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        Notifs.ccOpen = false
                        Quickshell.execDetached(["sh", "-c", "sleep 0.2; " + b.modelData.cmd])
                    }
                }
            }
        }
    }
}
