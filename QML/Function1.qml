import QtQuick 2.2
import QtQuick.Controls 1.4     //控制
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.2


Item {
    id: function1
    width: parameter.ui_width
    height: parameter.ui_height

    property int pic_count: 0
    property string current_original_pic_path: ""  //当前原始图片的路径
    property string current_simulation_pic_path: ""//当前仿真图片的路径
    property int current_pic_index: 0              //当前图片的索引号
    property int pic_sum: 0                        //图片总数
    //property int is_distinguish_or_not: -1     //当前图片是否可以区分，1：可以区分

    property real x0: 0
    property real y0: 0
    property real x1: 0
    property real y1: 0
    property real rect_l: 0
    property real rect_w: 0
    property int boundingbox_count: 0  //框数目的标记
    property int clearRectFlag: 0      //清除矩形框的标记
    property int clearOneRect:  0      //清楚一个矩形框的标记
    property int checkAllFlag:  0      //全选标记


    onVisibleChanged: {
        //读取当前索引
        current_pic_index = operator_user.readIndexFile(starting_ui.user_input_name.text,1);
        //设置xml文件中的图片索引号
        xml_operation.setIndex(current_pic_index);
        //重置boundingbox
        boundingbox_count = 0;
        //清除画板
        clearRectFlag = 1;
        checkAllFlag = 0;
        canvas.requestPaint();
        //获得图片地址
        operator_user.getAllImageSource();
        operator_user.getAllSimulationImageSource();
        //显示图片总数
        pic_count = operator_user.getPic_count_sum();
        //显示图片
        current_original_pic_path = operator_user.getOriginalImageOfIndex(current_pic_index);
        original_image.source = current_original_pic_path;
        current_simulation_pic_path = operator_user.getSimulationImageOfIndex(current_pic_index);
        simulated_image.source = current_simulation_pic_path;
    }

    Window {  //提示当前目录下已无更多图片的提示框
        id: dir_end_window
        x: rootui.x + (rootui.width - width)/2
        y: rootui.y + (rootui.height - height)/2
        width: 300
        height: 200
        flags: Qt.FramelessWindowHint
        modality: Qt.WindowModal
        visible: false

        Rectangle{
            color: "#D4D4D4"
            width: 300
            height: 200

            Text{
                id: end_text
                anchors.top: parent.top
                anchors.topMargin: 30;
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("当前目录下已无更多图片!")
                font.pixelSize: 14
                font.family: "微软雅黑"
                lineHeight: 1.5
            }

            Button {
                id: confirm_btn1
                x: 100
                y: 120
                width: 220 / 2.56
                height: 80 / 2.56
                text: qsTr("确定")

                //style: btnstyle

                onClicked: {
                    //关闭此对话框
                    dir_end_window.visible = false ;
                }
            }
        }
    }

    Window {  //提示当前目录下已无更多图片的提示框
        id: do_nothing_window
        x: rootui.x + (rootui.width - width)/2
        y: rootui.y + (rootui.height - height)/2
        width: 300
        height: 200
        flags: Qt.FramelessWindowHint
        modality: Qt.WindowModal
        visible: false

        Rectangle{
            color: "#D4D4D4"
            width: 300
            height: 200

            Text{
                id: do_nothing_text
                anchors.top: parent.top
                anchors.topMargin: 30;
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("请先对图片进行筛选!")
                font.pixelSize: 14
                font.family: "微软雅黑"
                lineHeight: 1.5
            }

            Button {
                id: confirm_btn2
                x: 100
                y: 120
                width: 220 / 2.56
                height: 80 / 2.56
                text: qsTr("确定")

                //style: btnstyle

                onClicked: {
                    //关闭此对话框
                    do_nothing_window.visible = false ;
                }
            }
        }
    }

    function updataRect_l(x0,x1){
        return  x1-x0;
    }

    function updataRect_w(y0,y1){
        return y1-y0;
    }

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
            operator_user.getOriginal_image_name(fileDialog.folder+"/");
            operator_user.getSimulation_image_name(fileDialog.folder)
            current_original_pic_path = operator_user.getOriginalPicpathOfIndex(0);
            current_simulation_pic_path = operator_user.getSimulationPicpathOfIndex(0);
            original_image.source = current_original_pic_path;
            simulated_image.source = current_simulation_pic_path;

            //获取原始的目录集合
            operator_user.getOriginal_dirs(fileDialog.folder);
            //获取当前目录下的图片数目
            pic_count = operator_user.getPic_count();
            //创建step1结果目录，目录位于data数据层
            operator_user.createResultDir(fileDialog.folder,"result_step1/",1);

            //boundingbox数量重置为零
            boundingbox_count = 0;
            //画板清空
            clearRectFlag = 1;
            canvas.requestPaint();

        }
    }

    Text {
        id: image_choose_text
        x: 36
        y: 75
        width: 179
        height: 25
        text: qsTr("已选的颜色目录：")
        font.pixelSize: 28
        visible: false
    }

    TextField{
        id: selected_directory
        x: 252
        y: 70
        width: 337
        height: 35
        visible: false

    }

    Button{
        id: select_button
        x: 604
        y: 70
        width: 97
        height: 35
        visible: false

        style: ButtonStyle{
            label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 13
                color: "#ffffff"
                text: qsTr("选择颜色")
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
        id: return_button
        x: 822
        y: 477
        width: 97
        height: 47
        text: "home"

        style: ButtonStyle{
            label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
                color: "#ffffff"
                text: qsTr("HOME")
            }

            background: Rectangle{
                implicitHeight: 25
                implicitWidth: 70
                color: control.hovered ? "#26bcd4" :"#00669e"
                radius: 2
            }
        }

        onClicked: {
            //将当前的图片索引号存入索引文件中
            operator_user.writeIndexFile(starting_ui.user_input_name.text,current_pic_index,1);

            rootui.width = parameter.starting_width;
            rootui.height = parameter.starting_height;

            function1_ui.visible = false;
            function2_ui.visible = false;
            function3_ui.visible = false;
            starting_ui.visible = true;


        }

    }

    Text {
        id: original_image_text
        x: 195
        y: 26
        width: 95
        height: 31
        text: qsTr("raw")
        font.italic: true
        font.pixelSize: 32
    }

    Image {
        id: original_image
        x:51
        y:75
        width:  parameter.iamge_width
        height: parameter.image_height
        source: "../IMAGE/forground.jpg"

        MouseArea{
            id: mousearea
//            anchors.rightMargin: -8
//            anchors.bottomMargin: 87
//            anchors.leftMargin: 8
//            anchors.topMargin: -87
            anchors.fill: parent

            //鼠标按下
            onPressed: {
                x0 = mousearea.mouseX;
                y0 = mousearea.mouseY;
            }

            //鼠标松开
            onReleased: {
                x1 = mousearea.mouseX;
                y1 = mousearea.mouseY;

                rect_l = updataRect_l(x0,x1);
                rect_w = updataRect_w(y0,y1);

                canvas.requestPaint();
            }
        }
    }

    Canvas{
        id: canvas
        x:51
        y:75
        width:  parameter.iamge_width
        height: parameter.image_height
        contextType: "2d"

        Component.onCompleted: {
            //loadImage("C:/Users/Administrator/Desktop/jdz/data/orange_yellow/pic_ (2).jpg")
           // context.drawImage("IMAGE/forground.jpg",0,0);
        }

        property int i
        property double temp_x
        property double temp_y
        property double temp_l
        property double temp_w
        onPaint: {
            if(clearRectFlag == 1){
                context.clearRect(0,0,parent.width,parent.height);
                clearRectFlag=0;
            }
            else if(clearOneRect == 1){
                clearOneRect = 0;

                context.clearRect(0,0,parent.width,parent.height);

                context.lineWidth = 2;
                context.strokeStyle = "yellow";

                //console.log("hehe boundingbox_count = "+boundingbox_count);

                for(i = 0; i<boundingbox_count-1; ++i ){
                    temp_x = xml_operation.getStart_XOfIndex(i);
                    temp_y = xml_operation.getStart_YOfIndex(i);
                    temp_l = xml_operation.getLengthOfIndex(i);
                    temp_w = xml_operation.getWidthOfIndex(i);
                    context.beginPath();
                    context.rect(temp_x,temp_y,temp_l,temp_w);
                    context.closePath();
                    context.stroke(); //描边，把线画出来
                }

                boundingbox_count -= 1;

                if(checkAllFlag == 1 && boundingbox_count == 0){
                    checkAllFlag = 0;
                }

            }else{
                //context.clearRect(0,0,parent.width,parent.height);
                if(boundingbox_count<8 && checkAllFlag == 0){
                    //context.drawImage("IMAGE/forground.jpg",0,0);
                    context.lineWidth = 2;
                    context.strokeStyle = "yellow";
                    context.beginPath();
                    context.rect(x0,y0,rect_l,rect_w);
                    context.closePath();
                    context.stroke(); //描边，把线画出来


                    //将这组boundingbox参数存储进operation对象中
                    xml_operation.setStart_XOfIndex(boundingbox_count,x0);
                    xml_operation.setStart_YOfIndex(boundingbox_count,y0);
                    xml_operation.setLengthOfIndex(boundingbox_count,rect_l);
                    xml_operation.setWidthOfIndex(boundingbox_count,rect_w);

                    boundingbox_count += 1;
                    xml_operation.setBoundingBoxCount(boundingbox_count);

                }
            }
            //全选
            if(checkAllFlag == 1){
                x0 = 0;
                y0 = 0;
                rect_l = parameter.iamge_width
                rect_w = parameter.image_height

                context.lineWidth = 2;
                context.strokeStyle = "yellow";
                context.beginPath();
                context.rect(x0+2,y0+2,rect_l-4,rect_w-4);
                context.closePath();
                context.stroke(); //描边，把线画出来

                //将这组boundingbox参数存储进operation对象中
                xml_operation.setStart_XOfIndex(boundingbox_count,x0);
                xml_operation.setStart_YOfIndex(boundingbox_count,y0);
                xml_operation.setLengthOfIndex(boundingbox_count,rect_l);
                xml_operation.setWidthOfIndex(boundingbox_count,rect_w);

                boundingbox_count += 1;
                console.log("boundingbox_count = "+boundingbox_count);
                xml_operation.setBoundingBoxCount(boundingbox_count);
            }
        }
    }

    Button{
        id: clear_one_boundingbix_button
        x: 56
        y: 396
        width: 63
        height: 29
        enabled: boundingbox_count > 0 ? true : false

        style: ButtonStyle{
            label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 13
                color: "#ffffff"
                text: qsTr("Clear")
            }

            background: Rectangle{
                implicitHeight: 25
                implicitWidth: 70
                color: control.hovered ? "#26bcd4" :"#00669e"
                radius: 2
            }
        }

        onClicked: {
            clearOneRect = 1;
            canvas.requestPaint();
        }
    }

    Button{
        id: check_all_button
        x: 151
        y: 396
        width: 79
        height: 29
        enabled: boundingbox_count == 0 ? true : false

        style: ButtonStyle{
            label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 13
                color: "#ffffff"
                text: qsTr("Select All")
            }

            background: Rectangle{
                implicitHeight: 25
                implicitWidth: 70
                color: control.hovered ? "#26bcd4" :"#00669e"
                radius: 2
            }
        }

        onClicked: {
            checkAllFlag = 1;
            canvas.requestPaint();
        }
    }

