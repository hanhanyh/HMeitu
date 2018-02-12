import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.1


Page{
    anchors.centerIn: parent
     Material.elevation: 6
     BusyIndicator{
      anchors.centerIn: parent;
      Material.theme: Material.Light    //主题（背景）
      Material.accent: Material.Dark  //控件高亮部分
      Material.foreground: Material.BlueGrey //控件文字（前景）
      Material.primary: Material.BlueGrey
       running: true;
     }
}
