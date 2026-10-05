import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.components
import qs.widgets
import qs.services

PanelWindow {
    id: cc
    visible: Notifs.ccOpen

    anchors { right: true; bottom: true }
    implicitWidth: 470
    implicitHeight: 830
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.namespace: "notif-cc"

    HyprlandFocusGrab {
        windows: [cc]
        active: cc.visible
        onCleared: Notifs.ccOpen = false
    }

    Rectangle {
        anchors { fill: parent; margins: 18; bottomMargin: 46}
        color: NotifStyle.panelBg
        border.width: 2
        border.color: NotifStyle.accent

        FocusScope {
            anchors.fill: parent
            focus: true
            Keys.onEscapePressed: Notifs.ccOpen = false

            ColumnLayout {
                anchors { fill: parent; margins: 22 }
                spacing: 8

                ButtonsGrid { Layout.fillWidth: true }
                MprisWidget { Layout.fillWidth: true }
                DndWidget { Layout.fillWidth: true }

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        Layout.fillWidth: true
                          color: NotifStyle.text
                        font { family: NotifStyle.font; pixelSize: 16; bold: true }
                    }
                    Text {
                        visible: Notifs.count > 0
                        text: "Clear all"
                        color: clearArea.containsMouse ? NotifStyle.accent : NotifStyle.text
                        font { family: NotifStyle.font; pixelSize: NotifStyle.sizeSmall }
                        MouseArea {
                            id: clearArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: Notifs.clearAll()
                        }
                    }
                }

                Text {
                    visible: Notifs.count === 0
                    Layout.alignment: Qt.AlignHCenter
                    text: "No Notifications"
                    color: NotifStyle.text
                    opacity: 0.6
                    font { family: NotifStyle.font; pixelSize: NotifStyle.sizeBase }
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 4
                    model: Notifs.listNewestFirst

                    delegate: NotifCard {
                        required property var modelData
                        notif: modelData
                        width: ListView.view.width
                    }
                }
            }
        }
    }
}
