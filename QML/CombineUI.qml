import QtQuick 2.0
import QtQuick.Controls 1.4     //控制
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.2

Window{
    id: combineUI
    height: parameter.combineUI_height
    width:parameter.combineUI_width
    color:  "#cccccc"

    property int step1_count: 0

    Parameter{
        id: parameter
    }

    FileDialog{
        id:fileDialog;
        visible: false;
        title:"选择文件";
        contentItem: Rectangle{
            implicitHeight: 480;
            implicitWidth: 640;
        }

        selectFolder: true

        //nameFilters: ["Model Pic (*.koyo)"];
        //selectedNameFilter: "Image Files(*.jpg *.png *.gif)";
        onAccepted: {
            selected_directory.text = fileDialog.folder;
            console.log("fileDialog.folder = "+fileDialog.folder);
            //从选中目录中读取xml文件
            xml_operation.getXMLFilefromDir(fileDialog.folder);

        }
    }

    Text {
        id: image_choose_text
        x: 36
        y: 20
        width: 179
        height: 25
        text: qsTr("请选择需要合并的XML目录：")
        font.pixelSize: 28
    }

    TextField{
        id: selected_directory
        x: 36
        y: 60
        width: 337
        height: 35

    }

    Button{
        id: select_button
        x: 389
        y: 60
        width: 97
        height: 35

        style: ButtonStyle{
            label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 13
                color: "#ffffff"
                text: qsTr("选择目录")
            }

            background: Rectangle{
                implicitHeight: 25
                implicitWidth: 70
                color: control.hovered ? "#26bcd4" :"#00669e"
                radius: 2
            }
        }

        onClicked: {
            fileDialog.open();
        }

    }

    Button{
        id: combine_button
        x: 166
        y: 117
        width: 190
        height: 35

        style: ButtonStyle{
            label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 13
                color: "#ffffff"
                text: qsTr("开始合并")
            }

            background: Rectangle{
                implicitHeight: 25
                implicitWidth: 70
                color: control.hovered ? "#26bcd4" :"#00669e"
                radius: 2
            }
        }

        onClicked: {
            //对所有xml文件进行合并
            xml_operation.combineXMLFilefromDir(fileDialog.folder,starting.current_step);
        }

        Connections{
            target: xml_operation

            onCombineSucceed:{
                combine_succeed_dialog.visible = true;
            }
        }

    }

    //提示已经合并成功的对话框
    Window {
        id: combine_succeed_dialog
        x: rootui.x + (rootui.width - width)/2
        y: rootui.y + (rootui.height - height)/2
        width: 320
        height: 180
        flags: Qt.FramelessWindowHint
        modality: Qt.WindowModal
        visible: false

        Rectangle{
            color: "#ffffff"
            x:0
            y:0
            width: 320
            height: 180
            //radius: 5

            Image {
                x:140
                y:50
                width: 39
                height: 38
                source: "../IMAGE/finish39x38.png"
            }

            Text {
                id: combine_succeed_dialog_text
                anchors.top: parent.top;
                anchors.topMargin: 110;
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 15
                font.bold: true
                text: qsTr("XML合并成功");
            }

            Timer {
                id: timer
                interval: 2000
                running: combine_succeed_dialog.visible
                onTriggered: {
                    //step1_count = xml_operation.getStep1_result_count();
                    //console.log("step1_count ="+step1_count);
                    combine_succeed_dialog.visible = false;
                    combineUI.visible = false;
                }
            }
        }
    }

}
