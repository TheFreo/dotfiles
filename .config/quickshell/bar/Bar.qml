import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.modules
import Quickshell.Wayland

PanelWindow {
    WlrLayershell.layer: WlrLayer.Bottom
    required property var modelData
    screen: modelData

    anchors { bottom: true; left: true; right: true }
    implicitHeight: Theme.barHeight
    color: Theme.bg

    RowLayout {
        anchors { fill: parent; leftMargin: 20; rightMargin: 10}
        spacing: Theme.spacing

        // Left
        Logo {}
        Mpris {}
        WindowTitle { Layout.maximumWidth: 400 }

        Item { Layout.fillWidth: true }

        // Right
        Audio {}
        Spacer {}
        Battery {}
        Spacer {}
        Network {}
        Spacer {}
        Clock {}
        Notify {}
    }
}
