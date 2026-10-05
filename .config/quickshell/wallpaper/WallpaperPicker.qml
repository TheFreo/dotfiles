import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import Qt.labs.folderlistmodel
import QtQuick
import QtQuick.Layouts
import qs.config

Scope {
    id: root

    property bool open: false
    readonly property string dir: Quickshell.env("HOME") + "/Wall"
    readonly property string cacheDir: Quickshell.env("HOME") + "/.cache/wall-thumbs"

    function buildThumbs() {
        if (!thumbs.running) thumbs.running = true
    }
    Component.onCompleted: buildThumbs()

    Process {
        id: thumbs
        command: [
            "bash",
            decodeURIComponent(Qt.resolvedUrl("thumbs.sh").toString().replace("file://", "")),
            root.dir,
            root.cacheDir
        ]
    }

    function apply(path) {
        Quickshell.execDetached([
            "awww", "img", path,
            "--transition-type", "wipe",
            "--transition-duration", "1",
            "--transition-fps", "60"
        ])
        open = false
    }

    onOpenChanged: if (open) {
        buildThumbs()
        grid.currentIndex = 0
        grid.forceActiveFocus()
    }

    IpcHandler {
        target: "wallpaper"
        function toggle(): void { root.open = !root.open }
    }

    PanelWindow {
        id: win
        visible: root.open

        implicitWidth: 968
        implicitHeight: 640
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
        WlrLayershell.namespace: "wallpaper-picker"

        HyprlandFocusGrab {
            windows: [win]
            active: win.visible
            onCleared: root.open = false
        }

        Rectangle {
            anchors.fill: parent
            color: NotifStyle.panelBg
            border.width: 2
            border.color: NotifStyle.accent

            FocusScope {
                anchors.fill: parent
                focus: true
                Keys.onEscapePressed: root.open = false

                ColumnLayout {
                    anchors { fill: parent; margins: 16 }
                    spacing: 10

                    Text {
                        visible: folder.count === 0
                        text: "В " + root.dir + " нет картинок"
                        color: NotifStyle.text
                        opacity: 0.6
                        font { family: NotifStyle.font; pixelSize: NotifStyle.sizeBase }
                    }

                    GridView {
                        id: grid
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        cellWidth: 312
                        cellHeight: 244

                        // стрелки двигают выбор, Enter ставит обои
                        focus: true
                        keyNavigationEnabled: true
                        keyNavigationWraps: false
                        currentIndex: 0
                        Keys.onReturnPressed: if (currentItem) root.apply(currentItem.filePath)
                        Keys.onEnterPressed: if (currentItem) root.apply(currentItem.filePath)

                        model: FolderListModel {
                            id: folder
                            folder: "file://" + root.dir
                            nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp", "*.bmp", "*.gif"]
                            caseSensitive: false
                            showDirs: false
                            sortField: FolderListModel.Name
                        }

                        delegate: Item {
                            id: cell
                            required property string fileName
                            required property string filePath
                            required property url fileUrl
                            required property int index
                            width: grid.cellWidth
                            height: grid.cellHeight

                            Rectangle {
                                anchors { fill: parent; margins: 6 }
                                color: "transparent"
                                border.width: 2
                                border.color: cell.GridView.isCurrentItem ? NotifStyle.accent : "transparent"

                                Image {
                                    id: thumb
                                    property bool fallback: false
                                    x: 2; y: 2
                                    width: 296; height: 197
                                    source: fallback ? cell.fileUrl
                                          : "file://" + root.cacheDir + "/" + encodeURIComponent(cell.fileName + ".png")
                                    sourceSize: fallback ? Qt.size(450, 300) : Qt.size(300, 200)
                                    fillMode: Image.PreserveAspectCrop
                                    asynchronous: true
                                    onStatusChanged: if (status === Image.Error) fallback = true
                                }

                                Text {
                                    anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 4 }
                                    text: cell.fileName
                                    color: NotifStyle.text
                                    elide: Text.ElideMiddle
                                    horizontalAlignment: Text.AlignHCenter
                                    font { family: NotifStyle.font; pixelSize: NotifStyle.sizeSmall }
                                }

                                MouseArea {
                                    id: area
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onPositionChanged: grid.currentIndex = cell.index
                                    onClicked: root.apply(cell.filePath)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
