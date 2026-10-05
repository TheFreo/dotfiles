import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import qs.components
import qs.services

PanelWindow {
    id: win
    visible: Notifs.toasts.length > 0

    anchors { top: true; right: true; bottom: true }
    implicitWidth: 400

    mask: Region { item: col }
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "notif-toasts"

    ColumnLayout {
        id: col
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 18; bottomMargin: 36 }
        spacing: 0

        Repeater {
            model: ScriptModel { values: Notifs.toasts }

            delegate: Item {
                id: slot
                required property var modelData

                property bool shown: false
                property bool collapsed: false
                property bool entered: false
                property bool dismissAfter: false
                property bool finished: false

                Layout.fillWidth: true
                property real shrink: (!entered || collapsed) ? 1 : 0
                implicitHeight: (card.implicitHeight + 10) * (1 - shrink)

                function leave(dismiss) {
                    dismissAfter = dismiss
                    shown = false
                }
                function finish() {
                    if (finished) return
                    finished = true
                    if (dismissAfter) modelData.dismiss()
                    else Notifs.hideToast(modelData.id)
                }

                Behavior on shrink {
                    NumberAnimation {
                        duration: 150
                        onRunningChanged: if (!running && slot.collapsed) slot.finish()
                    }
                }

                Timer {
                    running: true
                    interval: 40
                    onTriggered: {
                        slot.entered = true
                        slot.shown = true
                    }
                }

                HoverHandler { id: hover }

                Timer {
                    running: slot.shown && !hover.hovered
                    interval: (slot.modelData.urgency === NotificationUrgency.Low ? 2
                             : slot.modelData.urgency === NotificationUrgency.Critical ? 6 : 4) * 1000
                    onTriggered: slot.leave(false)
                }

                NotifCard {
                    id: card
                    notif: slot.modelData
                    isToast: true
                    interceptClose: true
                    onCloseRequested: slot.leave(true)

                    width: slot.width
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    x: slot.shown ? 0 : 480

                    Behavior on x {
                        NumberAnimation {
                            duration: 250
                            easing.type: slot.shown ? Easing.OutCubic : Easing.InCubic
                            onRunningChanged: if (!running && !slot.shown) slot.collapsed = true
                        }
                    }
                }
            }
        }
    }
}
