pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root

    property bool dnd: false
    property bool ccOpen: false
    property var toastIds: []

    readonly property var list: server.trackedNotifications.values
    readonly property var listNewestFirst: list.slice().reverse()
    readonly property var toasts: list.filter(n => toastIds.includes(n.id))
    readonly property int count: list.length

    property bool soundEnabled: true
    readonly property string soundNormal: Quickshell.env("HOME") + "/.config/quickshell/scripts/notify.mp3"
    readonly property string soundCritical: "/usr/share/sounds/freedesktop/stereo/dialog-warning.oga"

    function playSound(n) {
        if (!soundEnabled || dnd) return
        if (n.hints && n.hints["suppress-sound"]) return
        const file = n.urgency === NotificationUrgency.Critical ? soundCritical : soundNormal
        Quickshell.execDetached(["pw-play", file])
    }

    function hideToast(id) {
        toastIds = toastIds.filter(i => i !== id)
    }
    function clearAll() {
        toastIds = []
        for (const n of list.slice()) n.dismiss()
    }

    NotificationServer {
        id: server
        bodySupported: true
        actionsSupported: true
        imageSupported: true
        keepOnReload: true

        onNotification: n => {
            n.tracked = true
            if (!root.dnd && !root.ccOpen)
                root.toastIds = [...root.toastIds, n.id]
            root.playSound(n)
        
        }
    }

    IpcHandler {
        target: "notifs"
        function toggleCc(): void { root.ccOpen = !root.ccOpen }
        function toggleDnd(): void { root.dnd = !root.dnd }
        function clear(): void { root.clearAll() }
    }
}
