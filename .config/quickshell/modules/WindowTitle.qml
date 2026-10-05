import Quickshell
import QtQuick
import qs.components
import Quickshell.Hyprland

BarText {
  text: Hyprland.activeToplevel?.title || "ᗜˬᗜ"
  elide: Text.ElideRight
  maximumLineCount: 1
}

