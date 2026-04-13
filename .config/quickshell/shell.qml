import Quickshell
import QtQuick
import Quickshell.Hyprland
import Quickshell.Io 

ShellRoot { 

 FloatingWindow {
     visible: true
     width: 200
     height: 100

     Text {
         anchors.centerIn: parent
         text: "Hello, Quickshell!"
         color: "#0db9d7"
         font.pixelSize: 18
       }

     TapHandler {
       onTapped:
       Qt.quit()
     }

 }

 //GLOBALSHORTCUTS

 //Where is my LockScreen 
 
 GlobalShortcut {
  name: "lockTheScreen"
  description: "Toggles Where Is My LockScreen"
  onPressed: { 
    launchLockScreen.startDetached();
  }
 }

 Process {
   id: launchLockScreen
   running: false
   command: ["quickshell", "-p", Quickshell.env("HOME") + "/.config/quickshell/WIMLockScreen.qml"]
 }

}
