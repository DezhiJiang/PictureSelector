#ifndef XMLOPERATION_H
#define XMLOPERATION_H

#include <QObject>
#include <QtCore>
//#include <QtXml/QtXml>
#include <QDebug>
#include <QFile>
#include "parameter.h"
#include <QDomDocument>
#include "qtextcodec.h"

class XMLOperation : public QObject
{
    Q_OBJECT

private:
    int index = 0;     //图片的索引标记
    int step2_xml_is_end=0; //用来标记步骤二xml文件已读取完毕的标志位
    int step3_xml_is_end=0; //用来标记步骤三xml文件已读取完毕的标志位

    QDomNode node;     //用来遍历的节点
    QDomElement root;  //根节点
    Pic_Parameter* pic_data; //当前的节点数据
    QString filename ;  //xml文件的路径

    int bounding_box_count = 0;  //boundingbox的数量
    double x[8];   //画bounding_box需要的四个参数
    double y[8];
    double l[8];
    double w[8];

    //步骤二需要的变量
    double proportion;

    //读取合并的xml需要的变量
    int combine_index = 0;         //合并xml文件中的图片索引
    QDomNode read_combine_node;     //用来遍历的合并文件节点
    QDomElement read_combine_root;  //合并文件根节点
    Combine_Parameter* read_combine_pic_data; //合并文件中当前读取的节点数据


    //合并xml的共用变量
    QStringList  xml_list;     //选中目录下的xml文件集
    int xml_count;             //选中目录下的xml数目
    QList<QDomNode> combine_nodes;     //合并时使用的节点
    QList<QDomElement> combine_roots;  //合并时使用的根节点
    QString combine_filename ;        //合并的xml文件的路径
    //合并第一步的xml需要的变量
    Pic_Parameter *current_node;     //当前读取的节点数据
    Pic_Parameter *combine_node;     //合并的节点数据
    int image[400][300];             //图片的大小固定为400*300，申请一个数组代表图片的每一个像素，
                                     //将boundingbox中的像素点的值置为1，否则为0，最后进行统计

    //合并第二步的xml需要的变量
    Combine_Parameter *current_node2; //当前读取的节点数据
    Combine_Parameter *combine_node2;     //合并的节点数据

    //统计信息
    int step1_result_count;
    int step2_result_count;
    int step3_result_count;

public:
    explicit XMLOperation(QObject *parent = 0);
    ~XMLOperation();

    //步骤二涉及的特有函数
    Q_INVOKABLE void defaultstep2_xml_is_end() { step2_xml_is_end = 0; }  //将用于判断step2xml文件是否读取完毕的标志为置位
    Q_INVOKABLE void defaultstep3_xml_is_end() { step3_xml_is_end = 0; }  //将用于判断step2xml文件是否读取完毕的标志为置位


    Q_INVOKABLE void setIndex(int value);      //设置图片索引号
    Q_INVOKABLE void setFileName(QString name,int step);   //设置保存的xml的路径以及文件名，参数为筛选者的名字
    Q_INVOKABLE void create_xml(QString name,int step);    //创建一个xml，只含根节点
    //往XML中添加一个图片节点
    Q_INVOKABLE void add_xmlnode(QString origin_path,int original_save,int algorithm2_save,int algorithm3_save);
    Q_INVOKABLE void getFistNodeData(QString filepath);  //获得XML文件中第一个图片节点的数据
    Q_INVOKABLE void getNextNodeData();  //获得下一个图片节点的数据
    Q_INVOKABLE QString getCurrentOriginPath();

    //读取合并xml公用的函数
    Q_INVOKABLE QString getCurrentCombineOriginPath(); //读取当前的原始图路径
    Q_INVOKABLE double  getCurrentProportion();   //获取当前的色盲占比
    Q_INVOKABLE int getNodeCountsOfXML(QString filepath);   //获取合并XML中的节点总数

    //步骤二读取合并的xml需要的操作
    Q_INVOKABLE void getFirstNodeFromCombineXML(QString filepath); //从合并的结果xml中读取一个节点
    Q_INVOKABLE void getNextNodeFromCombineXML(); //从合并的结果xml中读取下一个节点
    Q_INVOKABLE QString getOriginOfIndexFromXML(QString filepath,int index); //从一个xml中读取给定索引号的图片


    //步骤三读取合并的xml需要的操作
    Q_INVOKABLE void getFirstNodeFromCombineXML_step3(QString filepath); //从合并的结果xml中读取一个节点
    Q_INVOKABLE void getNextNodeFromCombineXML_step3(); //从合并的结果xml中读取下一个节点
    Q_INVOKABLE QString getOriginOfIndexFromXML_step3(QString filepath,int index); //从一个xml中读取给定索引号的图片

    //关于boundingbox的一些操作
    Q_INVOKABLE int getBoundingBoxCount();   //获取boundingbox的数目
    Q_INVOKABLE void setBoundingBoxCount(int value);
    Q_INVOKABLE void setStart_XOfIndex(int index,double value);
    Q_INVOKABLE void setStart_YOfIndex(int index,double value);
    Q_INVOKABLE void setLengthOfIndex(int index,double value);
    Q_INVOKABLE void setWidthOfIndex(int index,double value);
    Q_INVOKABLE double getStart_XOfIndex(int index);
    Q_INVOKABLE double getStart_YOfIndex(int index);
    Q_INVOKABLE double getLengthOfIndex(int index);
    Q_INVOKABLE double getWidthOfIndex(int index);
    Q_INVOKABLE double* getStart_X();
    Q_INVOKABLE double* getStart_Y();
    Q_INVOKABLE double* getLength();
    Q_INVOKABLE double* getWidth();

    //合并步骤一xml需要的操作
    Q_INVOKABLE void getXMLFilefromDir(QString filepath);   //获取选中目录下的xml文件
    Q_INVOKABLE void create_combinexml(int step);      //创建一个合并结果的xml文件
    Q_INVOKABLE void combineXMLFilefromDir(QString filepath,int stepvalue); //对选中的xml文件进行合并
    Q_INVOKABLE Pic_Parameter* getFistNodeData_C1(QString filepath,int index); //从一个xml文件中获取第一个节点并返回
    Q_INVOKABLE Pic_Parameter* getNextNodeData_C1(int index);  //获取下一个节点并返回
    Q_INVOKABLE void add_step1_xmlcombinenode(Combine_Parameter* combine_result);
    Q_INVOKABLE void combine1();

    //合并步骤二xml需要的操作
    Q_INVOKABLE Combine_Parameter* getFirstNodeData_C2(QString filepath,int index);
    Q_INVOKABLE Combine_Parameter* getNextNodeData_C2(int index);
    Q_INVOKABLE void combine2();


    //读取合并的统计的信息
    Q_INVOKABLE int getStep1_result_count() { return step1_result_count; }
    Q_INVOKABLE int getStep2_result_count() { return step2_result_count; }
    Q_INVOKABLE int getStep3_result_count() { return step3_result_count; }



signals:
    void xmlfileEnds();       //当前xml文件已经读完的信号
    void step2_xmlfileEnds(); //step2中用于筛选的合并xml读取完毕
    void step3_xmlfileEnds(); //step3中用于筛选的合并xml读取完毕
    void combineSucceed();    //xml合并成功信号

};

#endif // XMLOPERATION_H
