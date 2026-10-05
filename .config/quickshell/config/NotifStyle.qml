pragma Singleton
import Quickshell
import QtQuick

Singleton {
    readonly property color text: "#ffffff"
    readonly property color accent: "#f4dbd6"
    readonly property color panelBg: "#cc000000"
    readonly property color itemBg: "#66f4dbd6"
    readonly property color gridBg: "#e6000000"
    readonly property color playerBg: "#8c000000"
    readonly property color hover: "#333333"
    readonly property color critical: "#e78284"

    readonly property string font: "JetBrains Mono"
    readonly property int sizeBase: 14
    readonly property int sizeSmall: 11
}
