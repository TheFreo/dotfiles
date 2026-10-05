import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services

Item {
    implicitHeight: 40

    RowLayout {
        anchors { fill: parent; leftMargin: 10; rightMargin: 10 }

        Text {
            Layout.fillWidth: true
            text: "Do not disturb"
            color: NotifStyle.text
            font { family: NotifStyle.font; pixelSize: 17 }
        }

        Rectangle {
            id: sw
            implicitWidth: 50
            implicitHeight: 20
            color: Notifs.dnd ? NotifStyle.accent : NotifStyle.itemBg

            Rectangle {
                width: 20; height: 16
                y: 2
                x: Notifs.dnd ? parent.width - width - 2 : 2
                color: NotifStyle.text
                Behavior on x { NumberAnimation { duration: 120 } }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Notifs.dnd = !Notifs.dnd
            }
        }
    }
}
