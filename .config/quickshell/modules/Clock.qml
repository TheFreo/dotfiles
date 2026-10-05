import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.components
import qs.config

BarText {
    id: root

    property bool open: false

    readonly property int year: clock.date.getFullYear()
    readonly property int daysInYear: new Date(year, 1, 29).getDate() === 29 ? 366 : 365
    readonly property int dayOfYear: Math.round(
        (Date.UTC(year, clock.date.getMonth(), clock.date.getDate()) - Date.UTC(year, 0, 1)) / 86400000) + 1
    readonly property real yearProgress: dayOfYear / daysInYear

    function enter() {
        closeTimer.stop();
        if (!open)
            openTimer.restart();

    }

    function leave() {
        openTimer.stop();
        closeTimer.restart();
    }

    text: Qt.formatDateTime(clock.date, "hh:mm")

    SystemClock {
        id: clock
    }

    Timer {
        id: openTimer

        interval: 400
        onTriggered: root.open = true
    }

    Timer {
        id: closeTimer

        interval: 200
        onTriggered: root.open = false
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.enter()
        onExited: root.leave()
    }

    Process {
        id: opener

        command: ["xdg-open", "https://cloud.thefreo.moe/apps/calendar/"]
    }

    PanelWindow {
        id: popup

        readonly property var loc: Qt.locale("ru_RU")

        visible: root.open
        implicitWidth: 230
        implicitHeight: 250
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        anchors {
            bottom: true
            right: true
        }

        margins {
            bottom: 30
            right: 10
        }

        Item {
            anchors.fill: parent

            HoverHandler {
                onHoveredChanged: hovered ? root.enter() : root.leave()
            }

            Rectangle {
                anchors.fill: parent
                anchors.topMargin: 6
                radius: 0
                color: "#000000"
                border.color: "#FFFFFF"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4

                    RowLayout {
                        Layout.fillWidth: true

                        BarText {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter
                            color: Theme.accent
                            text: clock.date.getDate() + " " + popup.loc.standaloneMonthName(clock.date.getMonth()) + " " + clock.date.getFullYear()
                        }

                        BarText {
                            text: ""
                            color: linkMouse.containsMouse ? Theme.accent : Theme.fg

                            MouseArea {
                                id: linkMouse

                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: opener.running = true
                            }

                        }

                    }

                    DayOfWeekRow {
                        Layout.fillWidth: true
                        locale: popup.loc

                        delegate: BarText {
                            required property var model

                            text: model.shortName
                            color: "#FFFFFF"
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                        }

                    }

                    MonthGrid {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        month: clock.date.getMonth()
                        year: clock.date.getFullYear()
                        locale: popup.loc

                        delegate: Rectangle {
                            required property var model

                            radius: 0
                            color: model.today ? Theme.accent : "transparent"

                            BarText {
                                anchors.centerIn: parent
                                text: model.day
                                font.pixelSize: 12
                                color: model.today ? Theme.bg : Theme.fg
                                opacity: model.month === clock.date.getMonth() ? 1 : 0.25
                            }

                        }

                    }

Item {
    Layout.fillWidth: true
    implicitHeight: 26

    Rectangle {
        id: track
        anchors { left: parent.left; right: parent.right; top: parent.top }
        height: 6
        color: "#33ffffff"

        Rectangle {
            width: track.width * root.yearProgress
            height: parent.height
            color: Theme.accent
        }
    }

    BarText {
        anchors { left: parent.left; bottom: parent.bottom }
        text: root.dayOfYear + " / " + root.daysInYear
        font.pixelSize: 11
        color: Theme.fg
        opacity: 0.7
    }

    BarText {
        anchors { right: parent.right; bottom: parent.bottom }
        text: Math.round(root.yearProgress * 100) + "%"
        font.pixelSize: 11
        color: Theme.accent
    }
}

                }

            }

        }

    }

}
