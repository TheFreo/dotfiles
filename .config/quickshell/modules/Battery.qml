import Quickshell
import QtQuick
import qs.components
import Quickshell.Services.UPower 

BarText {
  id: root
  
  property bool lowBatteryNotified: false
  readonly property var bat: UPower.displayDevice
  readonly property real pcr: bat.percentage * 100
  readonly property bool charging: bat.state === UPowerDeviceState.Charging
                                  || bat.state === UPowerDeviceState.FullyCharged

  text: {
    charging ? `ac: ${Math.round(pcr)}% ` : `bat: ${Math.round(pcr)}% `
  }

  color: charging ? "#FFFFFF" : pcr < 20 ? "#FF6666" : "#FFFFFF"

  onPcrChanged: {
    if (!charging && pcr < 20 && !lowBatteryNotified) {
        Quickshell.execDetached([
            "notify-send",
            "Low Battery",
            `Remained ${Math.round(pcr)}%`
        ])
        lowBatteryNotified = true
    }

    if (pcr >= 20 || charging) {
        lowBatteryNotified = false
    }
}
}
