import Quickshell
import qs.bar
import qs.popups
import qs.lock
import qs.wallpaper

Scope {
    Variants {
      model: Quickshell.screens
        Bar {}
    }
    NotifToasts {}
    ControlCenter {}
    Lock {}
    WallpaperPicker {}
    ReminderPrompt {}
}