//    SettingColorRectConfigParams{
//        id: boundingbox0
//        x:50
//        y:217
//        width:  parameter.iamge_width
//        height: parameter.image_height
//        visible: false
//    }

//    Button{
//        id: add_box_button
//        x: 50
//        y: 528
//        width: 63
//        height: 29
//        enabled: boundingbox_count == 0 ? true : false

//        style: ButtonStyle{
//            label: Text {
//                verticalAlignment: Text.AlignVCenter
//                horizontalAlignment: Text.AlignHCenter
//                font.pixelSize: 13
//                color: "#ffffff"
//                text: qsTr("添加")
//            }

//            background: Rectangle{
//                implicitHeight: 25
//                implicitWidth: 70
//                color: control.hovered ? "#26bcd4" :"#00669e"
//                radius: 2
//            }
//        }

//        onClicked: {
//            boundingbox0.visible = true;
//            console.log("hahaha");

//        }
//    }

    Text {
        id: simulated_image_text1
        x: 703
        y: 26
        text: qsTr("raw")
        font.italic: true
        font.pixelSize: 32
    }
    Text {
        id: simulated_image_text2
        x: 757
        y: 26
        text: qsTr("-CVD")
        font.pixelSize: 32
    }

    Image {
        id: simulated_image
        x:540
        y:75
        width:  parameter.iamge_width
        height: parameter.image_height
        source: "../IMAGE/forground.jpg"
    }

    /*单选框框风格组件*/
    Component{

        id: radioStyle;
        RadioButtonStyle{

            indicator: Rectangle{
                implicitHeight: 20;
                implicitWidth: 20;

                radius: 10;
                border.color: control.hovered? "darkblue":"gray"; //鼠标在单选框区域的时候
                border.width: 1;

                Rectangle{
                    anchors.fill: parent;
                    visible: control.checked;
                    color:"#0000a0";
                    radius: 10;
                    anchors.margins: 3;
                }
            }

            label:Text{
                color: control.activeFocus?"blue":"black";
                text:  control.text;
                font.pixelSize: 25
                font.bold: true
            }
        }
    }

    //原始图的互斥分组
    ExclusiveGroup{

        id: original_logic;
    }
    RadioButton {
        id: original_image_no
        x: 291
        y: 425
        height: 20
        width: 60
        text: qsTr("Unrecognizable")
        //checked: true
        exclusiveGroup: original_logic;
        focus: true;
        activeFocusOnPress:  true;
        style:radioStyle;

        onClicked: {

        }
        onCheckedChanged: {

        }
    }
    RadioButton {
        id:original_image_yes
        x: 516
        y: 425
        height: 20
        width: 60
        text: qsTr("Recognizable")
        exclusiveGroup: original_logic;
        focus: true;
        activeFocusOnPress:  true;
        style:radioStyle;

        onClicked: {

        }
        onCheckedChanged: {

        }
    }

    Text{
       x: 51
       y: 468
       width: 98
       height: 25
       text: qsTr("Total：")
       font.bold: true
       font.pixelSize: 21
    }

    Text{
        id: picture_count
        x: 125
        y: 468
        width: 98
        height: 25
        text:pic_count
        font.pixelSize: 21
    }

    Text{
       x: 52
       y: 499
       width: 137
       height: 25
       text: qsTr("Now：")
       font.bold: true
       font.pixelSize: 21
    }

    Text{
        id: current_picture_num
        x: 125
        y: 499
        width: 98
        height: 25
        text: current_pic_index
        font.pixelSize: 21
    }

    Button{
        id: previous_group_button
        x: 360
        y: 626
        width: 97
        height: 35
        visible: false

        style: ButtonStyle{
            label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 13
                color: "#ffffff"
                text: qsTr("上一组")
            }

            background: Rectangle{
                implicitHeight: 25
                implicitWidth: 70
                color: control.hovered ? "#26bcd4" :"#00669e"
                radius: 2
            }
        }

        onClicked: {
            if(current_pic_index>0){
                current_pic_index -=1;
                current_original_pic_path = operator_user.getOriginalPicpathOfIndex(current_pic_index);
                current_simulation_pic_path = operator_user.getSimulationPicpathOfIndex(current_pic_index)
                original_image.source = current_original_pic_path;
                simulated_image.source = current_simulation_pic_path;
            }else{
                dir_end_window.visible = true;
            }
        }
    }

    Button{
        id: next_group_button
        x: 540
        y: 612
        width: 97
        height: 35
        visible: false

        style: ButtonStyle{
            label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 13
                color: "#ffffff"
                text: qsTr("下一组")
            }

            background: Rectangle{
                implicitHeight: 25
                implicitWidth: 70
                color: control.hovered ? "#26bcd4" :"#00669e"
                radius: 2
            }
        }

        onClicked: {
            if(current_pic_index<pic_count-1){
                current_pic_index +=1;
                current_original_pic_path = operator_user.getOriginalPicpathOfIndex(current_pic_index);
                current_simulation_pic_path = operator_user.getSimulationPicpathOfIndex(current_pic_index)
                original_image.source = current_original_pic_path;
                simulated_image.source = current_simulation_pic_path;
            }else{
                dir_end_window.visible = true;
            }

        }

    }

    Button{
        id: save_button
        x: 339
        y: 477
        width: 338
        height: 47
        //enabled: original_image_no.checked==false&&original_image_yes.checked==false? false:true

        style: ButtonStyle{
            label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
                color: "#ffffff"
                text: qsTr("Save Result")

            }

            background: Rectangle{
                implicitHeight: 25
                implicitWidth: 70
                color: control.hovered ? "#26bcd4" :"#00669e"
                radius: 2
            }
        }

        onClicked: {
            if(original_image_no.checked == true){
                if(original_image.source != "qrc:/IMAGE/forground.jpg"){
                    //添加XML节点
                    xml_operation.setBoundingBoxCount(boundingbox_count);
                    xml_operation.add_xmlnode(original_image.source,1,1,1);
                    //console.log("boundingbox_count ="+boundingbox_count);

                    //将两个radiobutton 复位
                    original_image_no.checked = false;
                    original_image_yes.checked = false;

                    //跳到下一组图片
                    if(current_pic_index<pic_count-1){
                        current_pic_index +=1;
                        current_original_pic_path = operator_user.getOriginalImageOfIndex(current_pic_index);
                        original_image.source = current_original_pic_path;
                        current_simulation_pic_path = operator_user.getSimulationImageOfIndex(current_pic_index);
                        simulated_image.source = current_simulation_pic_path;

                        //将当前的图片索引号存入索引文件中
                        operator_user.writeIndexFile(starting_ui.user_input_name.text,current_pic_index,1);
                    }else{
                        dir_end_window.visible = false;
                    }

                    //boundingbox数目清零
                    boundingbox_count = 0;
                    //画板清空
                    clearRectFlag = 1;
                    checkAllFlag = 0;
                    canvas.requestPaint();
                }else{
                    dir_end_window.visible = true;
                }
            }else if(original_image_yes.checked == true){
                if(original_image.source != "qrc:/IMAGE/forground.jpg"){
                    //添加XML节点
                    xml_operation.setBoundingBoxCount(boundingbox_count);
                    xml_operation.add_xmlnode(original_image.source,0,0,0);

                    //如果可以区分的话，复位radiobutton,直接跳到下一组图片
                    //将两个radiobutton 复位
                    original_image_no.checked = false;
                    original_image_yes.checked = false;

                    //跳到下一组图片
                    if(current_pic_index<pic_count-1){
                        current_pic_index +=1;
                        current_original_pic_path = operator_user.getOriginalImageOfIndex(current_pic_index);
                        original_image.source = current_original_pic_path;
                        current_simulation_pic_path = operator_user.getSimulationImageOfIndex(current_pic_index);
                        simulated_image.source = current_simulation_pic_path;

                        //将当前的图片索引号存入索引文件中
                        operator_user.writeIndexFile(starting_ui.user_input_name.text,current_pic_index,1);
                    }else{
                        dir_end_window.visible = true;
                    }

                    //boundingbox数目清零
                    boundingbox_count = 0;
                    //画板清空
                    clearRectFlag = 1;
                    checkAllFlag = 0;
                    canvas.requestPaint();
                }else{
                   dir_end_window.visible = true;
                }
            }else{
                if(original_image.source == "qrc:/IMAGE/forground.jpg"){
                    dir_end_window.visible = true;
                }else{
                    do_nothing_window.visible = true;
                }
            }
        }

    }
}
