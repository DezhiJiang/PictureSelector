#ifndef OPERATION_H
#define OPERATION_H

#include <QObject>
#include <QDir>
#include "xmloperation.h"
#include "parameter.h"
class Operation : public QObject
{
    Q_OBJECT

private:
    int pic_count;     //图片数量
    QString color;
    QStringList original_dirs;
    QStringList result_step1_dirs;         //步骤一、步骤二以及步骤三的结果文件夹地址,包括了原始图，仿真图以及两种算法的四种图
    QStringList result_step2_dirs;
    QStringList result_step3_dirs;
    QStringList original_image_name;       //原始图片的名字列表
    QStringList simulation_image_name;     //仿真图片的名字列表
    QStringList algorithm2_image_name;     //算法2图片的名字列表
    QStringList algorithm2_sim_image_name; //算法2仿真图片的名字列表
    QStringList algorithm3_image_name;     //算法2图片的名字列表
    QStringList algorithm3_sim_image_name; //算法2仿真图片的名字列表

    XMLOperation * xml_operation;          //xml的处理对象

    QStringList *all_image_source;       //所有图片的地址
    QStringList *all_simulation_image_source; //所有仿真图片的地址
    QString   all_color_dirs[9];         //所有原始图片的目录
    QString   all_simulation_color_dirs[9]; //所有仿真图片的目录
    int pic_count_sum;     //所有图片的总数


public:
    explicit Operation(QObject *parent = 0);
    ~Operation();

    Q_INVOKABLE void getAllImageSource();       //获得所有图片的源地址
    Q_INVOKABLE void getAllSimulationImageSource(); //获得所有仿真图片的源地址
    Q_INVOKABLE int getPic_count_sum() { return pic_count_sum; }  //获取图片总数
    Q_INVOKABLE QString getOriginalImageOfIndex(int index); //根据索引号获取原始图
    Q_INVOKABLE QString getSimulationImageOfIndex(int index); //根据索引号获取仿真图
    Q_INVOKABLE void createIndexFile(QString name,int step); //创建索引文件
    Q_INVOKABLE void writeIndexFile(QString name,int value,int step);  //修改索引文件
    Q_INVOKABLE int  readIndexFile(QString name,int step); //读取索引文件

    Q_INVOKABLE QString getPic_Folder(QString filepath);        //根据原始图片的地址获得该图片所在的目录
    Q_INVOKABLE void getOriginal_dirs(QString filepath);        //获取原始的目录列表
    Q_INVOKABLE QString getColorFromFilepath(QString filepath); //获取选中颜色的名字
    Q_INVOKABLE QString getCommonFilepath(QString filepath);    //获取公共路径
    Q_INVOKABLE int getPic_count();                             //获取当前目录下的图片总数
    Q_INVOKABLE void getOriginal_image_name(QString path);      //将选中的文件夹内的所有图片文件名存入QStringList中
    Q_INVOKABLE QString getOriginalPicpathOfIndex(int index);   //获取对应索引的原始图片文件路径
    Q_INVOKABLE void getSimulation_image_name(QString filepath);//获取仿真图片的名字列表
    Q_INVOKABLE QString getSimulationPicpathOfIndex(int index); //获取对应索引的仿真图片文件路径
    Q_INVOKABLE void getAlgorithm2_image_name(QString path);    //获取算法2图片的名字列表
    Q_INVOKABLE QString getAlgorithm2PicpathOfIndex(int index);     //获取对应索引的算法2图片文件路径
    Q_INVOKABLE void getAlgorithm3_image_name(QString path);        //获取算法3图片的名字列表
    Q_INVOKABLE QString getAlgorithm3PicpathOfIndex(int index);     //获取对应索引的算法3图片文件路径
    Q_INVOKABLE void getAlgorithm2_sim_image_name(QString path);    //获取算法2仿真图片的名字列表
    Q_INVOKABLE QString getAlgorithm2SimPicpathOfIndex(int index);  //获取对应索引的算法2仿真图片文件路径
    Q_INVOKABLE void getAlgorithm3_sim_image_name(QString path);    //获取算法3仿真图片的名字列表
    Q_INVOKABLE QString getAlgorithm3SimPicpathOfIndex(int index);  //获取对应索引的算法3仿真图片文件路径

    Q_INVOKABLE QString isExist_Algorithm2Pic(QString filepath);    //判断原始图片对应的算法二填充图是否存在，若存在，则返回文件地址，若不存在则返回字符串“inexistence”
    Q_INVOKABLE QString isExist_Algorithm3Pic(QString filepath);    //判断原始图片对应的算法三填充图是否存在，若存在，则返回文件地址，若不存在则返回字符串“inexistence”
    Q_INVOKABLE QString isExist_Algorithm2SimPic(QString filepath);    //判断原始图片对应的算法二仿真图是否存在，若存在，则返回文件地址，若不存在则返回字符串“inexistence”
    Q_INVOKABLE QString isExist_Algorithm3SimPic(QString filepath);    //判断原始图片对应的算法三仿真图是否存在，若存在，则返回文件地址，若不存在则返回字符串“inexistence”


    Q_INVOKABLE QString changeToSimulationFilename(QString filename); //根据原始图的名字获得仿真图的名字
    Q_INVOKABLE QString changeToAlgorithm2Filename(QString filename); //根据原始图的名字获得算法2图片的名字
    Q_INVOKABLE QString changeToAlgorithm2SimulationFilename(QString filename); //根据原始图的名字获得算法2仿真图片的名字
    Q_INVOKABLE QString changeToAlgorithm3Filename(QString filename); //根据原始图的名字获得算法3图片的名字
    Q_INVOKABLE QString changeToAlgorithm3SimulationFilename(QString filename); //根据原始图的名字获得算法2仿真图片的名字

    Q_INVOKABLE bool isDirExist(QString dirPath);     //判断目录是否存在，若不存在则创建
    Q_INVOKABLE void createResultDir(QString filepath,QString step,int steplevel); //创建一个结果目标目录
    Q_INVOKABLE void savePic_Selected(QString filepath,int steplevel,int savetype); //保存指定的文件,steplevel:1-step1,2-step2,3-step3;
    //savetype: 2-保存算法2的图片，3-保存算法3的图片，23-保存算法2和算法3的图片

    //step2新添加的函数
//    Q_INVOKABLE void createIndexFile2(QString name ); //创建索引文件
//    Q_INVOKABLE void writeIndexFile2(QString name,int value);  //修改索引文件
//    Q_INVOKABLE int  readIndexFile2(QString name); //读取索引文件


    XMLOperation* getXMLOperation();  //获得xml_operation对象

};

#endif // OPERATION_H
