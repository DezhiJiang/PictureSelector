import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.2

Rectangle {
    id: mainWindow;
    visible: true
    width: 640
    height: 480

    /*目标矩形参数*/
    property double targetX: 0;
    property double targetY: 0;
    property double targetWidth: 0;
    property double targetHeight: 0;
    property double targetAngle: 0;
    property int addName:100;
    property int isColorExtra:0;
    //signal clickColorArea();
    //点击颜色抽取后设置点击编辑框中的一点可以下发参数。
    Connections{
        target: config_S2;
        onSetMouseAreaEnableTrue:{
            console.log("running_mouseArea_imageOperation");
            isColorExtra=value;
            console.log("----------------------------------------------------")
            console.log(isColorExtra);
        }
    }
    //角度复位
    Connections{
        target: config_S2
        onResetColorAreaAngle:{
            setFramePoint1x(200);
            setFramePoint1y(200);
            setFramePoint2x(400);
            setFramePoint2y(200);
            setFramePoint3x(400);
            setFramePoint3y(400);
            setFramePoint4x(200);
            setFramePoint4y(400);
            ctParams.drawPoint1X = ctParams.framePoint1X-1;
            ctParams.drawPoint1Y = ctParams.framePoint1Y-1;
            ctParams.drawPoint2X = ctParams.framePoint2X+1;
            ctParams.drawPoint2Y = ctParams.framePoint2Y-1;
            ctParams.drawPoint3X = ctParams.framePoint3X+1;
            ctParams.drawPoint3Y = ctParams.framePoint3Y+1;
            ctParams.drawPoint4X = ctParams.framePoint4X-1;
            ctParams.drawPoint4Y = ctParams.framePoint4Y+1;
            background.angle = 0;
            background.angleAll = 0;
            background.calcCenter();
            background.getRotationLength();
            background.requestPaint();
            colorAreaBitmapImage.source=""
            colorAreaBitmapImage.source="image://PretreatmentImage/modelImage"
        }
    }


    RunningParameter{
        id:runningParameter
    }

    function getMouseX(){
        return background.frameX;
    }
    function getMouseY(){
        return background.frameY;
    }

    function getFramePoint1x(){
        return ctParams.framePoint1X;
    }
    function getFramePoint1y(){
        return ctParams.framePoint1Y;
    }
    function getFramePoint2x(){
        return ctParams.framePoint2X;
    }
    function getFramePoint2y(){
        return ctParams.framePoint2Y;
    }
    function getFramePoint3x(){
        return ctParams.framePoint3X;
    }
    function getFramePoint3y(){
        return ctParams.framePoint3Y;
    }
    function getFramePoint4x(){
        return ctParams.framePoint4X;
    }
    function getFramePoint4y(){
        return ctParams.framePoint4Y;
    }
    function setFramePoint1x(x1){
        ctParams.framePoint1X =x1;
    }
    function setFramePoint1y(y1){
         ctParams.framePoint1Y =y1;
    }
    function setFramePoint2x(x2){
         ctParams.framePoint2X=x2;
    }
    function setFramePoint2y(y2){
         ctParams.framePoint2Y=y2;
    }
    function setFramePoint3x(x3){
         ctParams.framePoint3X=x3;
    }
    function setFramePoint3y(y3){
         ctParams.framePoint3Y=y3;
    }
    function setFramePoint4x(x4){
         ctParams.framePoint4X=x4;
    }
    function setFramePoint4y(y4){
         ctParams.framePoint4Y=y4;
    }

    SettingColorRectConfigParams{
        id: ctParams;
    }

//    MouseArea {
//        id: running_mouseArea_imageOperation
//        x: 8
//        y: 8
//        z: 3
//        width: running_item_imageOperation.width
//        height: running_item_imageOperation.height
//        hoverEnabled: true

//        Running_item_imageOperation {
//            id: running_item_imageOperation
//            width: runningParameter._RUNNING_IMAGE_OPERATION_BUTTON_WIDTH*3
//            height: runningParameter._RUNNING_IMAGE_OPERATION_BUTTON_HEIGHT*4
//            visible: running_mouseArea_imageOperation.containsMouse ?true:false
//        }
//    }
    Rectangle{
        id:running_rect_imagearea
        height: 480;
        width: 640;
        clip:true;
        border.color:"black"
        //scale: running_item_imageOperation.running_sliderVertical_scale.value
        z: 1
        onScaleChanged: {
            if(running_rect_imagearea.x<-(running_rect_imagearea.width*(running_rect_imagearea.scale-1))/2)
                running_rect_imagearea.x=-(running_rect_imagearea.width*(running_rect_imagearea.scale-1))/2

            if(running_rect_imagearea.x>(running_rect_imagearea.width*(running_rect_imagearea.scale-1))/2)
                running_rect_imagearea.x=(running_rect_imagearea.width*(running_rect_imagearea.scale-1))/2

            if(running_rect_imagearea.y<-(running_rect_imagearea.height*(running_rect_imagearea.scale-1))/2)
                running_rect_imagearea.y=-(running_rect_imagearea.height*(running_rect_imagearea.scale-1))/2

            if(running_rect_imagearea.y>(running_rect_imagearea.height*(running_rect_imagearea.scale-1))/2)
                running_rect_imagearea.y=(running_rect_imagearea.height*(running_rect_imagearea.scale-1))/2
        }

        MouseArea{

            id: operRect

            height: 480
            width: 640
            z: 1;
            property int currentValue: 0
            property int pressAndHoldValue: 0

              cursorShape: {
                if(background.mouseFlag==0)
                    Qt.ArrowCursor;
                if(background.mouseFlag==1)
                    Qt.SizeHorCursor;
                if(background.mouseFlag==2)
                    Qt.ClosedHandCursor;
                if(background.mouseFlag==3)
                    Qt.SizeAllCursor
              }

            hoverEnabled: true;
            onPressed: {
                background.lock = 1;
                background.postStatus = 1;
                pressAndHoldValue = 1;

                console.log("rectangle   ",background.frameX-18,background.frameY-18);
                background.getDragRect(background.frameX-18,background.frameY-18);
                console.log("mouseX in qML"+ mouseX);
                console.log("mouseY in qML"+ mouseY);
            }

            onReleased: {
                background.lock = 0;
                pressAndHoldValue = 0;

                //如果点击了颜色抽取按钮会对位图里的hsv值和阈值进行比对
                console.log("*************************************");
                console.log("isColorExtra: "+isColorExtra);
                if(isColorExtra===1){
                    if(background.postStatus===1&&background.isInSquare(mouseX,mouseY)){
                        //将数组满足条件的数组置入 画布数组中并刷新页面
                        config_S2.isClickCancelColorArea=0;
                        config_S2.colorAreaMouseX=mouseX;
                        config_S2.colorAreaMouseY=mouseY;
                        config_S2.setXY( config_S2.colorAreaMouseX, config_S2.colorAreaMouseY);
                    }
                }

                //移动画框时更新Image模板图片
                if(background.postStatus===0&&isColorExtra===0){
                    console.log("移动了矩形框");
                    //重新加载模板图片
                    colorAreaBitmapImage.source=""
                    colorAreaBitmapImage.source="image://PretreatmentImage/modelImage"
                    //把六个滑块同时设置为0发信号重置HSV
                    config_S2.recoverHSV();

                }

                if(background.postStatus==1&&background.isInSquare(mouseX,mouseY)){
//                    background.postData();
                }
            }

            onPositionChanged: {
                updateMouse(mouseX,mouseY);
                background.postStatus = 0;
                background.getMouseFlag(background.frameX,background.frameY);
                if(eraserRect.flag1==1&&background.isInSquare(background.frameX,background.frameY))
                    eraserRect.flag2 = 1;
                else
                    eraserRect.flag2 = 0;

                if(pressed){
                    if(eraserRect.flag1==1&&eraserRect.flag2==1){
                        background.getDragRect(background.frameX-18,background.frameY-18);
                        paintColor(background.tempArray);
                    }

                    if(background.mouseFlag ==1){
                        background.prevHorDistance = ctParams.curHorDistance;
                        background.prevVerDistance = ctParams.curVerDistance
                        background.dragEdge(background.frameOldX,background.frameOldY,
                                            background.frameX,background.frameY);
                        background.calcCenter();
                        background.getRotationLength();
                    }
                    if(background.mouseFlag == 2){
                        if(background.isAboveLine(background.frameX,background.frameY,
                                                  background.frameOldX,background.frameOldY,
                                                  background.centerX,background.centerY)===1)
                            background.setAngle(-background.getAngle(background.frameOldX,background.frameOldY,
                                                                     background.frameX,background.frameY));
                        else
                            background.setAngle(background.getAngle(background.frameOldX,background.frameOldY,
                                                                    background.frameX,background.frameY));
                        background.calcCenter();
                        background.getRotationLength();
                        background.rotation();
                    }
                    if(background.mouseFlag ==3){
                        background.dragRect(background.frameOldX,background.frameOldY
                                            ,background.frameX,background.frameY);
                        background.calcCenter();
                    }
                }
            }

            function paintColor(array){
                for(var i = 0; i < array.length;i++){
                    background.imageData.data[array[i]] = 255;
                    background.imageData.data[array[i]+1] = 255;
                    background.imageData.data[array[i]+2] = 255;
                    background.imageData.data[array[i]+3] = 255;
                }
                background.requestPaint();
            }

            function updateMouse(x,y){
                background.frameOldX = background.frameX;
                background.frameOldY = background.frameY;
                background.frameX = x;
                background.frameY = y;
                background.requestPaint();
            }
            Image {
                id:colorAreaBitmapImage;
                cache:false;

                //图像位置
                anchors.verticalCenter: parent.verticalCenter;

                /*视频区域 尺寸*/
                width: size.picture_width;
                height: size.picture_height;

                source: "../../Image/background.jpg"

                Connections{
                    target: settinguidata
                    onSignalResetCorlorAreaRectangleResultImage:{
                        console.log("onSingnalResetColorRectangleResultImage")
                        colorAreaBitmapImage.source=""
                        colorAreaBitmapImage.source="image://colorResultImage/colorBitmapFillImage"
                        operRect.enabled = true;
                        console.log("---------------++++++++++++++++------------------")
                    }
                    //接收嵌入式传过来的四个点的坐标，在画布上画出矩形框，这个主要是进行颜色撤销操作
                    onSignalResetColorAreaPointLocation:{

                        console.log("onSignalResetColorAreaPointLocation");
                        setFramePoint1x(x0);
                        setFramePoint1y(y0);
                        setFramePoint2x(x1);
                        setFramePoint2y(y1);
                        setFramePoint3x(x2);
                        setFramePoint3y(y2);
                        setFramePoint4x(x3);
                        setFramePoint4y(y3);

                    var length = background.getTwoPointsDist(ctParams.framePoint1X,ctParams.framePoint1Y,
                                                         ctParams.framePoint2X,ctParams.framePoint2Y);
                    var temp = ctParams.framePoint2X - ctParams.framePoint1X;
                    if(ctParams.framePoint2Y>=ctParams.framePoint1Y){
                            background.angleAll = Math.acos(temp/length);
                    }
                     else{
                        if(temp>0){
                        background.angleAll = -Math.acos(temp/length);
                        }else{
                            background.angleAll = (2*Math.PI - Math.acos(temp/length));
                        }
                    }

                        background.calcCenter();
                        background.requestPaint();
                                   // background.resetPoint();
                    }

                }
                Connections{
                    target:settinguidata
                    onSignalResetModelImage:{
                        colorAreaBitmapImage.source=""
                        colorAreaBitmapImage.source="image://PretreatmentImage/modelImage"
                    }
                }
                //当新建一个颜色工具时发送还原信号，让显示界面恢复模板配置界面。
                Connections{
                    target: config_S2
                    onRecoverColorAreaTool:{
                        colorAreaBitmapImage.source=""
                        colorAreaBitmapImage.source="image://PretreatmentImage/modelImage"
                        setFramePoint1x(200);
                        setFramePoint1y(200);
                        setFramePoint2x(400);
                        setFramePoint2y(200);
                        setFramePoint3x(400);
                        setFramePoint3y(400);
                        setFramePoint4x(200);
                        setFramePoint4y(400);

                        ctParams.drawPoint1X = ctParams.framePoint1X-1;
                        ctParams.drawPoint1Y = ctParams.framePoint1Y-1;
                        ctParams.drawPoint2X = ctParams.framePoint2X+1;
                        ctParams.drawPoint2Y = ctParams.framePoint2Y-1;
                        ctParams.drawPoint3X = ctParams.framePoint3X+1;
                        ctParams.drawPoint3Y = ctParams.framePoint3Y+1;
                        ctParams.drawPoint4X = ctParams.framePoint4X-1;
                        ctParams.drawPoint4Y = ctParams.framePoint4Y+1;



                        background.angle= 0;  //单次旋转角度
                        background.angleAll=0;
                        background.calcCenter();
                        background.requestPaint();
                    }

                }
                Connections{
                    target: config_S2;
                    onUpdateColorArea:{

                        setFramePoint1x(toolsModel.getColorAreaSearchRectX0(config_S2.currentIndex));
                        setFramePoint1y(toolsModel.getColorAreaSearchRectY0(config_S2.currentIndex));
                        setFramePoint2x(toolsModel.getColorAreaSearchRectX3(config_S2.currentIndex));
                        setFramePoint2y(toolsModel.getColorAreaSearchRectY3(config_S2.currentIndex));
                        setFramePoint3x(toolsModel.getColorAreaSearchRectX2(config_S2.currentIndex));
                        setFramePoint3y(toolsModel.getColorAreaSearchRectY2(config_S2.currentIndex));
                        setFramePoint4x(toolsModel.getColorAreaSearchRectX1(config_S2.currentIndex));
                        setFramePoint4y(toolsModel.getColorAreaSearchRectY1(config_S2.currentIndex));
                        background.calcCenter();
                        background.requestPaint()
                        //background.resetPoint();

                    }
                }


            }

            Canvas{
                id: background;
                width: 640;
                height: 480;
                contextType: "2d";
                z:2;
                Rectangle{
                    id:eraserRect;
                    width: 30;
                    height: 30;
                    x:background.frameX-18;
                    y:background.frameY-18;
                    property var flag1: 0;
                    property var flag2: 0;
                    color:Qt.rgba(0,0,0,0);
                    border.color: "blue";
                    border.width: 2;
                    visible: {
                        if(flag1==1&&flag2==1)
                            true;
                        else
                            false;
                    }
                    z:2;
                }
                Image{
                    id:arc_arrow;
                    source: "../../Image/arc_arrow.png";
                    x: background.centerX-ctParams.curHorDistance/2-45;
                    y: background.centerY-ctParams.curVerDistance/2-45;
                    transform: Rotation {
                        origin.x: ctParams.curHorDistance/2+45;
                        origin.y: ctParams.curVerDistance/2+45;
                        angle: background.angleAll/Math.PI*180;
                    }
                }

                //鼠标当前位置
                property real frameX: operRect.mouseX;
                property real frameY: operRect.mouseY;
                //鼠标之前位置
                property real frameOldX: 0;
                property real frameOldY: 0;

                //中心坐标
                property real centerX: 0;
                property real centerY: 0;

                property real minDifference: 30
                property real prevHorDistance: 0
                property real prevVerDistance: 0



                property var mouseFlag: 0;        //鼠标标志位
                property var length: 0;
                property var length1: 0;
                property var length2: 0;
                property var length3: 0;

                property var edgeFlag: 0;
                property var lock: 0;
                property var angle: 0;  //单次旋转角度
                property var angleAll: 0;
                property var postStatus: 0;
                /*===============================================*/
                property var paintArray: new Array;

                onPaint: {

                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.clearRect(0,0,640,480);
                    ctx.strokeStyle = "red";
                    ctx.lineWidth = 3;
                    ctx.beginPath();
                    ctParams.setDrawPoints();
                    ctx.moveTo(ctParams.drawPoint1X,ctParams.drawPoint1Y);
                    ctx.lineTo(ctParams.drawPoint2X,ctParams.drawPoint2Y);
                    ctx.lineTo(ctParams.drawPoint3X,ctParams.drawPoint3Y);
                    ctx.lineTo(ctParams.drawPoint4X,ctParams.drawPoint4Y);
                    ctx.closePath();
                    ctx.stroke();

                    if(isInSquare(frameX,frameY)&&!operRect.pressAndHoldValue){
                        drawOperationPoints();
                    }
                    if(isInRotationArea(frameX, frameY)|| operRect.cursorShape==Qt.ClosedHandCursor&&operRect.pressAndHoldValue) {
                        if(eraserRect.flag1!= 1)
                            arc_arrow.visible = true;
                        else
                            arc_arrow.visible = false;
                    }
                    else{
                        arc_arrow.visible = false;
                    }
                }

                function drawOperationPoints() {
                    var ctx = getContext("2d");
                    //1 point
                    ctx.fillStyle = "red";
                    ctx.beginPath();
                    ctx.moveTo(ctParams.drawPoint1X,ctParams.drawPoint1Y);
                    ctx.arc(ctParams.drawPoint1X,ctParams.drawPoint1Y,5,0,Math.PI*2, true);
                    ctx.moveTo(ctParams.drawPoint1X,ctParams.drawPoint1Y);
                    ctx.fill();
                    ctx.closePath();
                    ctx.stroke();
                    //2 point
                    ctx.beginPath();
                    ctx.moveTo((ctParams.drawPoint1X+ctParams.drawPoint2X)/2, (ctParams.drawPoint1Y+ctParams.drawPoint2Y)/2);
                    ctx.arc((ctParams.drawPoint1X+ctParams.drawPoint2X)/2, (ctParams.drawPoint1Y+ctParams.drawPoint2Y)/2,5,0,Math.PI*2, true);
                    ctx.moveTo((ctParams.drawPoint1X+ctParams.drawPoint2X)/2, (ctParams.drawPoint1Y+ctParams.drawPoint2Y)/2);
                    ctx.fill();
                    ctx.closePath();
                    ctx.stroke();

                    //4 point
                    ctx.beginPath();
                    ctx.moveTo((ctParams.drawPoint2X+ctParams.drawPoint3X)/2, (ctParams.drawPoint2Y+ctParams.drawPoint3Y)/2);
                    ctx.arc((ctParams.drawPoint2X+ctParams.drawPoint3X)/2, (ctParams.drawPoint2Y+ctParams.drawPoint3Y)/2,5,0,Math.PI*2, true);
                    ctx.moveTo((ctParams.drawPoint2X+ctParams.drawPoint3X)/2, (ctParams.drawPoint2Y+ctParams.drawPoint3Y)/2);
                    ctx.fill();
                    ctx.closePath();
                    ctx.stroke();

                    //6 point
                    ctx.beginPath();
                    ctx.moveTo((ctParams.drawPoint3X+ctParams.drawPoint4X)/2, (ctParams.drawPoint3Y+ctParams.drawPoint4Y)/2);
                    ctx.arc((ctParams.drawPoint3X+ctParams.drawPoint4X)/2, (ctParams.drawPoint3Y+ctParams.drawPoint4Y)/2,5,0,Math.PI*2, true);
                    ctx.moveTo((ctParams.drawPoint3X+ctParams.drawPoint4X)/2, (ctParams.drawPoint3Y+ctParams.drawPoint4Y)/2);
                    ctx.fill();
                    ctx.closePath();
                    ctx.stroke();

                    //8 point
                    ctx.beginPath();
                    ctx.moveTo((ctParams.drawPoint4X+ctParams.drawPoint1X)/2, (ctParams.drawPoint4Y+ctParams.drawPoint1Y)/2);
                    ctx.arc((ctParams.drawPoint4X+ctParams.drawPoint1X)/2, (ctParams.drawPoint4Y+ctParams.drawPoint1Y)/2,5,0,Math.PI*2, true);
                    ctx.moveTo((ctParams.drawPoint4X+ctParams.drawPoint1X)/2, (ctParams.drawPoint4Y+ctParams.drawPoint1Y)/2);
                    ctx.closePath();
                    ctx.fill();
                    ctx.stroke();
                    requestPaint();
                }



                function getMouseFlag(x,y){
                    //光标在操作点上
                    if(isExpandingRect(x,y)&&lock==0&&eraserRect.flag1==0&&isColorExtra==0){
                        mouseFlag = 1;
                    }
                    //光标在方框内
                    else if(isInSquare(x,y)&&lock==0&&eraserRect.flag1==0&&isColorExtra==0){
                        mouseFlag = 3;//鼠标进入方块
                    }
                    //光标在方框外
                    else if(isInRotationArea(x,y)&&lock==0&&eraserRect.flag1==0&&isColorExtra==0){
                        mouseFlag = 2;
                    }
                    else if(lock==0){
                        mouseFlag = 0;
                    }

                }

                function getAngle(x,y,x1,y1){
                    var aLength = Math.sqrt((x-centerX)*(x-centerX)+(y-centerY)*(y-centerY));
                    var bLength = Math.sqrt((x1-centerX)*(x1-centerX)+(y1-centerY)*(y1-centerY));
                    var cLength = Math.sqrt((x-x1)*(x-x1)+(y-y1)*(y-y1));
                    var a = (aLength*aLength+bLength*bLength-cLength*cLength)/(2*aLength*bLength);
                    if((y-centerY)/(x-centerY)!=(centerY-y1)/(centerY-x1))
                        return  Math.acos(a);
                    else
                        return  Math.PI/2;
                }

                function getTheAngle(x,y){
                    var length = Math.sqrt((x-centerX)*(x-centerX)+(y-centerY)*(y-centerY));
                    var temp = x - centerX;
                    if(y>centerY){
                        return Math.acos(temp/length);
                    }
                    if(y<centerY){
                        if(temp>0){
                            return -Math.acos(temp/length);
                        }else{
                            return 2*Math.PI - Math.acos(temp/length)
                        }
                    }
                }

                function setAngle(x){
                    angle = x;
                }

                function getRotationLength(){
                    length = Math.sqrt((ctParams.drawPoint1X-centerX)*(ctParams.drawPoint1X-centerX)
                                       +(ctParams.drawPoint1Y-centerY)*(ctParams.drawPoint1Y-centerY));
                }
                //计算坐标中心
                function calcCenter(){
                    centerX = (ctParams.framePoint1X + ctParams.framePoint3X)/2;
                    centerY = (ctParams.framePoint1Y + ctParams.framePoint3Y)/2;
                }

                function setHorizon(){

                    angleAll = 0;
                    requestPaint();
                }

                function rotation(){

                    var cosAngel = Math.cos(angle);
                    var sinAngle = Math.sin(angle);
                    var constVarX = (1-cosAngel)*centerX+centerY*sinAngle;
                    var constVarY = (1-cosAngel)*centerY-centerX*sinAngle;
                    var tempPoint1X, tempPoint1Y, tempPoint2X, tempPoint2Y;
                    var tempPoint3X, tempPoint3Y, tempPoint4X, tempPoint4Y;
                    var tempPointX = ctParams.framePoint1X;
                    tempPoint1X = cosAngel*ctParams.framePoint1X-sinAngle*ctParams.framePoint1Y+constVarX;
                    tempPoint1Y = sinAngle*tempPointX+cosAngel*ctParams.framePoint1Y+constVarY;
                    tempPointX = ctParams.framePoint2X;
                    tempPoint2X = cosAngel*ctParams.framePoint2X-sinAngle*ctParams.framePoint2Y+constVarX;
                    tempPoint2Y = sinAngle*tempPointX+cosAngel*ctParams.framePoint2Y+constVarY;
                    tempPointX = ctParams.framePoint3X;
                    tempPoint3X = cosAngel*ctParams.framePoint3X-sinAngle*ctParams.framePoint3Y+constVarX;
                    tempPoint3Y = sinAngle*tempPointX+cosAngel*ctParams.framePoint3Y+constVarY;
                    tempPointX = ctParams.framePoint4X;
                    tempPoint4X = cosAngel*ctParams.framePoint4X-sinAngle*ctParams.framePoint4Y+constVarX;
                    tempPoint4Y = sinAngle*tempPointX+cosAngel*ctParams.framePoint4Y+constVarY;
                    if((0<=tempPoint1X&&tempPoint1X<=640 && 0<=tempPoint2X&&tempPoint2X<=640 &&
                       0<=tempPoint3X&&tempPoint3X<=640 && 0<=tempPoint4X&&tempPoint4X<=640) &&
                      (0<=tempPoint1Y&&tempPoint1Y<=480 && 0<=tempPoint2Y&&tempPoint2Y<=480 &&
                       0<=tempPoint3Y&&tempPoint3Y<=480 && 0<=tempPoint4Y&&tempPoint4Y<=480)) {
                        ctParams.framePoint1X = tempPoint1X;
                        ctParams.framePoint2X = tempPoint2X;
                        ctParams.framePoint3X = tempPoint3X;
                        ctParams.framePoint4X = tempPoint4X;
                        ctParams.framePoint1Y = tempPoint1Y;
                        ctParams.framePoint2Y = tempPoint2Y;
                        ctParams.framePoint3Y = tempPoint3Y;
                        ctParams.framePoint4Y = tempPoint4Y;
                        angleAll += angle;
                    }

                    tempPointX = ctParams.pt1Triangle1Pt1X;
                    ctParams.pt1Triangle1Pt1X = cosAngel*ctParams.pt1Triangle1Pt1X-sinAngle*ctParams.pt1Triangle1Pt1Y+constVarX;
                    ctParams.pt1Triangle1Pt1Y = sinAngle*tempPointX+cosAngel*ctParams.pt1Triangle1Pt1Y+constVarY;
                    tempPointX = ctParams.pt1Triangle1Pt2X;
                    ctParams.pt1Triangle1Pt2X = cosAngel*ctParams.pt1Triangle1Pt2X-sinAngle*ctParams.pt1Triangle1Pt2Y+constVarX;
                    ctParams.pt1Triangle1Pt2Y = sinAngle*tempPointX+cosAngel*ctParams.pt1Triangle1Pt2Y+constVarY;
                    tempPointX = ctParams.pt1Triangle1Pt3X;
                    ctParams.pt1Triangle1Pt3X = cosAngel*ctParams.pt1Triangle1Pt3X-sinAngle*ctParams.pt1Triangle1Pt3Y+constVarX;
                    ctParams.pt1Triangle1Pt3Y = sinAngle*tempPointX+cosAngel*ctParams.pt1Triangle1Pt3Y+constVarY;
                    tempPointX = ctParams.pt1Triangle2Pt1X;
                    ctParams.pt1Triangle2Pt1X = cosAngel*ctParams.pt1Triangle2Pt1X-sinAngle*ctParams.pt1Triangle2Pt1Y+constVarX;
                    ctParams.pt1Triangle2Pt1Y = sinAngle*tempPointX+cosAngel*ctParams.pt1Triangle2Pt1Y+constVarY;
                    tempPointX = ctParams.pt1Triangle2Pt2X;
                    ctParams.pt1Triangle2Pt2X = cosAngel*ctParams.pt1Triangle2Pt2X-sinAngle*ctParams.pt1Triangle2Pt2Y+constVarX;
                    ctParams.pt1Triangle2Pt2Y = sinAngle*tempPointX+cosAngel*ctParams.pt1Triangle2Pt2Y+constVarY;
                    tempPointX = ctParams.pt1Triangle2Pt3X;
                    ctParams.pt1Triangle2Pt3X = cosAngel*ctParams.pt1Triangle2Pt3X-sinAngle*ctParams.pt1Triangle2Pt3Y+constVarX;
                    ctParams.pt1Triangle2Pt3Y = sinAngle*tempPointX+cosAngel*ctParams.pt1Triangle2Pt3Y+constVarY;

                    tempPointX = ctParams._UPPER_LEFT_ROTATION_AREA_PT1X;
                    ctParams._UPPER_LEFT_ROTATION_AREA_PT1X = cosAngel*ctParams._UPPER_LEFT_ROTATION_AREA_PT1X -
                            sinAngle*ctParams._UPPER_LEFT_ROTATION_AREA_PT1Y+constVarX;
                    ctParams._UPPER_LEFT_ROTATION_AREA_PT1Y = sinAngle*tempPointX+cosAngel*ctParams._UPPER_LEFT_ROTATION_AREA_PT1Y+constVarY;
                    tempPointX = ctParams._UPPER_LEFT_ROTATION_AREA_PT2X;
                    ctParams._UPPER_LEFT_ROTATION_AREA_PT2X = cosAngel*ctParams._UPPER_LEFT_ROTATION_AREA_PT2X -
                            sinAngle*ctParams._UPPER_LEFT_ROTATION_AREA_PT2Y+constVarX;
                    ctParams._UPPER_LEFT_ROTATION_AREA_PT2Y = sinAngle*tempPointX+cosAngel*ctParams._UPPER_LEFT_ROTATION_AREA_PT2Y+constVarY;
                    tempPointX = ctParams._UPPER_LEFT_ROTATION_AREA_PT3X;
                    ctParams._UPPER_LEFT_ROTATION_AREA_PT3X = cosAngel*ctParams._UPPER_LEFT_ROTATION_AREA_PT3X -
                            sinAngle*ctParams._UPPER_LEFT_ROTATION_AREA_PT3Y+constVarX;
                    ctParams._UPPER_LEFT_ROTATION_AREA_PT3Y = sinAngle*tempPointX+cosAngel*ctParams._UPPER_LEFT_ROTATION_AREA_PT3Y+constVarY;

                    requestPaint();
                }

                function getLength(x,y,x1,y1,x2,y2){
                    var A = y2-y1;
                    var B = x1-x2;
                    var C = (y1-y2)*x1 + (x2-x1)*y1;
                    var temp = Math.abs(A*x+B*y + C);
                    return temp/Math.sqrt(A*A+B*B);
                }
                //点和直线的关系

                function isAboveLine(x,y,x1,y1,x2,y2){
                    var A = y1-y2;
                    var B = x2- x1;
                    var C = (y2-y1)*x1 + (x1-x2)*y1;
                    if(A*x+B*y+C>0)
                        return 1
                    else
                        return 0;
                }

                function isInSquare(x,y){
                    if(isAboveLine(x,y,ctParams.framePoint1X,ctParams.framePoint1Y,ctParams.framePoint2X,ctParams.framePoint2Y)
                            &&isAboveLine(x,y,ctParams.framePoint2X,ctParams.framePoint2Y,ctParams.framePoint3X,ctParams.framePoint3Y)
                            &&isAboveLine(x,y,ctParams.framePoint3X,ctParams.framePoint3Y,ctParams.framePoint4X,ctParams.framePoint4Y)
                            &&isAboveLine(x,y,ctParams.framePoint4X,ctParams.framePoint4Y,ctParams.framePoint1X,ctParams.framePoint1Y)){
                        return true;
                    }else{
                        return false;
                    }
                }

                function isExpandingRect(x,y) {
                    /*
                    if(ctParams.operatePointRadius>background.getTwoPointsDist(x,y,ctParams.drawPoint1X,ctParams.drawPoint1Y)) {
                        edgeFlag = ctParams.operationPointOne;
                        console.log("edgeFlag = 1");
                        return true;
                    }
                    */
                    /*else */if((ctParams.operatePointRadius>background.getTwoPointsDist(x,y,(ctParams.drawPoint1X+ctParams.drawPoint2X)/2,(ctParams.drawPoint1Y+ctParams.drawPoint2Y)/2))) {
                        edgeFlag = ctParams.operationPointTwo;
                        console.log("edgeFlag = 2");
                        return true;
                    }
                    /*
                    if(ctParams.operatePointRadius>background.getTwoPointsDist(x,y,ctParams.drawPoint2X,ctParams.drawPoint2Y)) {
                        edgeFlag = ctParams.operationPointThree;
                        console.log("edgeFlag = 3");
                        return true;
                    }
                    */
                    else if((ctParams.operatePointRadius>background.getTwoPointsDist(x,y,(ctParams.drawPoint2X+ctParams.drawPoint3X)/2,(ctParams.drawPoint2Y+ctParams.drawPoint3Y)/2))) {
                        edgeFlag = ctParams.operationPointFour;
                        console.log("edgeFlag = 4");
                        return true;
                    }
                    /*
                    if(ctParams.operatePointRadius>background.getTwoPointsDist(x,y,ctParams.drawPoint3X,ctParams.drawPoint3Y)) {
                        edgeFlag = ctParams.operationPointFive;
                        console.log("edgeFlag = 5");
                        return true;
                    }
                    */
                    else if((ctParams.operatePointRadius>background.getTwoPointsDist(x,y,(ctParams.drawPoint3X+ctParams.drawPoint4X)/2,(ctParams.drawPoint3Y+ctParams.drawPoint4Y)/2))) {
                        edgeFlag = ctParams.operationPointSix;
                        console.log("edgeFlag = 6");
                        return true;
                    }
                    /*
                    if(ctParams.operatePointRadius>background.getTwoPointsDist(x,y,ctParams.drawPoint4X,ctParams.drawPoint4Y)) {
                        edgeFlag = ctParams.operationPointSeven;
                        console.log("edgeFlag = 7");
                        return true;
                    }
                    */
                    else if((ctParams.operatePointRadius>background.getTwoPointsDist(x,y,(ctParams.drawPoint4X+ctParams.drawPoint1X)/2,(ctParams.drawPoint4Y+ctParams.drawPoint1Y)/2))) {
                        edgeFlag = ctParams.operationPointEight;
                        console.log("edgeFlag = 8");
                        return true;
                    }
                    else {
                        /* 如果正处于拉伸方框的操作中，即便当前鼠标不在操作点范围内，edgeFlag仍为上次的值 */
                        return false;
                    }
                }


                function getTwoPointDist(x,y,x1,y1){
                    return Math.sqrt((x-x1)*(x-x1)+(y-y1)*(y-y1));
                }

                function isDragEdge(x,y){
                    //5 is radius
                    if(getTwoPointDist(x,y,drawPoint1X,drawPoint1Y)<5){
                        edgeFlag = 0;
                        return true;
                    }
                    if(getTwoPointDist(x,y,drawPoint2X,drawPoint2Y)<5){
                        edgeFlag = 1;
                        return true;
                    }

                    if(getTwoPointDist(x,y,drawPoint3X,drawPoint3Y)<5){
                        edgeFlag = 2;
                        return true;
                    }


                    if(getTwoPointDist(x,y,drawPoint4X,drawPoint4Y)<5){
                        edgeFlag = 3;
                        return true;
                    }
                    return false;
                }

                function isInOutSquare(x,y){
                    if(!isInSquare(x,y))
                        return true;
                    return false;
                }

                function isInRotationArea(x,y) {
                    if(ctParams.curHorDistance<=ctParams.minDifference || ctParams.curVerDistance<=ctParams.minDifference) {
                        ctParams.rotationRadius = 15;
                    }
                    else {
                        ctParams.rotationRadius = 30;
                    }

                    if(isInSquare(x,y)===false &&
                       getTwoPointsDist(frameX, frameY, ctParams.framePoint1X, ctParams.framePoint1Y)<ctParams.rotationRadius) {
                        console.log("In UpperLeft Rotation Area");
                        return true;
                    }
                    return false;
                }

                function getCenterLength(x,y){
                    var center1 = (framePoint1X+framePoint3X)/2;
                    var center2 = (framePoint1Y+framePoint3Y)/2;
                    return Math.sqrt(center1-x)*(center1-x)+(center2-y)*(center2-y);
                }

//                function getCurVerDistance() {
//                    return getTwoPointsDist(framePoint1X, framePoint1Y, framePoint4X, framePoint4Y);
//                }

//                function getCurHorDistance() {
//                    return getTwoPointsDist(framePoint1X, framePoint1Y, framePoint2X, framePoint2Y);
//                }

                function getTwoPointsDist(x1,y1,x2,y2) {
                    return Math.sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
                }

                function dragRect(x,y,x1,y1){
                    var a = x1-x;
                    var b = y1-y;
                    console.log("a is " + a + " b is " + b);
                    if((ctParams.framePoint1X + a < 0 || ctParams.framePoint1X + a > 640) ||
                            (ctParams.framePoint2X + a < 0 || ctParams.framePoint2X + a > 640) ||
                            (ctParams.framePoint3X + a < 0 || ctParams.framePoint3X + a > 640) ||
                            (ctParams.framePoint4X + a < 0 || ctParams.framePoint4X + a > 640)) {
                        a = 0;
                    }
                    if((ctParams.framePoint1Y + b < 0 || ctParams.framePoint1Y + b >480) ||
                            (ctParams.framePoint2Y + b < 0 || ctParams.framePoint2Y + b >480) ||
                            (ctParams.framePoint3Y + b < 0 || ctParams.framePoint3Y + b >480) ||
                            (ctParams.framePoint4Y + b < 0 || ctParams.framePoint4Y + b >480)) {
                        b = 0;
                    }

                    ctParams.framePoint1X = ctParams.framePoint1X + a;
                    ctParams.framePoint2X = ctParams.framePoint2X + a;
                    ctParams.framePoint3X = ctParams.framePoint3X + a;
                    ctParams.framePoint4X = ctParams.framePoint4X + a;
                    ctParams.framePoint1Y = ctParams.framePoint1Y + b;
                    ctParams.framePoint2Y = ctParams.framePoint2Y + b;
                    ctParams.framePoint3Y = ctParams.framePoint3Y + b;
                    ctParams.framePoint4Y = ctParams.framePoint4Y + b;

                    ctParams.pt1Triangle1Pt1X = ctParams.pt1Triangle1Pt1X + a;
                    ctParams.pt1Triangle1Pt2X = ctParams.pt1Triangle1Pt2X + a;
                    ctParams.pt1Triangle1Pt3X = ctParams.pt1Triangle1Pt3X + a;
                    ctParams.pt1Triangle1Pt1Y = ctParams.pt1Triangle1Pt1Y + b;
                    ctParams.pt1Triangle1Pt2Y = ctParams.pt1Triangle1Pt2Y + b;
                    ctParams.pt1Triangle1Pt3Y = ctParams.pt1Triangle1Pt3Y + b;

                    ctParams.pt1Triangle2Pt1X = ctParams.pt1Triangle2Pt1X + a;
                    ctParams.pt1Triangle2Pt2X = ctParams.pt1Triangle2Pt2X + a;
                    ctParams.pt1Triangle2Pt3X = ctParams.pt1Triangle2Pt3X + a;
                    ctParams.pt1Triangle2Pt1Y = ctParams.pt1Triangle2Pt1Y + b;
                    ctParams.pt1Triangle2Pt2Y = ctParams.pt1Triangle2Pt2Y + b;
                    ctParams.pt1Triangle2Pt3Y = ctParams.pt1Triangle2Pt3Y + b;

                    ctParams._UPPER_LEFT_ROTATION_AREA_PT1X += a;
                    ctParams._UPPER_LEFT_ROTATION_AREA_PT2X += a;
                    ctParams._UPPER_LEFT_ROTATION_AREA_PT3X += a;
                    ctParams._UPPER_LEFT_ROTATION_AREA_PT1Y += b;
                    ctParams._UPPER_LEFT_ROTATION_AREA_PT2Y += b;
                    ctParams._UPPER_LEFT_ROTATION_AREA_PT3Y += b;

                    settinguidata.resetHSV();
                    requestPaint();
                }

                function dragEdge(x,y,x1,y1){
                    var delta_x = x1-x;
                    var delta_y = y1-y;
                    var zoom_scale = 0;
                    var mod_angleAll = 0;
                    var tempX1, tempY1, tempX2, tempY2;
                    var tempAngleAll = angleAll;
                    //调整angleAll的范围使之>=0
                    while(tempAngleAll<0) {
                        tempAngleAll += Math.PI*2;
                    }
                    mod_angleAll = tempAngleAll%(Math.PI*2);

                    /*
                    if(edgeFlag == ctParams.operationPointOne) {
                        console.log("操作点1");
                        tempK = (ctParams.framePoint1X-ctParams.framePoint4X)/(ctParams.framePoint1Y-ctParams.framePoint4Y);
                        if(tempK <= 1) {
                            tempY = temp;

                            ctParams.framePoint1X = ctParams.framePoint1X + (ctParams.framePoint1X-ctParams.framePoint3X)/(ctParams.framePoint1Y-ctParams.framePoint3Y)*tempY;
                            ctParams.framePoint1Y = ctParams.framePoint1Y + tempY;
                            var distance1to3 = getTwoPointsDist(ctParams.framePoint1X, ctParams.framePoint1Y, ctParams.framePoint3X, ctParams.framePoint3Y);

                        }

                        if(tempK === Infinity) {
                            tempX = temp1;
                            tempY = temp;
                            ctParams.framePoint1X = ctParams.framePoint1X + tempX;
                            ctParams.framePoint1Y = ctParams.framePoint1Y + tempY;
                            ctParams.framePoint2Y = ctParams.framePoint2Y + tempY;
                            ctParams.framePoint4X = ctParams.framePoint4X + tempX;
                        }
                    }
                    */
                    /*else */if(edgeFlag == ctParams.operationPointTwo){
                        console.log("mod_angleAll is " + mod_angleAll);
                        if((0<=mod_angleAll&&mod_angleAll<Math.PI/4) || (Math.PI*7/4<=mod_angleAll&&mod_angleAll<Math.PI*2)) {
                            zoom_scale = (ctParams.curVerDistance-delta_y)/ctParams.curVerDistance;
                        }
                        else if(Math.PI/4<=mod_angleAll && mod_angleAll<Math.PI*3/4) {
                            zoom_scale = (ctParams.curVerDistance+delta_x)/ctParams.curVerDistance;
                        }
                        else if(Math.PI*3/4<=mod_angleAll && mod_angleAll<Math.PI*5/4) {
                            zoom_scale = (ctParams.curVerDistance+delta_y)/ctParams.curVerDistance;
                        }
                        //Math.PI*5/4<=mod_angleAll && mod_angleAll<Math.PI*7/4
                        else {
                            zoom_scale = (ctParams.curVerDistance-delta_x)/ctParams.curVerDistance;
                        }
                        if(zoom_scale>1 || ctParams.curVerDistance>ctParams.minDifference) {
                            tempX1 = ctParams.framePoint1X*zoom_scale+ctParams.framePoint4X*(1-zoom_scale);
                            tempY1 = ctParams.framePoint1Y*zoom_scale+ctParams.framePoint4Y*(1-zoom_scale);
                            tempX2 = ctParams.framePoint2X*zoom_scale+ctParams.framePoint3X*(1-zoom_scale);
                            tempY2 = ctParams.framePoint2Y*zoom_scale+ctParams.framePoint3Y*(1-zoom_scale);
                            if(isAboveLine(tempX1, tempY1, ctParams.framePoint4X, ctParams.framePoint4Y, ctParams.framePoint3X, ctParams.framePoint3Y)) {
                                tempX1 = ctParams.framePoint1X;
                                tempY1 = ctParams.framePoint1Y;
                                tempX2 = ctParams.framePoint2X;
                                tempY2 = ctParams.framePoint2Y;
                            }
                            if(getTwoPointsDist(tempX1, tempY1, ctParams.framePoint4X, ctParams.framePoint4Y) < ctParams.minDifference) {
                                tempX1 = ctParams.framePoint1X;
                                tempY1 = ctParams.framePoint1Y;
                                tempX2 = ctParams.framePoint2X;
                                tempY2 = ctParams.framePoint2Y;
                            }
                        }
                        else {
                            tempX1 = ctParams.framePoint1X;
                            tempY1 = ctParams.framePoint1Y;
                            tempX2 = ctParams.framePoint2X;
                            tempY2 = ctParams.framePoint2Y;
                        }
                        if(tempX1>=0&&tempX1<=640&&tempX2>=0&&tempX2<=640&&tempY1>=0&&tempY1<=480&&tempY2>=0&&tempY2<=480) {
                            ctParams.framePoint1X = tempX1;
                            ctParams.framePoint1Y = tempY1;
                            ctParams.framePoint2X = tempX2;
                            ctParams.framePoint2Y = tempY2;
                        }
                    }
                    /*
                    else if(edgeFlag == ctParams.operationPointThree) {
                        console.log("操作点3");
                        tempK = Infinity;
                        if(tempK === Infinity) {
                            tempX = temp1;
                            tempY = temp;
                            ctParams.framePoint2X = ctParams.framePoint2X + tempX;
                            ctParams.framePoint2Y = ctParams.framePoint2Y + tempY;
                            ctParams.framePoint1Y = ctParams.framePoint1Y + tempY;
                            ctParams.framePoint3X = ctParams.framePoint3X + tempX;
                        }
                    }
                    */
                    else if(edgeFlag == ctParams.operationPointFour){
                        if((0<=mod_angleAll&&mod_angleAll<Math.PI/4) || (Math.PI*7/4<=mod_angleAll&&mod_angleAll<Math.PI*2)) {
                            zoom_scale = (ctParams.curHorDistance+delta_x)/ctParams.curHorDistance;
                        }
                        else if(Math.PI/4<=mod_angleAll && mod_angleAll<Math.PI*3/4) {
                            zoom_scale = (ctParams.curHorDistance+delta_y)/ctParams.curHorDistance;
                        }
                        else if(Math.PI*3/4<=mod_angleAll && mod_angleAll<Math.PI*5/4) {
                            zoom_scale = (ctParams.curHorDistance-delta_x)/ctParams.curHorDistance;
                        }
                        else {
                            zoom_scale = (ctParams.curHorDistance-delta_y)/ctParams.curHorDistance;
                        }
                        if(zoom_scale>1 || ctParams.curHorDistance>ctParams.minDifference) {
                            tempX1 = ctParams.framePoint2X*zoom_scale+ctParams.framePoint1X*(1-zoom_scale);
                            tempY1 = ctParams.framePoint2Y*zoom_scale+ctParams.framePoint1Y*(1-zoom_scale);
                            tempX2 = ctParams.framePoint3X*zoom_scale+ctParams.framePoint4X*(1-zoom_scale);
                            tempY2 = ctParams.framePoint3Y*zoom_scale+ctParams.framePoint4Y*(1-zoom_scale);
                            if(isAboveLine(tempX1, tempY1, ctParams.framePoint1X, ctParams.framePoint1Y, ctParams.framePoint4X, ctParams.framePoint4Y)) {
                                tempX1 = ctParams.framePoint2X;
                                tempY1 = ctParams.framePoint2Y;
                                tempX2 = ctParams.framePoint3X;
                                tempY2 = ctParams.framePoint3Y;
                            }
                            if(getTwoPointsDist(tempX1, tempY1, ctParams.framePoint1X, ctParams.framePoint1Y) < ctParams.minDifference) {
                                tempX1 = ctParams.framePoint2X;
                                tempY1 = ctParams.framePoint2Y;
                                tempX2 = ctParams.framePoint3X;
                                tempY2 = ctParams.framePoint3Y;
                            }
                        }
                        else {
                            tempX1 = ctParams.framePoint2X;
                            tempY1 = ctParams.framePoint2Y;
                            tempX2 = ctParams.framePoint3X;
                            tempY2 = ctParams.framePoint3Y;
                        }

                        if(tempX1>=0&&tempX1<=640&&tempX2>=0&&tempX2<=640&&tempY1>=0&&tempY1<=480&&tempY2>=0&&tempY2<=480) {
                            ctParams.framePoint2X = tempX1;
                            ctParams.framePoint2Y = tempY1;
                            ctParams.framePoint3X = tempX2;
                            ctParams.framePoint3Y = tempY2;
                        }
                    }
                    /*
                    else if(edgeFlag == ctParams.operationPointFive) {
                        tempK = 0;
                        if(tempK === 0) {
                            tempX = temp1;
                            tempY = temp;
                            ctParams.framePoint3X = ctParams.framePoint3X + tempX;
                            ctParams.framePoint3Y = ctParams.framePoint3Y + tempY;
                            ctParams.framePoint2X = ctParams.framePoint2X + tempX;
                            ctParams.framePoint4Y = ctParams.framePoint4Y + tempY;
                        }

                    }
                    */
                    else if(edgeFlag == ctParams.operationPointSix){
                        if((0<=mod_angleAll&&mod_angleAll<Math.PI/4) || (Math.PI*7/4<=mod_angleAll&&mod_angleAll<Math.PI*2)) {
                            zoom_scale = (ctParams.curVerDistance+delta_y)/ctParams.curVerDistance;
                        }
                        else if(Math.PI/4<=mod_angleAll && mod_angleAll<Math.PI*3/4) {
                            zoom_scale = (ctParams.curVerDistance-delta_x)/ctParams.curVerDistance;
                        }
                        else if(Math.PI*3/4<=mod_angleAll && mod_angleAll<Math.PI*5/4) {
                            zoom_scale = (ctParams.curVerDistance-delta_y)/ctParams.curVerDistance;
                        }
                        else {
                            zoom_scale = (ctParams.curVerDistance+delta_x)/ctParams.curVerDistance;
                        }
                        if(zoom_scale>1 || ctParams.curVerDistance>ctParams.minDifference) {
                            tempX1 = ctParams.framePoint3X*zoom_scale+ctParams.framePoint2X*(1-zoom_scale);
                            tempY1 = ctParams.framePoint3Y*zoom_scale+ctParams.framePoint2Y*(1-zoom_scale);
                            tempX2 = ctParams.framePoint4X*zoom_scale+ctParams.framePoint1X*(1-zoom_scale);
                            tempY2 = ctParams.framePoint4Y*zoom_scale+ctParams.framePoint1Y*(1-zoom_scale);
                            if(!isAboveLine(tempX1, tempY1, ctParams.framePoint1X, ctParams.framePoint1Y, ctParams.framePoint2X, ctParams.framePoint2Y)) {
                                tempX1 = ctParams.framePoint3X;
                                tempY1 = ctParams.framePoint3Y;
                                tempX2 = ctParams.framePoint4X;
                                tempY2 = ctParams.framePoint4Y;
                            }
                            if(getTwoPointsDist(tempX1, tempY1, ctParams.framePoint2X, ctParams.framePoint2Y) < ctParams.minDifference) {
                                tempX1 = ctParams.framePoint3X;
                                tempY1 = ctParams.framePoint3Y;
                                tempX2 = ctParams.framePoint4X;
                                tempY2 = ctParams.framePoint4Y;
                            }
                        }
                        else {
                            tempX1 = ctParams.framePoint3X;
                            tempY1 = ctParams.framePoint3Y;
                            tempX2 = ctParams.framePoint4X;
                            tempY2 = ctParams.framePoint4Y;
                        }

                        if(tempX1>=0&&tempX1<=640&&tempX2>=0&&tempX2<=640&&tempY1>=0&&tempY1<=480&&tempY2>=0&&tempY2<=480) {
                            ctParams.framePoint3X = tempX1;
                            ctParams.framePoint3Y = tempY1;
                            ctParams.framePoint4X = tempX2;
                            ctParams.framePoint4Y = tempY2;
                        }
                    }
                    /*
                    else if(edgeFlag == ctParams.operationPointSeven) {
                        tempK = 0;
                        if(tempK === 0) {
                            tempX = temp1;
                            tempY = temp;
                            ctParams.framePoint4X = ctParams.framePoint4X + tempX;
                            ctParams.framePoint4Y = ctParams.framePoint4Y + tempY;
                            ctParams.framePoint1X = ctParams.framePoint1X + tempX;
                            ctParams.framePoint3Y = ctParams.framePoint3Y + tempY;
                        }

                    }
                    */
                    else if(edgeFlag == ctParams.operationPointEight){
                        if((0<=mod_angleAll&&mod_angleAll<Math.PI/4) || (Math.PI*7/4<=mod_angleAll&&mod_angleAll<Math.PI*2)) {
                            zoom_scale = (ctParams.curHorDistance-delta_x)/ctParams.curHorDistance;
                        }
                        else if(Math.PI/4<=mod_angleAll && mod_angleAll<Math.PI*3/4) {
                            zoom_scale = (ctParams.curHorDistance-delta_y)/ctParams.curHorDistance;
                        }
                        else if(Math.PI*3/4<=mod_angleAll && mod_angleAll<Math.PI*5/4) {
                            zoom_scale = (ctParams.curHorDistance+delta_x)/ctParams.curHorDistance;
                        }
                        else {
                            zoom_scale = (ctParams.curHorDistance+delta_y)/ctParams.curHorDistance;
                        }
                        if(zoom_scale>1 || ctParams.curHorDistance>ctParams.minDifference) {
                            tempX1 = ctParams.framePoint4X*zoom_scale+ctParams.framePoint3X*(1-zoom_scale);
                            tempY1 = ctParams.framePoint4Y*zoom_scale+ctParams.framePoint3Y*(1-zoom_scale);
                            tempX2 = ctParams.framePoint1X*zoom_scale+ctParams.framePoint2X*(1-zoom_scale);
                            tempY2 = ctParams.framePoint1Y*zoom_scale+ctParams.framePoint2Y*(1-zoom_scale);
                            if(!isAboveLine(tempX1, tempY1, ctParams.framePoint2X, ctParams.framePoint2Y, ctParams.framePoint3X, ctParams.framePoint3Y)) {
                                tempX1 = ctParams.framePoint4X;
                                tempY1 = ctParams.framePoint4Y;
                                tempX2 = ctParams.framePoint1X;
                                tempY2 = ctParams.framePoint1Y;
                            }
                            if(getTwoPointsDist(tempX1, tempY1, ctParams.framePoint3X, ctParams.framePoint3Y) < ctParams.minDifference) {
                                tempX1 = ctParams.framePoint4X;
                                tempY1 = ctParams.framePoint4Y;
                                tempX2 = ctParams.framePoint1X;
                                tempY2 = ctParams.framePoint1Y;
                            }
                        }
                        else {
                            tempX1 = ctParams.framePoint4X;
                            tempY1 = ctParams.framePoint4Y;
                            tempX2 = ctParams.framePoint1X;
                            tempY2 = ctParams.framePoint1Y;
                        }

                        if(tempX1>=0&&tempX1<=640&&tempX2>=0&&tempX2<=640&&tempY1>=0&&tempY1<=480&&tempY2>=0&&tempY2<=480) {
                            ctParams.framePoint4X = tempX1;
                            ctParams.framePoint4Y = tempY1;
                            ctParams.framePoint1X = tempX2;
                            ctParams.framePoint1Y = tempY2;
                        }
                    }
                    requestPaint();
                    settinguidata.resetHSV();
                }

                function paintColor(start,end,model){
                    switch(model){
                    case 0:
                        for(var i = start;i<end;i++){
                            imageData.data[dataArray[i]] = 255;
                            imageData.data[dataArray[i]+1] = 255;
                            imageData.data[dataArray[i]+2] = 255;
                            imageData.data[dataArray[i]+3] = 255;
                        }
                        requestPaint();
                        break;
                    case 1:
                        for(var j = start;j<end;j++){
                            imageData.data[dataArray[j]] = 0;
                            imageData.data[dataArray[j]+1] = 255;
                            imageData.data[dataArray[j]+2] = 0;
                            imageData.data[dataArray[j]+3] = 255;
                        }
                        requestPaint();
                        break;
                    }
                }

                function rollBack(){
                    if(underLabel >-1){
                        if(underLabel!=0){
                            var i = underLabel--;
                            var j = underLabel;
                            paintColor(labelArray[j],labelArray[i],1);
                        }else{
                            for(var k = 0; k<dataArray.length;k++){
                                imageData.data[dataArray[k]] = 0;
                                imageData.data[dataArray[k]+1] = 255;
                                imageData.data[dataArray[k]+2] = 0;
                                imageData.data[dataArray[k]+3] = 255;
                            }
                            requestPaint();
                            underLabel--;
                            console.log(underLabel);
                        }
                    }
                }

                function reverseRollBack(){
                    if(underLabel==-1){
                        for(var k = 0;k < labelArray[0];k++){
                            imageData.data[dataArray[k]] = 255;
                            imageData.data[dataArray[k]+1] = 255;
                            imageData.data[dataArray[k]+2] = 255;
                            imageData.data[dataArray[k]+3] = 255;
                        }
                    }
                    if(underLabel != labelArray.length-1 ){
                        var i = underLabel++;
                        var j = underLabel;
                        paintColor(labelArray[i],labelArray[j],0);
                    }
                }

                function reSet(){
                    for(var i = 0;i<dataArray.length;i++){

                        imageData.data[dataArray[i]] = 0;
                        imageData.data[dataArray[i]+1] = 255;
                        imageData.data[dataArray[i]+2] = 0;
                        imageData.data[dataArray[i]+3] = 255;
                    }
                    requestPaint();

                    while(labelArray.length!==0)
                        labelArray.pop();
                    while(dataArray.length!==0)
                        dataArray.pop();
                    while(tempArray.length!==0)
                        tempArray.pop();

                    underLabel = -1;
                }

                function getDragRect(x,y){
                    if(eraserRect.flag1==1&&eraserRect.flag2==1){

                        if(underLabel !=labelArray.length-1&&underLabel!=-1){
                            var count = labelArray[labelArray.length-1] - labelArray[underLabel];
                            for(var k = 0;k< count;k++)
                                dataArray.pop();
                            for(var j = labelArray.length-1; j>0&&labelArray[j]!==underLabel;j--)
                                labelArray.pop();
                        }

                        var  startPoint = y*background.width+x;
                        for(var colm = 0;  colm < eraserRect.height; colm ++){
                            for(var i = ( startPoint + colm*background.width) * 4; i<=(startPoint + eraserRect.width + colm*background.width) * 4; i+=4){
                                if(imageData.data[i+1]>200 && imageData.data[i]<200 && imageData.data[i+2]<200){
                                    tempArray.push(i);
                                }
                            }
                        }
                        //console.log(tempArray);
                    }
                }
            }
        }
    }
}
