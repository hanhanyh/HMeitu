import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.1


ApplicationWindow {
    id:window
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World");
    Material.theme: Material.Dark
          Material.accent: Material.Purple
    Pane {
        width: 120
        height: 120
        anchors.centerIn: parent
        Material.elevation: 6

        Button {
              text: qsTr("Button")
              highlighted: true
              Material.accent: Material.Orange
              anchors.centerIn: parent
          }

    }
}
