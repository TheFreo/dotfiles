import Quickshell
import Quickshell.Services.Pam
import QtQuick

Scope {
    id: root
    signal unlocked()

    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false

    onCurrentTextChanged: showFailure = false

    function tryUnlock() {
        if (currentText === "" || unlockInProgress) return
        unlockInProgress = true
        pam.start()
    }

    PamContext {
        id: pam
        configDirectory: "pam"
        config: "password.conf"

        onPamMessage: {
            console.log("pam message:", this.message, "| response required:", this.responseRequired)
            if (this.responseRequired) this.respond(root.currentText)
        }

        onError: err => console.log("pam error:", err)

        onCompleted: result => {
            console.log("pam completed:", result)
            if (result == PamResult.Success) {
                root.unlocked()
            } else {
                root.currentText = ""
                root.showFailure = true
            }
            root.unlockInProgress = false
        }
    }
}
