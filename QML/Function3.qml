import QtQuick 2.0
import QtQuick.Controls 1.4     //控制
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.2

Item {
    id: function3
    width: parameter.ui2_width
    height: parameter.ui2_height

    property int pic_count: 0
    property string folder: ""   //原始图片所在的目录
    property string current_original_pic_path: ""  //当前原始图片的路径
    property string current_algorithm2_sim_pic_path: ""//当前算法二仿真图片的路径
    property string current_algorithm3_sim_pic_path: ""//当前算法三仿真图片的路径
    property int current_pic_index: 0              //当前图片的索引号
    property int algorithm2_pic_is_exist: 0        //当前的原始图存在对应的算法2的图片,1:存在，0：不存在
    property int algorithm3_pic_is_exist: 0        //当前的原始图存在对应的算法3的图片

    Parameter{
        id:parameter
    }

    //界面初始化
    onVisibleChanged: {
        if(function3.visible == true){
            //将四个radiobutton使能并置位
            enabledButton();
            defaultFourRadioButton();
            //将四个按钮隐藏
            closeRadioButton();
            //读取当前的索引号
            current_pic_index = operator_user.readIndexFile(starting_ui.user_input_name.text,3);
            console.log("step3 current_pic_index="+current_pic_index);
            //设置xml文件中的索引号
            xml_operation.setIndex(current_pic_index);
            //显示图片总数
            pic_count = xml_operation.getNodeCountsOfXML("file:///D:/色盲数据整理文件/combine_xml_result/step2_select_result_combine.xml");
            //显示图片
            //获得图片地址
            current_original_pic_path = xml_operation.getOriginOfIndexFromXML_step3("file:///D:/色盲数据整理文件/combine_xml_result/step2_select_result_combine.xml",current_pic_index)
            original_image.source = current_original_pic_path;
            //获取原始图片所在的目录
            folder = operator_user.getPic_Folder(original_image.source)
            //获取原始的目录集合
            operator_user.getOriginal_dirs(folder);
            current_algorithm2_sim_pic_path = operator_user.isExist_Algorithm2SimPic(original_image.source);
            if(current_algorithm2_sim_pic_path!= "inexistence"){
                algorithm2_simulated_image.source = "file:///"+current_algorithm2_sim_pic_path;
                algorithm2_pic_is_exist = 1;
                //显示算法2的按钮
                openRadioButton2();
            }else{
                algorithm2_simulated_image.source = "../IMAGE/forground.jpg";
                algorithm2_pic_is_exist = 0;
            }
            //判断是否有对应的算法三填充图，有的话就显示，没有的话用默认图片
            current_algorithm3_sim_pic_path = operator_user.isExist_Algorithm3SimPic(original_image.source);
            if(current_algorithm3_sim_pic_path!="inexistence"){
                algorithm3_simulated_image.source = "file:///"+current_algorithm3_sim_pic_path;
                algorithm3_pic_is_exist = 1;
                //显示算法3的按钮
                openRadioButton3();
            }else{
                algorithm3_simulated_image.source = "../IMAGE/forground.jpg";
                algorithm3_pic_is_exist = 0;
            }
        }
    }

    Window {  //提示对当前图片进行筛选
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

    Window {  //提示xml文件已经读取完毕的的提示框
        id: xmlfile_end_window
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
                text: qsTr("当前已是最后一组图片!")
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
                    xmlfile_end_window.visible = false ;
                }
            }
        }
    }

    function disenabledButton(){
        //筛选到最后一张图片将相关按钮使能关闭
        algorithm2_image_no.enabled = false;
        algorithm2_image_yes.enabled = false;
        algorithm3_image_no.enabled = false;
        algorithm3_image_yes.enabled = false;
        //save_button.enabled = false;
    }

    function enabledButton(){
        //打开四个按钮的使能
        algorithm2_image_no.enabled = true;
        algorithm2_image_yes.enabled = true;
        algorithm3_image_no.enabled = true;
        algorithm3_image_yes.enabled = true;
    }

    function defaultFourRadioButton(){
        //将四个radiobutton复位
        algorithm2_image_no.checked = false;
        algorithm2_image_yes.checked = false;
        algorithm3_image_no.checked = false;
        algorithm3_image_yes.checked = false;
    }

    function openRadioButton2(){
        //将算法2的按钮显示
        algorithm2_image_no.visible = true;
        algorithm2_image_yes.visible = true;
    }

    function openRadioButton3(){
        //将算法3的筛选按钮显示
        algorithm3_image_no.visible = true;
        algorithm3_image_yes.visible = true;
    }

    function closeRadioButton(){
        //将算法2、3的筛选按钮隐藏
        algorithm2_image_no.visible = false;
        algorithm2_image_yes.visible = false;
        algorithm3_image_no.visible = false;
        algorithm3_image_yes.visible = false;
    }

    function getNextGroupPic(){
        //将四个按钮隐藏
        closeRadioButton();
        //获取xml中的下一个节点并显示图片
        current_pic_index +=1;
        //获得图片地址
        current_original_pic_path = xml_operation.getOriginOfIndexFromXML_step3("file:///D:/色盲数据整理文件/combine_xml_result/step2_select_result_combine.xml",current_pic_index);
        if(current_original_pic_path != "step3_xml_is_end"){
            original_image.source = current_original_pic_path;
            //获取原始图片所在的目录
            folder = operator_user.getPic_Folder(original_image.source)
            //获取原始的目录集合
            operator_user.getOriginal_dirs(folder);
            current_algorithm2_sim_pic_path = operator_user.isExist_Algorithm2SimPic(original_image.source);
            if(current_algorithm2_sim_pic_path!= "inexistence"){
                algorithm2_simulated_image.source = "file:///"+current_algorithm2_sim_pic_path;
                algorithm2_pic_is_exist = 1;
                //显示算法2的按钮
                openRadioButton2();
            }else{
                algorithm2_simulated_image.source = "../IMAGE/forground.jpg";
                algorithm2_pic_is_exist = 0;
            }
            //判断是否有对应的算法三填充图，有的话就显示，没有的话用默认图片
            current_algorithm3_sim_pic_path = operator_user.isExist_Algorithm3SimPic(original_image.source);
            if(current_algorithm3_sim_pic_path!="inexistence"){
                algorithm3_simulated_image.source = "file:///"+current_algorithm3_sim_pic_path;
                algorithm3_pic_is_exist = 1;
                //显示算法3的按钮
                openRadioButton3();
            }else{
                algorithm3_simulated_image.source = "../IMAGE/forground.jpg";
                algorithm3_pic_is_exist = 0;
            }
            //将当前的图片索引号存入索引文件中
            operator_user.writeIndexFile(starting_ui.user_input_name.text,current_pic_index,3);
            //关闭按钮使能
            defaultFourRadioButton();
        }else{
            current_pic_index -= 1;
            //current_original_pic_path = xml_operation.getOriginOfIndexFromXML("file:///D:/色盲数据整理文件/combine_xml_result/step2_select_result_combine.xml",current_pic_index);
            //将标志位置位回去
            xml_operation.defaultstep3_xml_is_end();
        }
    }

    Connections{
        target: xml_operation

        onStep3_xmlfileEnds:{
            disenabledButton();
            xmlfile_end_window.visible = true;
        }
    }

    FileDialog{
        id:fileDialog;
        visible: false;
        title:"选择文件";
        contentItem: Rectangle{
            implicitHeight: 480;
            implicitWidth: 640;
        }
        //selectFolder: true
        folder: "file:///D:/"    //对话框打开的默认初始目录

        nameFilters: ["*.xml"];
        //selectedNameFilter: "Image Files(*.jpg *.png *.gif)";
        onAccepted: {
            selected_directory.text = fileDialog.fileUrl;
            //从选中的XML中读取第一个节点
            xml_operation.getFistNodeData(fileDialog.fileUrl);
            current_original_pic_path = xml_operation.getCurrentOriginPath();
            original_image.source = current_original_pic_path;
            //获取原始图片所在的目录
            folder = operator_user.getPic_Folder(original_image.source)
            //获取原始的目录集合
            operator_user.getOriginal_dirs(folder);
            current_algorithm2_sim_pic_path = operator_user.isExist_Algorithm2SimPic(original_image.source);
            if(current_algorithm2_sim_pic_path!= "inexistence"){
                algorithm2_simulated_image.source = "file:///"+current_algorithm2_sim_pic_path;
                algorithm2_pic_is_exist = 1;
            }else{
                algorithm2_simulated_image.source = "../IMAGE/forground.jpg";
                algorithm2_pic_is_exist = 0;
            }
            //判断是否有对应的算法三填充图，有的话就显示，没有的话用默认图片
            current_algorithm3_sim_pic_path = operator_user.isExist_Algorithm3SimPic(original_image.source);
            if(current_algorithm3_sim_pic_path!="inexistence"){
                algorithm3_simulated_image.source = "file:///"+current_algorithm3_sim_pic_path;
                algorithm3_pic_is_exist = 1;
            }else{
                algorithm3_simulated_image.source = "../IMAGE/forground.jpg";
                algorithm3_pic_is_exist = 0;
            }
        }
    }

    Text {
        id: image_choose_text
        x: 36
        y: 75
        width: 179
        height: 25
        text: qsTr("已选的XML文件：")
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
                text: qsTr("选择文件")
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
        x: 1080
        y: 515
        width: 97
        height: 60

        style: ButtonStyle{
            label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 13
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
            operator_user.writeIndexFile(starting_ui.user_input_name.text,current_pic_index,3);


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
        x: 185
        y: 28
        width: 95
        height: 31
        text: qsTr("raw")
        font.italic: true
        font.bold: true
        font.pixelSize: 29
    }

    Image {
        id: original_image
        x:24
        y:85
        width:  400
        height: 300
        source: "../IMAGE/forground.jpg"
    }

    Text {
        id: algorithm2_simulated_image_text
        x: 555
        y: 28
        text: qsTr("A2-fill-CVD")
        font.italic: true
        font.bold: true
        font.pixelSize: 29
    }

    Image {
        id: algorithm2_simulated_image
        x:439
        y:85
        width:  400
        height: 300
        source: "../IMAGE/forground.jpg"
    }

    Text {
        id: algorithm3_simulated_image_text
        x: 984
        y: 28
        text: qsTr("A3-fill-CVD")
        font.italic: true
        font.bold: true
        font.pixelSize: 29
    }

    Image {
        id: algorithm3_simulated_image
        x:857
        y:85
        width:  400
        height: 300
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

        id: algorithm2_logic;
    }
    RadioButton {
        id: algorithm2_image_no
        x: 540
        y: 436
        height: 20
        width: 60
        text: qsTr("Unrecognizable")
        //checked: true
        exclusiveGroup: algorithm2_logic;
        focus: true;
        activeFocusOnPress:  true;
        style:radioStyle;

        onClicked: {

        }
        onCheckedChanged: {

        }
    }
    RadioButton {
        id:algorithm2_image_yes
        x: 540
        y: 399
        height: 20
        width: 60
        text: qsTr("Recognizable")
        exclusiveGroup: algorithm2_logic;
        focus: true;
        activeFocusOnPress:  true;
        style:radioStyle;

        onClicked: {

        }
        onCheckedChanged: {

        }
    }

    //原始图的互斥分组
    ExclusiveGroup{

        id: algorithm3_logic;
    }
    RadioButton {
        id: algorithm3_image_no
        x: 967
        y: 436
        height: 20
        width: 60
        text: qsTr("Unrecognizable")
        //checked: true
        exclusiveGroup: algorithm3_logic;
        focus: true;
        activeFocusOnPress:  true;
        style:radioStyle;

        onClicked: {

        }
        onCheckedChanged: {

        }
    }
    RadioButton {
        id:algorithm3_image_yes
        x: 967
        y: 399
        height: 20
        width: 45
        text: qsTr("Recognizable")
        exclusiveGroup: algorithm3_logic;
        focus: true;
        activeFocusOnPress:  true;
        style:radioStyle;

        onClicked: {

        }
        onCheckedChanged: {

        }
    }

    Button{
        id: previous_group_button
        x: 361
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
                original_image.source = current_original_pic_path;
                //判断是否有对应的算法二的仿真图，有的话就显示，没有的话用默认图片
                current_algorithm2_sim_pic_path = operator_user.isExist_Algorithm2SimPic(original_image.source);
                if(current_algorithm2_sim_pic_path != "inexistence"){
                    algorithm2_simulated_image.source = "file:///"+current_algorithm2_sim_pic_path;
                }else{
                    algorithm2_simulated_image.source = "../IMAGE/forground.jpg";
                }
                //判断是否有对应的算法三的仿真图，有的话就显示，没有的话用默认图片
                current_algorithm3_sim_pic_path = operator_user.isExist_Algorithm3SimPic(original_image.source);
                if(current_algorithm3_sim_pic_path != "inexistence"){
                    algorithm3_simulated_image.source = "file:///"+current_algorithm3_sim_pic_path;
                }else{
                    algorithm3_simulated_image.source = "../IMAGE/forground.jpg";
                }
            }
        }

    }

    Button{
        id: next_group_button
        x: 540
        y: 612
        width: 97
        height: 35
        visible:false

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
                original_image.source = current_original_pic_path;
                //判断是否有对应的算法二的仿真图，有的话就显示，没有的话用默认图片
                current_algorithm2_sim_pic_path = operator_user.isExist_Algorithm2SimPic(original_image.source);
                if(current_algorithm2_sim_pic_path != "inexistence"){
                    algorithm2_simulated_image.source = "file:///"+current_algorithm2_sim_pic_path;
                }else{
                    algorithm2_simulated_image.source = "../IMAGE/forground.jpg";
                }
                //判断是否有对应的算法三的仿真图，有的话就显示，没有的话用默认图片
                current_algorithm3_sim_pic_path = operator_user.isExist_Algorithm3SimPic(original_image.source);
                if(current_algorithm3_sim_pic_path != "inexistence"){
                    algorithm3_simulated_image.source = "file:///"+current_algorithm3_sim_pic_path;
                }else{
                    algorithm3_simulated_image.source = "../IMAGE/forground.jpg";
                }
            }

        }

    }

    Text{
       x: 36
       y: 424
       width: 98
       height: 25
       text: qsTr("Total：")
       font.bold: true
       font.pixelSize: 29
    }

    Text{
        id: picture_count
        x: 145
        y: 424
        width: 98
        height: 25
        text:pic_count
        font.pixelSize: 29
    }

    Text{
       x: 36
       y: 467
       width: 137
       height: 25
       text: qsTr("Now：")
       font.bold: true
       font.pixelSize: 29
    }

    Text{
        id: current_picture_num
        x: 145
        y: 467
        width: 98
        height: 25
        text: current_pic_index+1
        font.pixelSize: 29
    }

    Button{
        id: save_button
        x: 470
        y: 528
        width: 338
        height: 47

        style: ButtonStyle{
            label: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 13
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
            if(algorithm2_pic_is_exist == 1 && algorithm3_pic_is_exist == 1){
                //如果当前的原始图既有算法2的图又有对应的算法3的图时
                if((algorithm2_image_yes.checked == false && algorithm2_image_no.checked == false) || (algorithm3_image_yes.checked == false && algorithm3_image_no.checked == false)){
                    //如果用户还没有对图片进行筛选
                    do_nothing_window.visible = true;

                }else{
                    if(algorithm2_image_yes.checked == true && algorithm3_image_yes.checked == true){
                        //算法2和3都可以区分
                        xml_operation.add_xmlnode(original_image.source,1,1,1);
                        //defaultFourRadioButton();
                        getNextGroupPic();
                    }else if(algorithm2_image_yes.checked == true && algorithm3_image_yes.checked == false){
                        //仅算法2可以区分
                        xml_operation.add_xmlnode(original_image.source,1,1,0);
                        //defaultFourRadioButton();
                        getNextGroupPic();

                    }else if(algorithm2_image_yes.checked == false && algorithm3_image_yes.checked == true){
                        //仅算法3可以区分
                        xml_operation.add_xmlnode(original_image.source,1,0,1);
                        //defaultFourRadioButton();
                        getNextGroupPic();

                    }else{
                        //算法2和3都不可以区分
                        xml_operation.add_xmlnode(original_image.source,0,0,0);
                        //defaultFourRadioButton();
                        getNextGroupPic();

                    }
                }
            }else if(algorithm2_pic_is_exist == 1 && algorithm3_pic_is_exist == 0){
                //当前原始图只有对应的算法2的图
                if(algorithm2_image_yes.checked == false && algorithm2_image_no.checked == false){
                    //如果用户还没有对图片进行筛选
                    do_nothing_window.visible = true;
                }else{
                    if(algorithm2_image_yes.checked == true){
                        //算法2可以区分
                        xml_operation.add_xmlnode(original_image.source,1,1,0);
                        //defaultFourRadioButton();
                        getNextGroupPic();

                    }else{
                        //算法2不可区分
                        xml_operation.add_xmlnode(original_image.source,0,0,0);
                        //defaultFourRadioButton();
                        getNextGroupPic();
                    }
                }
            }else if(algorithm2_pic_is_exist == 0 && algorithm3_pic_is_exist == 1){
                //当前原始图只有对应的算法3的图，不可能既没有算法2的图又没有算法3的图
                if(algorithm3_image_yes.checked == false && algorithm3_image_no.checked == false){
                    //如果用户还没有对图片进行筛选
                    do_nothing_window.visible = true;
                }else{
                    if(algorithm3_image_yes.checked == true){
                        //算法3可以区分
                        xml_operation.add_xmlnode(original_image.source,1,0,1);
                        //defaultFourRadioButton();
                        getNextGroupPic();

                    }else{
                        //算法3不可区分
                        xml_operation.add_xmlnode(original_image.source,0,0,0);
                        //defaultFourRadioButton();
                        getNextGroupPic();
                    }
                }
            }else{
                console.log("has error !!!!!!");
            }

        }
    }
}
