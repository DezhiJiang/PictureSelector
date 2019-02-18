import QtQuick 2.0

Item {
    property int _ERASED_CONTOUR_RECT_COUNTS: 20

    /**
      * 鼠标位置
      * 附：矩形的有效区域：包括矩形内部、矩形边缘、矩形顶点、矩形旋转区域，
      *    旋转区域在各顶点对角线方向90度区域、1厘米正方形区域内
      */
    //1. 在矩形的有效区域外
    property int _IN_OUT_OF_EFFECTIVE_AREA    : 0;
    //2. 在矩形内部，不包括矩形边缘及矩形顶点
    property int _IN_RECTANGLE_INSIDE         : 1;
    //3. 在矩形边缘，横向拉伸操作点
    property int _IN_EDGE_HOR_STRETCH_POINT   : 2;
    //4. 在矩形边缘，纵向拉伸操作点
    property int _IN_EDGE_VER_STRETCH_POINT   : 3;
    //5. 在矩形顶点，正向对角线两顶点之一
    property int _IN_FORWARD_DIAGONAL_POINT   : 4;
    //6. 在矩形顶点，反向对角线两顶点之一
    property int _IN_BACKWARD_DIAGONAL_POINT  : 5;
    //7. 在旋转区域，左上角
    property int _IN_UPPER_LEFT_ROTATION_AREA : 6;
    //8. 在旋转区域，右上角
    property int _IN_UPPER_RIGHT_ROTATION_AREA: 7;
    //9. 在旋转区域，左下角
    property int _IN_BOTTOM_LEFT_ROTATION_AREA: 8;
    //10.在旋转区域，右下角
    property int _IN_BOTTON_RIGHT_ROTATION_AREA:9;

    /**
      * 轮廓方框顶点坐标
      */
    //1,2,3,4 方框的四个顶点坐标
    property double framePoint1X: 200;
    property double framePoint1Y: 200;
    property double framePoint2X: 400;
    property double framePoint2Y: 200;
    property double framePoint3X: 400;
    property double framePoint3Y: 400;
    property double framePoint4X: 200;
    property double framePoint4Y: 400;

    property double drawPoint1X : framePoint1X-1;
    property double drawPoint1Y : framePoint1Y-1;
    property double drawPoint2X : framePoint2X+1;
    property double drawPoint2Y : framePoint2Y-1;
    property double drawPoint3X : framePoint3X+1;
    property double drawPoint3Y : framePoint3Y+1;
    property double drawPoint4X : framePoint4X-1;
    property double drawPoint4Y : framePoint4Y+1;

    /**
      * 轮廓矩形的对立边的最小距离
      */
    property double minDifference : 20;

    property double initRotateLen: Math.sqrt((199-300)*(199-300)*2);

    /**
      * 旋转圆弧末端三角形的坐标
      *     *1
      *     *  \
      *     *   *3 及其翻转形状
      *     *  /
      *     *2
      */
    //操作点1的两个三角形初始坐标
    property double pt1Triangle1Pt1X: drawPoint1X;
    property double pt1Triangle1Pt1Y: drawPoint1Y-30-3;
    property double pt1Triangle1Pt2X: drawPoint1X;
    property double pt1Triangle1Pt2Y: drawPoint1Y-30+3;
    property double pt1Triangle1Pt3X: drawPoint1X+3*Math.sqrt(3);
    property double pt1Triangle1Pt3Y: drawPoint1Y-30;
    property double pt1Triangle2Pt1X: drawPoint1X-30-3;
    property double pt1Triangle2Pt1Y: drawPoint1Y;
    property double pt1Triangle2Pt2X: drawPoint1X-30+3;
    property double pt1Triangle2Pt2Y: drawPoint1Y;
    property double pt1Triangle2Pt3X: drawPoint1X-30;
    property double pt1Triangle2Pt3Y: drawPoint1Y+3*Math.sqrt(3);

    /**
      * 操作点序号
        //*1-------*2-------*3
        //|                  |
        //|                  |
        //*8                *4
        //|                  |
        //|                  |
        //*7-------*6-------*5
      */
    property int operationPointOne  : 1
    property int operationPointTwo  : 2
    property int operationPointThree: 3
    property int operationPointFour : 4
    property int operationPointFive : 5
    property int operationPointSix  : 6
    property int operationPointSeven: 7
    property int operationPointEight: 8

    /**
      * 上一次拉伸距离
      */
    property double prevHorDistance: 0;
    property double prevVerDistance: 0;
    /**
      * 当前拉伸距离
      */
    property double curHorDistance:  getTwoPointsDist(ctParams.framePoint1X, ctParams.framePoint1Y,
                                                      ctParams.framePoint2X, ctParams.framePoint2Y);
    property double curVerDistance:  getTwoPointsDist(ctParams.framePoint1X, ctParams.framePoint1Y,
                                                      ctParams.framePoint4X, ctParams.framePoint4Y);

    /**
      * 旋转区域半径
      */
    property double rotationRadius: 30

    /**
      * 操作点圆形半径
      */
    property int operatePointRadius : 10;

    /**
      * 轮廓精度值
      */
    property int _LOW_PRECISION: 0;
    property int _MID_PRECISION: 1;
    property int _HIGH_PRECISION: 2;

    /**
      * 轮廓左上角旋转区域初始坐标
      */
    property double _UPPER_LEFT_ROTATION_AREA_PT1X: drawPoint1X-45;
    property double _UPPER_LEFT_ROTATION_AREA_PT1Y: drawPoint1Y;
    property double _UPPER_LEFT_ROTATION_AREA_PT2X: drawPoint1X;
    property double _UPPER_LEFT_ROTATION_AREA_PT2Y: drawPoint1Y-45;
    property double _UPPER_LEFT_ROTATION_AREA_PT3X: drawPoint1X-45;
    property double _UPPER_LEFT_ROTATION_AREA_PT3Y: drawPoint1Y-45;

    /**
      * 橡皮擦大小
      */
    property int _ERASER_SIZE: 30

    function resetFramePoints() {
        framePoint1X = 200;
        framePoint1Y = 200;
        framePoint2X = 400;
        framePoint2Y = 200;
        framePoint3X = 400;
        framePoint3Y = 400;
        framePoint4X = 200;
        framePoint4Y = 400;
    }

    function setDrawPoints() {
        drawPoint1X = framePoint1X-1;
        drawPoint1Y = framePoint1Y-1;
        drawPoint2X = framePoint2X+1;
        drawPoint2Y = framePoint2Y-1;
        drawPoint3X = framePoint3X+1;
        drawPoint3Y = framePoint3Y+1;
        drawPoint4X = framePoint4X-1;
        drawPoint4Y = framePoint4Y+1;
    }

    function setRotationTrianglePos() {
        pt1Triangle1Pt1X = drawPoint1X;
        pt1Triangle1Pt1Y = drawPoint1Y-30-3;
        pt1Triangle1Pt2X = drawPoint1X;
        pt1Triangle1Pt2Y = drawPoint1Y-30+3;
        pt1Triangle1Pt3X = drawPoint1X+3*Math.sqrt(3);
        pt1Triangle1Pt3Y = drawPoint1Y-30;
        pt1Triangle2Pt1X = drawPoint1X-30-3;
        pt1Triangle2Pt1Y = drawPoint1Y;
        pt1Triangle2Pt2X = drawPoint1X-30+3;
        pt1Triangle2Pt2Y = drawPoint1Y;
        pt1Triangle2Pt3X = drawPoint1X-30;
        pt1Triangle2Pt3Y = drawPoint1Y+3*Math.sqrt(3);

    }

    function setRotationAreaPos() {
        _UPPER_LEFT_ROTATION_AREA_PT1X = drawPoint1X-45;
        _UPPER_LEFT_ROTATION_AREA_PT1Y = drawPoint1Y;
        _UPPER_LEFT_ROTATION_AREA_PT2X = drawPoint1X;
        _UPPER_LEFT_ROTATION_AREA_PT2Y = drawPoint1Y-45;
        _UPPER_LEFT_ROTATION_AREA_PT3X = drawPoint1X-45;
        _UPPER_LEFT_ROTATION_AREA_PT3Y = drawPoint1Y-45;
    }

    function getTwoPointsDist(x1,y1,x2,y2) {
        return Math.sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
    }
}
