import Quickshell
import QtQuick
import qs.components
import Quickshell.Networking

BarText {
    id: root
    property bool expanded: false

    readonly property var wifiDevice: {
        for (const d of Networking.devices.values)
            if (d.type === DeviceType.Wifi) return d
        return null
    }
    readonly property var active: wifiDevice?.networks.values.find(n => n.connected) ?? null

    text: {
        if (!active) return "wlan: off "
        return expanded ? `${active.name} (${active.signalStrength * 100}%)` : "wlan: on "
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.expanded = !root.expanded
    }
}
