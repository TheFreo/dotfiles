import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.config

Scope {
    id: root

    SystemClock { id: clock; precision: SystemClock.Minutes }

    LockContext {
        id: ctx
        onUnlocked: sessionLock.locked = false
    }

    IpcHandler {
        target: "lock"
        function lock(): void { sessionLock.locked = true }
    }

    property real idleTimeout: 90 //Auto lock

    IdleMonitor {
        timeout: root.idleTimeout
        enabled: root.idleTimeout > 0 && !sessionLock.locked
        respectInhibitors: true
        onIsIdleChanged: if (isIdle) sessionLock.locked = true
    }

    property real suspendTimeout: 200 //Auto sleep

    IdleMonitor {
        timeout: root.suspendTimeout
        enabled: root.suspendTimeout > 0
        respectInhibitors: true
        onIsIdleChanged: {
            if (!isIdle) return
            sessionLock.locked = true
            suspendDelay.restart()
        }
    }

    Timer {
        id: suspendDelay
        interval: 1000
        onTriggered: Quickshell.execDetached(["loginctl", "suspend"])
    }

    WlSessionLock {
        id: sessionLock

        WlSessionLockSurface {
            Rectangle {
                anchors.fill: parent
                color: Theme.bg

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 14

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Qt.formatDateTime(clock.date, "hh:mm")
                        color: Theme.fg
                        font { family: Theme.font; pixelSize: 96; bold: true }
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Qt.formatDateTime(clock.date, "dddd, d MMMM")
                        color: Theme.dim
                        font { family: Theme.font; pixelSize: 20 }
                    }

                    Item { implicitHeight: 24 }

                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        implicitWidth: 320
                        implicitHeight: 48
                        color: Qt.rgba(1, 1, 1, 0.06)
                        border.width: 2
                        border.color: ctx.showFailure ? "#f38ba8" : Theme.accent

                        TextInput {
                            id: pass
                            anchors { fill: parent; margins: 10 }
                            verticalAlignment: TextInput.AlignVCenter
                            horizontalAlignment: TextInput.AlignHCenter
                            focus: true
                            readOnly: ctx.unlockInProgress
                            echoMode: TextInput.Password
                            passwordCharacter: "●"
                            inputMethodHints: Qt.ImhSensitiveData
                            color: Theme.fg
                            font { family: Theme.font; pixelSize: 18 }

                            onTextChanged: ctx.currentText = text
                            onAccepted: ctx.tryUnlock()

                            Connections {
                                target: ctx
                                function onCurrentTextChanged() { pass.text = ctx.currentText }
                            }
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        visible: ctx.showFailure
                        text: "Incorrect Password"
                        color: "#f38ba8"
                        font { family: Theme.font; pixelSize: 14 }
                    }
                }
            }
        }
    }
}
