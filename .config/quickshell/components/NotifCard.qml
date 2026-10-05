import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import qs.config

Rectangle {
    id: card
    required property var notif
    property bool isToast: false
    property int pad: 16
    property bool interceptClose: false
    signal closeRequested()

    implicitHeight: col.implicitHeight + pad * 2
    color: isToast ? NotifStyle.panelBg : NotifStyle.itemBg
    border.width: isToast ? 2 : 0
    border.color: notif.urgency === NotificationUrgency.Critical ? NotifStyle.critical : NotifStyle.accent

    readonly property string iconSource: {
        if (notif.image !== "") return notif.image
        if (notif.appIcon !== "") return Quickshell.iconPath(notif.appIcon, true)
        return ""
    }

    ColumnLayout {
        id: col
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: card.pad }
        spacing: 6

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Image {
                visible: card.iconSource !== ""
                source: card.iconSource
                sourceSize: Qt.size(48, 48)
                fillMode: Image.PreserveAspectFit
                Layout.preferredWidth: 48
                Layout.preferredHeight: 48
                Layout.alignment: Qt.AlignVCenter
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    Layout.fillWidth: true
                    text: card.notif.summary
                    color: NotifStyle.text
                    font { family: NotifStyle.font; pixelSize: NotifStyle.sizeBase; bold: true }
                    elide: Text.ElideRight
                }
                Text {
                    Layout.fillWidth: true
                    visible: text !== ""
                    text: card.notif.body
                    color: NotifStyle.text
                    font { family: NotifStyle.font; pixelSize: NotifStyle.sizeSmall }
                    textFormat: Text.PlainText
                    wrapMode: Text.Wrap
                    maximumLineCount: 5
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.alignment: Qt.AlignTop
                implicitWidth: 24
                implicitHeight: 24
                color: closeArea.containsMouse ? NotifStyle.accent : "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    color: NotifStyle.text
                    font { family: NotifStyle.font; pixelSize: 12 }
                }
                MouseArea {
                    id: closeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: card.interceptClose ? card.closeRequested() : card.notif.dismiss()
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            visible: card.notif.actions.length > 0
            spacing: 6

            Repeater {
                model: card.notif.actions
                delegate: Rectangle {
                    id: btn
                    required property var modelData
                    Layout.fillWidth: true
                    implicitHeight: 32
                    color: btnArea.containsMouse ? NotifStyle.accent : "#ccf4dbd6"

                    Text {
                        anchors.centerIn: parent
                        text: btn.modelData.text
                        color: NotifStyle.text
                        font { family: NotifStyle.font; pixelSize: NotifStyle.sizeSmall }
                    }
                    MouseArea {
                        id: btnArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: btn.modelData.invoke()
                    }
                }
            }
        }
    }
}
