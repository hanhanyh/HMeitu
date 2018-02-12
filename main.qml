import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.1
import QtQuick.Window 2.2
import Han.HanNetWork 1.0 //导入自己写的网络模块
ApplicationWindow {
    id:window
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World");
    property real  dp:Screen.pixelDensity.toFixed(2)  //获取dp 精确小数点2位数
    property real allPage:0  //总共有多少页
    property real currentpage: 1//当前列表
    /*********************************************************
    *图片分类id ，每次切换分类时候 只需要切换这个id重新加载即可不用 push stackview
    *当前页，当前总页数全部记录在window上，下拉到底时 处理 onFlickEnded信号（ListView）
    *切换分类 只需要改分类id属性，重置当前页，清空listmodel,重新调用网络模块即可！
    ************************************************************/
    property real typeid:2001
    Material.theme: Material.Light    //主题（背景）
    Material.accent: Material.Dark  //控件高亮部分
    Material.foreground: Material.BlueGrey //控件文字（前景）
    Material.primary: Material.BlueGrey
    //-------------------------顶部导航对话框--------------------------------------
    Dialog {
          id:menuDialog
          title:"请选择图片分类"
          width:parent.width
          height:parent.height
          visible: true
          modal: true
          standardButtons: Dialog.Ok

          ListModel {
              id: menuModel
              ListElement{
                   name:"美女"
              }
              ListElement{
                   name:"帅哥"
              }
          }
          Component {
                   id: fruitDelegate
                      Button {
                          text: name
                          Material.foreground: Material.BlueGrey

                      }
               }

               ListView {
                   anchors.fill: parent
                   model: menuModel
                   delegate: fruitDelegate  //delegate必须是component
               }
    }//导航对话框结束

    //******************一系列自定义JS函数**********************************
    function fun_changeTypeIdReLoad(imagetypeid)
    {
        window.typeid=imagetypeid;
        window.allPage=0;
        window.currentpage=1;
        //清除重新载入
        listmodel.clear();
        hannetwork.getData(window.typeid,window.currentpage);
    }
   //*********网络模块的处理*********(公共模块)*************************
    HanNetwork
    {
        id:hannetwork;
    }
    //信号连接
    Connections{
        target:hannetwork;
        onQmlRecData:
        {
            stackview.pop();
            //JSON对象解析json字符串
            var oJson=JSON.parse(data);
            //json普通结点就直接 .节点名
            var arrData=oJson.showapi_res_body.pagebean.contentlist;
            //记录总页数
            window.allPage=oJson.showapi_res_body.pagebean.allPages;
            console.log("总页数"+window.allPage)
            //数组结点就  .结点名[数组索引]

            //初始化两个变量（title和source 图片标题和 路径）
            var imgTitle;
            var imgsource;
            for(var i=0;i<arrData.length;i++)
            {
               imgTitle=arrData[i].title;
               imgsource=arrData[i].list[0].big;
                listmodel.append({"title":imgTitle,"src":imgsource});
            }

        }
    }
    //******************网络模块处理结束***********************
    header: Pane
    {
        id:headerpanel
       Material.elevation: 6  //立体高度（高低轮廓）
       height:8*dp;
        Label{
            id:windowTitle
            text:qsTr("天天看美图")
            Material.foreground: Material.BlueGrey //控件文字（前景）
            Material.accent: Material.BlueGrey  //控件高亮部分
            anchors.centerIn: parent;
        }

    }//header结束
    StackView{
        id:stackview
        anchors.left:parent.left;
        anchors.right:parent.right;
        anchors.top:parent.top;
        anchors.bottom: parent.bottom;
        anchors.topMargin: 5*dp;
        anchors.leftMargin: 3*dp
        anchors.rightMargin: 3*dp
        initialItem: Page{
            id:mainPage

            anchors.fill: parent  //填充满
            ListModel{
               id:listmodel
            }//listmodel
            ListView{
               anchors.fill:parent;
               anchors.leftMargin: 2*dp;
               anchors.rightMargin:2*dp;
               id:imageList


               Component.onCompleted:
               {
                   stackview.push("qrc:/busyindicator.qml");
                   hannetwork.getData(window.typeid,imageList.currentpage);
               }
                delegate:Component{
                    Item{
                        width: window.width;
                        height:image.height+titlelabel.height //高度为图片高度+标题
                         Column{
                          Label{
                                  id:titlelabel
                                  Material.elevation:6
                                  text:title
                                  Material.foreground: Material.Dark
                                }
                          Image{
                                   id:image
                                   width:stackview.width  //为了适应屏幕
                                   fillMode:Image.PreserveAspectFit//保持各方面适应
                                   source:src
                                   }//img
                               }
                         }//Item
                }//Com
                model:listmodel
                onFlickEnded:
                {
                    //ListModel 继承于Flickable  ，拉到底部会 有这个事件
                    console.log("拉到底部了");
                    if(window.currentIndex>=window.allPage)
                    {
                        console.log("没有内容了！");
                        return;
                    }
                    stackview.push("qrc:/busyindicator.qml");
                    hannetwork.getData(window.typeid,++window.currentpage);
                }
            }//ListView
        }//Page
    }//stackview
    footer:   //底部
      Pane{
        Material.elevation: 2   //设置轮廓高度
       RowLayout{
            anchors.fill: parent
            Layout.margins: 0
            Button{
                Layout.fillWidth: true  //(自动填充)
                Layout.minimumWidth:10*dp
                Layout.minimumHeight: headerpanel.height
                Layout.maximumHeight: headerpanel.height
                Layout.margins: 0
                text: "明星"
                highlighted:true  //高亮
                Material.background: Material.BlueGrey
                onClicked:{
                   fun_changeTypeIdReLoad(2001)
                }
            }
            Button{
                Layout.fillWidth: true
                Layout.minimumWidth: 10*dp
                Layout.minimumHeight: headerpanel.height
                Layout.maximumHeight: headerpanel.height
                Layout.margins: 0
                text:"娱乐"
                onClicked: {
                  fun_changeTypeIdReLoad(3001)
                }
            }
            Button{
                Layout.fillWidth: true
                Layout.minimumWidth: 10*dp
                Layout.minimumHeight: headerpanel.height
                Layout.maximumHeight: headerpanel.height
                Layout.margins: 0
                text:"美女"
                onClicked: {
                   fun_changeTypeIdReLoad(4001)
                }
            }
            Button{
                Layout.fillWidth: true
                Layout.minimumWidth: 10*dp
                Layout.minimumHeight: headerpanel.height
                Layout.maximumHeight: headerpanel.height
                Layout.margins: 0
                text:"时尚"
                onClicked: {
                   fun_changeTypeIdReLoad(5001)
                }
            }
       }
    }
}
