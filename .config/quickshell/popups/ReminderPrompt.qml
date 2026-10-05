import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.config


Scope {
    id: root

    property bool open: false
    property string error: ""
    readonly property string sound: Quickshell.env("HOME") + "/.config/quickshell/scripts/alarm.mp3"

    function submit(raw) {
        const t = raw.trim()
        if (t === "") { open = false; return }

        const i = t.search(/\s/)
        const minStr = i < 0 ? t : t.slice(0, i)
        const body = i < 0 ? "" : t.slice(i).trim()

        if (!/^\d+(\.\d+)?$/.test(minStr)) {
            error = "Incorrect input"
            return
        }

        const secs = String(parseFloat(minStr) * 60)

        Quickshell.execDetached(["sh", "-c",
            'sleep "$1"; ' +
            'notify-send -u critical -a Reminder "Reminder" "$2"; ' +
            'if command -v pw-play >/dev/null; then pw-play "$3"; ' +
            'elif command -v paplay >/dev/null; then paplay "$3"; ' +
            'elif command -v canberra-gtk-play >/dev/null; then canberra-gtk-play -i alarm-clock-elapsed; fi',
            "sh", secs, body, sound])

        Quickshell.execDetached(["notify-send", "-a", "Reminder", "-t", "3000",
                                 "Reminder set for " + minStr + " min."])
        open = false
    }

    onOpenChanged: if (open) {
        error = ""
        field.text = ""
        field.forceActiveFocus()
    }

    IpcHandler {
        target: "reminder"
        function toggle(): void { root.open = !root.open }
    }

    PanelWindow {
        id: win
        visible: root.open

        implicitWidth: 340
        implicitHeight: 70
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
        WlrLayershell.namespace: "reminder-prompt"

        HyprlandFocusGrab {
            windows: [win]
            active: win.visible
            onCleared: root.open = false
        }

        Rectangle {
            anchors.fill: parent
            color: "#000000"
            border.width: 2
            border.color: "#ffffff"

            FocusScope {
                anchors.fill: parent
                focus: true
                Keys.onEscapePressed: root.open = false

                ColumnLayout {
                    anchors { fill: parent; margins: 14 }
                    spacing: 6

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 32

                        TextInput {
                            id: field
                            anchors.fill: parent
                            verticalAlignment: TextInput.AlignVCenter
                            focus: true
                            color: "#ffffff"
                            font { family: NotifStyle.font; pixelSize: 16 }
                            clip: true
                            onTextChanged: root.error = ""
                            onAccepted: root.submit(text)
                        }

                        // «placeholder»
                        Text {
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            visible: field.text === ""
                            text: "Remind in minutes..."
                            color: "#ffffff"
                            opacity: 0.45
                            font { family: NotifStyle.font; pixelSize: 16 }
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        visible: root.error !== ""
                        text: root.error
                        color: NotifStyle.critical
                        font { family: NotifStyle.font; pixelSize: NotifStyle.sizeSmall }
                    }
                }
            }
        }
    }
}
