import QtQuick
import qs.components
import qs.config
import qs.services

BarText {
    text: String.fromCodePoint(Notifs.dnd ? " " : (Notifs.count > 0 ? 0xea71 : 0x0020))
         
    color: Notifs.dnd ? Theme.dim : (Notifs.count > 0 ? Theme.accent : Theme.fg)

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) Notifs.dnd = !Notifs.dnd
            else Notifs.ccOpen = !Notifs.ccOpen
        }
    }
}
