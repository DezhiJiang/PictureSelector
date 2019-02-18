import QtQuick 2.0
import QtQuick.Controls 1.4     //控制
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.2

Rectangle{
    id: starting
    width: parameter.starting_width
    height:parameter.starting_height
    color: "#cccccc"

    property int current_step: 0  //当前处于那一个步骤

    property alias user_input_name: user_input_name

    //跳转界面的函数
    function changeStep(i){
        switch(i){
        case 1:
            rootui.width = parameter.ui_width;
            rootui.height = parameter.ui_height;

            starting_ui.visible = false;
            function1_ui.visible = true;
            function2_ui.visible = false;
            function3_ui.visible = false;
            break;
        case 2:
            rootui.width = parameter.ui2_width;
            rootui.height = parameter.ui2_height;

            starting_ui.visible = false;
            function1_ui.visible = false;
            function2_ui.visible = true;
            function3_ui.visible = false;
            break;
        case 3:
            rootui.width = parameter.ui2_width;
            rootui.height = parameter.ui2_height;

            starting_ui.visible = false;
            function1_ui.visible = false;
            function2_ui.visible = false;
            function3_ui.visible = true;
            break;
        default:
            break;
        }
    }

    CombineUI{
        id: combine_ui
        visible: false
    }

    Window {  //提示用户输入一个名字的的提示框
        id: name_input_window
        x: rootui.x + (rootui.width - width)/2
        y: rootui.y + (rootui.height - height)/2
        width: 300
        height: 200
        //flags: Qt.FramelessWindowHint
        modality: Qt.WindowModal
        visible: false

        Rectangle{
            color: "#cccccc"
            //color: "#ffffff"
            width: 300
            height: 200

            Text{
                id: starting_setting_tabview_save_success_window_text
                anchors.top: parent.top
                anchors.topMargin: 30;
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("请输入本次筛选者的姓名：")
                font.pixelSize: 14
                font.family: "微软雅黑"
                lineHeight: 1.5
            }

            TextField{
                id:user_input_name
                x: 40
                y: 70
                width: 200
                height: 30

            }

            Button {
                id: confirm_btn
                x: 100
                y: 120
                width: 220 / 2.56
                height: 80 / 2.56
                text: qsTr("确定")

                //style: btnstyle

                onClicked: {
                    //根据输入的名字在D盘根目录下创建一个XML文件
                    //console.log("input text ="+user_input_name.text);
                    xml_operation.create_xml(user_input_name.text,current_step);
                    operator_user.createIndexFile(user_input_name.text,current_step);
//                    operator_user.writeIndexFile(user_input_name.text,4);
//                    index = operator_user.readIndexFile(user_input_name.text);
//                    //重置图片索引号
//                    xml_operation.resetIndex();
                    //关闭此对话框
                    name_input_window.visible = false;
                    //跳转到step1界面
                    changeStep(current_step);

                }
            }
        }
    }

    Parameter{
        id: parameter
    }

    Text {
        id: title_text
        x: 161
        y: 30
        width: 319
        height: 41
        text: qsTr("色盲图片筛选器")
        font.pixelSize: 41
    }


    Text {
        id: function_choose_text
        x: 8
        y: 107
        width: 319
        height: 32
        text: qsTr("请按步骤进行图片筛选及合并")
        font.pixelSize: 25
    }

    Button{
        id: function1_button
        x: 0
        y: 154
        width: 400
        height: 112

        style: ButtonStyle{
            label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 13
                color: "#ffffff"
                text: qsTr("Step1:原始图和仿真图的对比筛选")
            }

            background: Rectangle{
                implicitHeight: 25
                implicitWidth: 70
                color: control.hovered ? "#26bcd4" :"#00669e"
                radius: 2
            }
        }

        onClicked: {
            //设置当前步骤
            current_step = 1;
            //打开请求用户输入名字的对话框
            name_input_window.visible = true;

        }

    }

    Button{
        id: function1_combine_button
        x: 405
        y: 154
        width: 190
        height: 112

        style: ButtonStyle{
            label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 13
                color: "#ffffff"
                text: qsTr("第一步结果合并")
            }

            background: Rectangle{
                implicitHeight: 25
                implicitWidth: 70
                color: control.hovered ? "#26bcd4" :"#00669e"
                radius: 2
            }
        }

        onClicked: {
            //设置当前步骤
            current_step = 1;
//            //打开请求用户输入名字的对话框
//            name_input_window.visible = true;
            combine_ui.visible = true;

        }

    }

    Button{
        id: function2_button
        x: 0
        y: 272
        width: 400
        height: 112

        style: ButtonStyle{
            label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 13
                color: "#ffffff"
                text: qsTr("Step2:原始图和算法填充图的对比筛选")
            }

            background: Rectangle{
                implicitHeight: 25
                implicitWidth: 70
                color: control.hovered ? "#26bcd4" :"#00669e"
                radius: 2
            }
        }

        onClicked: {
            //设置当前步骤
            current_step = 2;
            //打开请求用户输入名字的对话框
            name_input_window.visible = true;

        }

    }

    Button{
        id: function2_combine_button
        x: 405
        y: 272
        width: 190
        height: 112

        style: ButtonStyle{
            label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 13
                color: "#ffffff"
                text: qsTr("第二步结果合并")
            }

            background: Rectangle{
                implicitHeight: 25
                implicitWidth: 70
                color: control.hovered ? "#26bcd4" :"#00669e"
                radius: 2
            }
        }

        onClicked: {
            //设置当前步骤
            current_step = 2;
//            //打开请求用户输入名字的对话框
//            name_input_window.visible = true;
            combine_ui.visible = true;

        }

    }

    Button{
        id: function3_button
        x: 0
        y: 390
        width: 400
        height: 112

        style: ButtonStyle{
            label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 13
                color: "#ffffff"
                text: qsTr("Step3:原始图和算法仿真图的对比筛选")
            }

            background: Rectangle{
                implicitHeight: 25
                implicitWidth: 70
                color: control.hovered ? "#26bcd4" :"#00669e"
                radius: 2
            }
        }

        onClicked: {
            //设置当前步骤
            current_step = 3;
            //打开请求用户输入名字的对话框
            name_input_window.visible = true;

        }

    }

    Button{
        id: function3_combine_button
        x: 405
        y: 390
        width: 190
        height: 112

        style: ButtonStyle{
            label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 13
                color: "#ffffff"
                text: qsTr("第三步结果合并")
            }

            background: Rectangle{
                implicitHeight: 25
                implicitWidth: 70
                color: control.hovered ? "#26bcd4" :"#00669e"
                radius: 2
            }
        }

        onClicked: {
            //设置当前步骤
            current_step = 3;
//            //打开请求用户输入名字的对话框
//            name_input_window.visible = true;
            combine_ui.visible = true;

        }

    }



}
