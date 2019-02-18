#include "operation.h"
#include <QDebug>

#include <iostream>

using std::cout;
using std::endl;

Operation::Operation(QObject *parent):QObject(parent){
    xml_operation = new XMLOperation();
    all_image_source = new QStringList;
    all_simulation_image_source = new QStringList;

    all_color_dirs[0] = "D:/色盲数据整理文件/data/橙黄色/";
    all_color_dirs[1] = "D:/色盲数据整理文件/data/淡蓝浅紫/";
    all_color_dirs[2] = "D:/色盲数据整理文件/data/红黄绿/";
    all_color_dirs[3] = "D:/色盲数据整理文件/data/红蓝黑/";
    all_color_dirs[4] = "D:/色盲数据整理文件/data/红绿色/";
    all_color_dirs[5] = "D:/色盲数据整理文件/data/黄绿色/";
    all_color_dirs[6] = "D:/色盲数据整理文件/data/蓝紫色/";
    all_color_dirs[7] = "D:/色盲数据整理文件/data/墨绿色/";
    all_color_dirs[8] = "D:/色盲数据整理文件/data/桃粉绿/";

    all_simulation_color_dirs[0] = "D:/色盲数据整理文件/simulation/橙黄色/";
    all_simulation_color_dirs[1] = "D:/色盲数据整理文件/simulation/淡蓝浅紫/";
    all_simulation_color_dirs[2] = "D:/色盲数据整理文件/simulation/红黄绿/";
    all_simulation_color_dirs[3] = "D:/色盲数据整理文件/simulation/红蓝黑/";
    all_simulation_color_dirs[4] = "D:/色盲数据整理文件/simulation/红绿色/";
    all_simulation_color_dirs[5] = "D:/色盲数据整理文件/simulation/黄绿色/";
    all_simulation_color_dirs[6] = "D:/色盲数据整理文件/simulation/蓝紫色/";
    all_simulation_color_dirs[7] = "D:/色盲数据整理文件/simulation/墨绿色/";
    all_simulation_color_dirs[8] = "D:/色盲数据整理文件/simulation/桃粉绿/";

}

Operation::~Operation(){

}

void Operation::getAllImageSource()
{
    //先清空一下列表
    all_image_source->clear();
    pic_count_sum = 0;

    for(int i=0; i< 9; i++){

        QDir dir(all_color_dirs[i]);
        if(!dir.exists()){
            qDebug()<<all_color_dirs[i]<<" is not exist!";
            return;
        }
        //查看路径中后缀为.jpg和.png格式的文件
        QStringList filters;
        filters<<QString("*.jpg")<<QString("*.png");
        dir.setFilter(QDir::Files | QDir::NoSymLinks); //设置类型过滤器，只为文件格式
        dir.setNameFilters(filters);  //设置文件名称过滤器，只为filters格式

        //统计格式的文件个数
        int dir_count = dir.count();
        if(dir_count <= 0)
            return;
        pic_count_sum += dir_count;

        for(int j=0; j<dir_count; j++)
        {
            QString file_name = "file:///" + all_color_dirs[i] + dir[j];  //文件名称
            //qDebug()<<file_name;
            all_image_source->append(file_name);
        }
    }
    qDebug()<<" pic_count_sum = "<< pic_count_sum;
    return ;
}

void Operation::getAllSimulationImageSource()
{
    //先清空一下列表
    all_simulation_image_source->clear();

    for(int i=0; i< 9; i++){

        QDir dir(all_simulation_color_dirs[i]);
        if(!dir.exists()){
            qDebug()<<all_simulation_color_dirs[i]<<" is not exist!";
            return;
        }
        //查看路径中后缀为.jpg和.png格式的文件
        QStringList filters;
        filters<<QString("*.jpg")<<QString("*.png");
        dir.setFilter(QDir::Files | QDir::NoSymLinks); //设置类型过滤器，只为文件格式
        dir.setNameFilters(filters);  //设置文件名称过滤器，只为filters格式

        //统计格式的文件个数
        int dir_count = dir.count();
        if(dir_count <= 0)
            return;

        for(int j=0; j<dir_count; j++)
        {
            QString file_name = "file:///" + all_simulation_color_dirs[i] + dir[j];  //文件名称
            //qDebug()<<file_name;
            all_simulation_image_source->append(file_name);
        }
    }
    return ;
}

QString Operation::getOriginalImageOfIndex(int index)
{
    return all_image_source->at(index);
}

QString Operation::getSimulationImageOfIndex(int index)
{
    return all_simulation_image_source->at(index);
}

void Operation::createIndexFile(QString name,int step)
{
    QString filename;
    switch(step){
    case 1:
        filename = "D:/色盲数据整理文件/step1_result_xml/"+name+"_index_file.txt";
        break;
    case 2:
        filename = "D:/色盲数据整理文件/step2_result_xml/"+name+"_index_file.txt";
        break;
    case 3:
        filename = "D:/色盲数据整理文件/step3_result_xml/"+name+"_index_file.txt";
        break;
    default:
        qDebug()<<"filename is wrong!";
        break;
    }

    //QString filename = "D:/色盲数据整理文件/step1_result_xml/"+name+"_index_file.txt";
    QFileInfo xmlfile(filename);
    if(!xmlfile.isFile()){
        QFile file(filename);
        file.open(QIODevice::ReadWrite);
        //创建新的索引文件时，初始化为0
        QTextStream in(&file);
        in<<0;
        //doc.save(out,4);
        file.close();
    }else{
        qDebug()<<"file:"<<filename<<" is exist.";
    }
}

void Operation::writeIndexFile(QString name, int value,int step)
{
    QString filename;
    switch(step){
    case 1:
        filename = "D:/色盲数据整理文件/step1_result_xml/"+name+"_index_file.txt";
        break;
    case 2:
        filename = "D:/色盲数据整理文件/step2_result_xml/"+name+"_index_file.txt";
        break;
    case 3:
        filename = "D:/色盲数据整理文件/step3_result_xml/"+name+"_index_file.txt";
        break;
    default:
        qDebug()<<"filename is wrong!";
        break;
    }
    //QString filename = "D:/色盲数据整理文件/step1_result_xml/"+name+"_index_file.txt";

    QFile file(filename);
    file.open(QIODevice::ReadWrite);
    //创建新的索引文件时，初始化为0
    QTextStream in(&file);
    in<<value;
    //doc.save(out,4);
    file.close();
}

int Operation::readIndexFile(QString name,int step)
{
    QString filename;
    switch(step){
    case 1:
        filename = "D:/色盲数据整理文件/step1_result_xml/"+name+"_index_file.txt";
        break;
    case 2:
        filename = "D:/色盲数据整理文件/step2_result_xml/"+name+"_index_file.txt";
        break;
    case 3:
        filename = "D:/色盲数据整理文件/step3_result_xml/"+name+"_index_file.txt";
        break;
    default:
        qDebug()<<"filename is wrong!";
        break;
    }

    //QString filename = "D:/色盲数据整理文件/step1_result_xml/"+name+"_index_file.txt";

    QFile file(filename);
    file.open(QIODevice::ReadOnly | QIODevice::Text);

    QTextStream in(&file);
    QString line = in.readLine();
    bool ok;
    int index = line.toInt(&ok,10);

    qDebug()<<"index = "<<index;
    file.close();
    return index;
}

QString Operation::getPic_Folder(QString filepath)
{
    int position;
    QString folder;

    for(int i = 0; i!= filepath.length(); ++i){
        if(filepath[i]=='/'){
            position = i;
        }
    }

    folder = filepath.left(position);

    qDebug()<<"folder = "<<folder;

    return folder;
}

void Operation::getOriginal_dirs(QString filepath)
{
    //清楚原先的列表
    original_dirs.clear();

    QString commonpath, colorname;
    commonpath = getCommonFilepath(filepath);

    if(commonpath.left(8)=="file:///"){
        commonpath = commonpath.mid(8);
    }

    colorname = getColorFromFilepath(filepath);
    QString dirpath_original = commonpath + "data/" +colorname+"/";
    QString dirpath_simulation = commonpath + "simulation/" +colorname+"/";
    QString dirpath_algorithm2 = commonpath + "algorithm2/" +colorname+"/";
    QString dirpath_algorithm2_simulation = commonpath + "algorithm2_simulation/" +colorname+"/";
    QString dirpath_algorithm3 = commonpath + "algorithm3/" +colorname+"/";
    QString dirpath_algorithm3_simulation = commonpath + "algorithm3_simulation/" +colorname+"/";

    //qDebug()<< "dirpath_original"<<dirpath_original;

    original_dirs.append(dirpath_original);
    original_dirs.append(dirpath_simulation);
    original_dirs.append(dirpath_algorithm2);
    original_dirs.append(dirpath_algorithm2_simulation);
    original_dirs.append(dirpath_algorithm3);
    original_dirs.append(dirpath_algorithm3_simulation);

}

QString Operation::getColorFromFilepath(QString filepath)
{
    int position;    //最后一次出现‘/’的位置
    int colorlength; //颜色名字的字符长度
    QString colorname;

    for(int i = 0; i!= filepath.length(); ++i){
        if(filepath[i]=='/'){
            position = i;
        }
    }

    colorlength = filepath.length()-position;

    colorname = filepath.right(colorlength-1);
    //qDebug()<<colorname;

    return colorname;
}

QString Operation::getCommonFilepath(QString filepath)
{
    int position;
    QString commonfilepath;

    for(int i = 0; i!= filepath.length(); ++i){
        if(filepath[i]=='/'){
            position = i;
        }
    }

    commonfilepath = filepath.left(position-4);

    //qDebug()<<commonfilepath;

    return commonfilepath;
}

int Operation::getPic_count()
{
    return original_image_name.count();
}

void Operation::getOriginal_image_name(QString path)
{
    //清空原先的列表
    original_image_name.clear();

    //去掉路径中的头缀 “file:///”
    QString finaldirpath = path;

    if(path.left(8)=="file:///"){
        finaldirpath = path.mid(8);
        //qDebug()<<finaldirpath;
    }

    //判断路径是否存在
    QDir dir(finaldirpath);
    if(!dir.exists())
        return;

    //查看路径中后缀为.jpg和.png格式的文件
    QStringList filters;
    filters<<QString("*.jpg")<<QString("*.png");
    dir.setFilter(QDir::Files | QDir::NoSymLinks); //设置类型过滤器，只为文件格式
    dir.setNameFilters(filters);  //设置文件名称过滤器，只为filters格式

    //统计格式的文件个数
    int dir_count = dir.count();
    if(dir_count <= 0)
        return;


    //存储文件名称
   // QStringList string_list;
    for(int i=0; i<dir_count; i++)
    {
        QString file_name =path + dir[i];  //文件名称
        //ts<<file_name<<"\r\n"<<"\r\n";
        //qDebug()<<file_name;
        original_image_name.append(file_name);
    }
    return ;
}

QString Operation::getOriginalPicpathOfIndex(int index){

    return original_image_name.at(index);
}

void Operation::getSimulation_image_name(QString filepath)
{
    //清空原先的列表
    simulation_image_name.clear();

    QString commonpath, dirpath , colorname;

    commonpath = getCommonFilepath(filepath);
    colorname = getColorFromFilepath(filepath);
    dirpath = commonpath + "simulation/"+colorname+"/";
    if(dirpath.left(8)=="file:///"){
        dirpath = dirpath.mid(8);
        //qDebug()<<dirpath;
    }

    //判断路径是否存在
    QDir dir(dirpath);
    if(!dir.exists())
        return;

    //查看路径中后缀为.jpg和.png格式的文件
    QStringList filters;
    filters<<QString("*.jpg")<<QString("*.png");
    dir.setFilter(QDir::Files | QDir::NoSymLinks); //设置类型过滤器，只为文件格式
    dir.setNameFilters(filters);  //设置文件名称过滤器，只为filters格式

    //统计格式的文件个数
    int dir_count = dir.count();
    if(dir_count <= 0)
        return;

    //存储文件名称
    for(int i=0; i<dir_count; i++)
    {
        QString file_name ="file:///" + dirpath + dir[i];  //文件名称
        //ts<<file_name<<"\r\n"<<"\r\n";
        //qDebug()<<file_name;
        simulation_image_name.append(file_name);
    }
    return ;
}

QString Operation::getSimulationPicpathOfIndex(int index)
{
    return simulation_image_name.at(index);
}

void Operation::getAlgorithm2_image_name(QString filepath)
{
    //清空原先的列表
    algorithm2_image_name.clear();

    QString commonpath, dirpath , colorname;

    commonpath = getCommonFilepath(filepath);
    colorname = getColorFromFilepath(filepath);
    dirpath = commonpath + "algorithm2/"+colorname+"/";
    if(dirpath.left(8)=="file:///"){
        dirpath = dirpath.mid(8);
        //qDebug()<<dirpath;
    }

    //判断路径是否存在
    QDir dir(dirpath);
    if(!dir.exists())
        return;

    //查看路径中后缀为.jpg和.png格式的文件
    QStringList filters;
    filters<<QString("*.jpg")<<QString("*.png");
    dir.setFilter(QDir::Files | QDir::NoSymLinks); //设置类型过滤器，只为文件格式
    dir.setNameFilters(filters);  //设置文件名称过滤器，只为filters格式

    //统计格式的文件个数
    int dir_count = dir.count();
    if(dir_count <= 0)
        return;

    //存储文件名称
    for(int i=0; i<dir_count; i++)
    {
        QString file_name ="file:///" + dirpath + dir[i];  //文件名称
        //ts<<file_name<<"\r\n"<<"\r\n";
        //qDebug()<<file_name;
        algorithm2_image_name.append(file_name);
    }
    return ;
}

QString Operation::getAlgorithm2PicpathOfIndex(int index)
{
    return algorithm2_image_name.at(index);
}

void Operation::getAlgorithm3_image_name(QString filepath)
{
    //清空原先的列表
    algorithm3_image_name.clear();

    QString commonpath, dirpath , colorname;

    commonpath = getCommonFilepath(filepath);
    colorname = getColorFromFilepath(filepath);
    dirpath = commonpath + "algorithm3/"+colorname+"/";
    if(dirpath.left(8)=="file:///"){
        dirpath = dirpath.mid(8);
        //qDebug()<<dirpath;
    }

    //判断路径是否存在
    QDir dir(dirpath);
    if(!dir.exists())
        return;

    //查看路径中后缀为.jpg和.png格式的文件
    QStringList filters;
    filters<<QString("*.jpg")<<QString("*.png");
    dir.setFilter(QDir::Files | QDir::NoSymLinks); //设置类型过滤器，只为文件格式
    dir.setNameFilters(filters);  //设置文件名称过滤器，只为filters格式

    //统计格式的文件个数
    int dir_count = dir.count();
    if(dir_count <= 0)
        return;

    //存储文件名称
    for(int i=0; i<dir_count; i++)
    {
        QString file_name ="file:///" + dirpath + dir[i];  //文件名称
        //ts<<file_name<<"\r\n"<<"\r\n";
        //qDebug()<<file_name;
        algorithm3_image_name.append(file_name);
    }
    return ;
}

QString Operation::getAlgorithm3PicpathOfIndex(int index)
{
    return algorithm3_image_name.at(index);
}

void Operation::getAlgorithm2_sim_image_name(QString filepath)
{
    //清空原先的列表
    algorithm2_sim_image_name.clear();

    QString commonpath, dirpath , colorname;

    commonpath = getCommonFilepath(filepath);
    colorname = getColorFromFilepath(filepath);
    dirpath = commonpath + "algorithm2_simulation/"+colorname+"/";
    if(dirpath.left(8)=="file:///"){
        dirpath = dirpath.mid(8);
        //qDebug()<<dirpath;
    }

    //判断路径是否存在
    QDir dir(dirpath);
    if(!dir.exists())
        return;

    //查看路径中后缀为.jpg和.png格式的文件
    QStringList filters;
    filters<<QString("*.jpg")<<QString("*.png");
    dir.setFilter(QDir::Files | QDir::NoSymLinks); //设置类型过滤器，只为文件格式
    dir.setNameFilters(filters);  //设置文件名称过滤器，只为filters格式

    //统计格式的文件个数
    int dir_count = dir.count();
    if(dir_count <= 0)
        return;

    //存储文件名称
    for(int i=0; i<dir_count; i++)
    {
        QString file_name ="file:///" + dirpath + dir[i];  //文件名称
        //ts<<file_name<<"\r\n"<<"\r\n";
        //qDebug()<<file_name;
        algorithm2_sim_image_name.append(file_name);
    }
    return ;
}

QString Operation::getAlgorithm2SimPicpathOfIndex(int index)
{
    return algorithm2_sim_image_name.at(index);
}

void Operation::getAlgorithm3_sim_image_name(QString filepath)
{
    //清空原先的列表
    algorithm3_sim_image_name.clear();

    QString commonpath, dirpath , colorname;

    commonpath = getCommonFilepath(filepath);
    colorname = getColorFromFilepath(filepath);
    dirpath = commonpath + "algorithm3_simulation/"+colorname+"/";
    if(dirpath.left(8)=="file:///"){
        dirpath = dirpath.mid(8);
        //qDebug()<<dirpath;
    }

    //判断路径是否存在
    QDir dir(dirpath);
    if(!dir.exists())
        return;

    //查看路径中后缀为.jpg和.png格式的文件
    QStringList filters;
    filters<<QString("*.jpg")<<QString("*.png");
    dir.setFilter(QDir::Files | QDir::NoSymLinks); //设置类型过滤器，只为文件格式
    dir.setNameFilters(filters);  //设置文件名称过滤器，只为filters格式

    //统计格式的文件个数
    int dir_count = dir.count();
    if(dir_count <= 0)
        return;

    //存储文件名称
    for(int i=0; i<dir_count; i++)
    {
        QString file_name ="file:///" + dirpath + dir[i];  //文件名称
        //ts<<file_name<<"\r\n"<<"\r\n";
        //qDebug()<<file_name;
        algorithm3_sim_image_name.append(file_name);
    }
    return ;
}

QString Operation::getAlgorithm3SimPicpathOfIndex(int index)
{
    return algorithm3_sim_image_name.at(index);
}

QString Operation::isExist_Algorithm2Pic(QString filepath)
{
    if(filepath.left(8)=="file:///"){
        filepath = filepath.mid(8);
        //qDebug()<<commonpath;
    }
    QFileInfo file(filepath);
    QString filename,sourcefile;
    filename = file.fileName();

    QString algorithm2_filename = changeToAlgorithm2Filename(filename);

    sourcefile = original_dirs.at(2)+algorithm2_filename;
    qDebug()<<"sourcefile = "<<sourcefile;
    QFileInfo fileInfo(sourcefile);
    if(fileInfo.isFile()){
        return sourcefile;
    }else{
        return "inexistence";
    }

}

QString Operation::isExist_Algorithm3Pic(QString filepath)
{
    if(filepath.left(8)=="file:///"){
        filepath = filepath.mid(8);
        //qDebug()<<commonpath;
    }
    QFileInfo file(filepath);
    QString filename,sourcefile;
    filename = file.fileName();

    QString algorithm3_filename = changeToAlgorithm3Filename(filename);

    sourcefile = original_dirs.at(4)+algorithm3_filename;
    //qDebug()<<"sourcefile = "<<sourcefile;
    QFileInfo fileInfo(sourcefile);
    if(fileInfo.isFile()){
        return sourcefile;
    }else{
        return "inexistence";
    }
}

QString Operation::isExist_Algorithm2SimPic(QString filepath)
{
    if(filepath.left(8)=="file:///"){
        filepath = filepath.mid(8);
        //qDebug()<<commonpath;
    }
    QFileInfo file(filepath);
    QString filename,sourcefile;
    filename = file.fileName();

    QString algorithm2_sim_filename = changeToAlgorithm2SimulationFilename(filename);

    sourcefile = original_dirs.at(3)+algorithm2_sim_filename;
    //qDebug()<<"sourcefile = "<<sourcefile;
    QFileInfo fileInfo(sourcefile);
    if(fileInfo.isFile()){
        return sourcefile;
    }else{
        return "inexistence";
    }
}

QString Operation::isExist_Algorithm3SimPic(QString filepath)
{
    if(filepath.left(8)=="file:///"){
        filepath = filepath.mid(8);
        //qDebug()<<commonpath;
    }
    QFileInfo file(filepath);
    QString filename,sourcefile;
    filename = file.fileName();

    QString algorithm3_sim_filename = changeToAlgorithm3SimulationFilename(filename);

    sourcefile = original_dirs.at(5)+algorithm3_sim_filename;
    //qDebug()<<"sourcefile = "<<sourcefile;
    QFileInfo fileInfo(sourcefile);
    if(fileInfo.isFile()){
        return sourcefile;
    }else{
        return "inexistence";
    }
}

QString Operation::changeToSimulationFilename(QString filename)
{
    QString simulation_filename;
    QStringList temp = filename.split('.');
    simulation_filename = temp.at(0)+"_sim_Protanopia"+"."+temp.at(1);
    //qDebug()<<simulation_filename;

    return simulation_filename;
}

QString Operation::changeToAlgorithm2Filename(QString filename)
{
    QString algorithm2_filename;
    QStringList temp = filename.split('.');
    algorithm2_filename = temp.at(0)+"_algorithm2_Protanopia"+"."+temp.at(1);
    //qDebug()<<algorithm2_filename;

    return algorithm2_filename;
}

QString Operation::changeToAlgorithm2SimulationFilename(QString filename){
    QString algorithm2_simulation_filename;
    QStringList temp = filename.split('.');
    algorithm2_simulation_filename = temp.at(0)+"_algorithm2Sim_Protanopia"+"."+temp.at(1);
    //qDebug()<<algorithm2_simulation_filename;

    return algorithm2_simulation_filename;
}

QString Operation::changeToAlgorithm3Filename(QString filename)
{
    QString algorithm3_filename;
    QStringList temp = filename.split('.');
    algorithm3_filename = temp.at(0)+"_algorithm3_Protanopia"+"."+temp.at(1);
    //qDebug()<<algorithm3_filename;

    return algorithm3_filename;
}

QString Operation::changeToAlgorithm3SimulationFilename(QString filename){
    QString algorithm3_simulation_filename;
    QStringList temp = filename.split('.');
    algorithm3_simulation_filename = temp.at(0)+"_algorithm3Sim__Protanopia"+"."+temp.at(1);
    //qDebug()<<algorithm3_simulation_filename;

    return algorithm3_simulation_filename;
}

bool Operation::isDirExist(QString dirPath)
{
    QDir dir(dirPath);
    if(dir.exists())
    {
      return true;
    }
    else
    {
       bool ok = dir.mkpath(dirPath);//创建多级目录
       //bool ok = dir.mkpath("C:/Users/Administrator/Desktop/jdz/result");//创建多级目录
       return ok;
    }
}

void Operation::createResultDir(QString filepath,QString step,int steplevel)
{
    QString commonpath, colorname;

    commonpath = getCommonFilepath(filepath);
    //去掉commonpath中的“file:///"
    if(commonpath.left(8)=="file:///"){
        commonpath = commonpath.mid(8);
        //qDebug()<<commonpath;
    }

    colorname = getColorFromFilepath(filepath);
    QString dirpath_original = commonpath + step + "data/" +colorname+"/";
    QString dirpath_simulation = commonpath + step + "simulation/" +colorname+"/";
    QString dirpath_algorithm2 = commonpath + step + "algorithm2/" +colorname+"/";
    QString dirpath_algorithm2_simulation = commonpath + step + "algorithm2_simulation/" +colorname+"/";
    QString dirpath_algorithm3 = commonpath + step + "algorithm3/" +colorname+"/";
    QString dirpath_algorithm3_simulation = commonpath + step + "algorithm3_simulation/" +colorname+"/";
    //按固定结构创建目录
    if(isDirExist(dirpath_original)){
        //qDebug()<<"create dirpath_original success!";
    }else{
        //qDebug()<<"create dirpath_original fail!";
    }

    if(isDirExist(dirpath_simulation)){
        //qDebug()<<"create dirpath_simulation success!";
    }else{
        //qDebug()<<"create dirpath_simulation fail!";
    }
    if(isDirExist(dirpath_algorithm2)){
        //qDebug()<<"create dirpath_algorithm2 success!";
    }else{
        //qDebug()<<"create dirpath_algorithm2 fail!";
    }
    if(isDirExist(dirpath_algorithm2_simulation)){
        //qDebug()<<"create dirpath_algorithm2_simulation success!";
    }else{
        //qDebug()<<"create dirpath_algorithm2_simulation fail!";
    }
    if(isDirExist(dirpath_algorithm3)){
        //qDebug()<<"create dirpath_algorithm3 success!";
    }else{
        //qDebug()<<"create dirpath_algorithm3 fail!";
    }
    if(isDirExist(dirpath_algorithm3_simulation)){
        //qDebug()<<"create dirpath_algorithm3_simulation success!";
    }else{
        //qDebug()<<"create dirpath_algorithm3_simulation fail!";
    }

    qDebug()<< " create "<<step<<" dir success!";

    //根据steplevel参数存储下相应的step的目录集

    switch (steplevel) {
    case 1:
        result_step1_dirs.append(dirpath_original);
        result_step1_dirs.append(dirpath_simulation);
        result_step1_dirs.append(dirpath_algorithm2);
        result_step1_dirs.append(dirpath_algorithm2_simulation);
        result_step1_dirs.append(dirpath_algorithm3);
        result_step1_dirs.append(dirpath_algorithm3_simulation);
        break;
    case 2:
        result_step2_dirs.append(dirpath_original);
        result_step2_dirs.append(dirpath_simulation);
        result_step2_dirs.append(dirpath_algorithm2);
        result_step2_dirs.append(dirpath_algorithm2_simulation);
        result_step2_dirs.append(dirpath_algorithm3);
        result_step2_dirs.append(dirpath_algorithm3_simulation);
        break;
    case 3:
        result_step3_dirs.append(dirpath_original);
        result_step3_dirs.append(dirpath_simulation);
        result_step3_dirs.append(dirpath_algorithm2);
        result_step3_dirs.append(dirpath_algorithm2_simulation);
        result_step3_dirs.append(dirpath_algorithm3);
        result_step3_dirs.append(dirpath_algorithm3_simulation);
        break;
    default:
        qDebug()<<"steplevel is error!";
        break;
    }

    return ;
}

void Operation::savePic_Selected(QString filepath,int steplevel, int savetype)
{
    //测试代码
    /*
       QFileInfo file("Z:/Users/maroon/Desktop/jdz/data/orange_yellow/pic_ (1).jpg");
       qDebug()<<file.fileName();
       qDebug()<<file.filePath();
       QFile::copy("Z:/Users/maroon/Desktop/jdz/data/orange_yellow/pic_ (1).jpg","Z:/Users/maroon/Desktop/jdz/result_step1/data/orange_yellow/pic_ (1).jpg");
    */

    if(filepath.left(8)=="file:///"){
        filepath = filepath.mid(8);
        //qDebug()<<commonpath;
    }
    QFileInfo file(filepath);
    QString filename,sourcefile,destinationfile;
    filename = file.fileName();

    QString simulation_filename = changeToSimulationFilename(filename);
    QString algorithm2_filename = changeToAlgorithm2Filename(filename);
    QString algorithm2_sim_filename = changeToAlgorithm2SimulationFilename(filename);
    QString algorithm3_filename = changeToAlgorithm3Filename(filename);
    QString algorithm3_sim_filename = changeToAlgorithm3SimulationFilename(filename);
    qDebug()<<"simulation_filename = "<<simulation_filename;

    //根据函数的参数进行图片的存储
    switch (steplevel) {
    case 1:{
        //依次将对应目录下的图片存储到对应的结果目录下
        for(int i=0;i<6;++i){
            switch(i){
            case 0:{
                sourcefile = original_dirs.at(i)+filename;
                destinationfile = result_step1_dirs.at(i)+filename;
                QFile::copy(sourcefile,destinationfile);
            }
                break;
            case 1:{
                sourcefile = original_dirs.at(i)+simulation_filename;
                destinationfile = result_step1_dirs.at(i)+simulation_filename;
                QFile::copy(sourcefile,destinationfile);
            }
                break;
            case 2:{
                sourcefile = original_dirs.at(i)+algorithm2_filename;
                QFileInfo fileInfo(sourcefile);
                if(fileInfo.isFile()){
                    destinationfile = result_step1_dirs.at(i)+algorithm2_filename;
                    QFile::copy(sourcefile,destinationfile);
                }
            }
                break;
            case 3:{
                sourcefile = original_dirs.at(i)+algorithm2_sim_filename;
                QFileInfo fileInfo(sourcefile);
                if(fileInfo.isFile()){
                    destinationfile = result_step1_dirs.at(i)+algorithm2_sim_filename;
                    QFile::copy(sourcefile,destinationfile);
                }
            }
                break;
            case 4:{
                sourcefile = original_dirs.at(i)+algorithm3_filename;
                QFileInfo fileInfo(sourcefile);
                if(fileInfo.isFile()){
                    destinationfile = result_step1_dirs.at(i)+algorithm3_filename;
                    QFile::copy(sourcefile,destinationfile);
                }
            }
                break;
            case 5:{
                sourcefile = original_dirs.at(i)+algorithm3_sim_filename;
                QFileInfo fileInfo(sourcefile);
                if(fileInfo.isFile()){
                    destinationfile = result_step1_dirs.at(i)+algorithm3_sim_filename;
                    QFile::copy(sourcefile,destinationfile);
                }
            }
                break;
            default:
                qDebug()<<"step1 save pic is error！";
            }
        }
    }
        break;
    case 2:{
        //依次将对应目录下的图片存储到对应的结果目录下
        for(int i=0;i<6;++i){
            switch(i){
            case 0:{
                sourcefile = original_dirs.at(i)+filename;
                destinationfile = result_step2_dirs.at(i)+filename;
                QFile::copy(sourcefile,destinationfile);
            }
                break;
            case 1:{
                sourcefile = original_dirs.at(i)+simulation_filename;
                destinationfile = result_step2_dirs.at(i)+simulation_filename;
                QFile::copy(sourcefile,destinationfile);
            }
                break;
            case 2:{
                if(savetype == 2 || savetype == 23){
                    sourcefile = original_dirs.at(i)+algorithm2_filename;
                    QFileInfo fileInfo(sourcefile);
                    if(fileInfo.isFile()){
                        destinationfile = result_step2_dirs.at(i)+algorithm2_filename;
                        QFile::copy(sourcefile,destinationfile);
                    }
                }
            }
                break;
            case 3:{
                if(savetype == 2 || savetype == 23){
                    sourcefile = original_dirs.at(i)+algorithm2_sim_filename;
                    QFileInfo fileInfo(sourcefile);
                    if(fileInfo.isFile()){
                        destinationfile = result_step2_dirs.at(i)+algorithm2_sim_filename;
                        QFile::copy(sourcefile,destinationfile);
                    }
                }
            }
                break;
            case 4:{
                if(savetype == 3 || savetype == 23){
                    sourcefile = original_dirs.at(i)+algorithm3_filename;
                    QFileInfo fileInfo(sourcefile);
                    if(fileInfo.isFile()){
                        destinationfile = result_step2_dirs.at(i)+algorithm3_filename;
                        QFile::copy(sourcefile,destinationfile);
                    }
                }
            }
                break;
            case 5:{
                if(savetype == 3 || savetype == 23){
                    sourcefile = original_dirs.at(i)+algorithm3_sim_filename;
                    QFileInfo fileInfo(sourcefile);
                    if(fileInfo.isFile()){
                        destinationfile = result_step2_dirs.at(i)+algorithm3_sim_filename;
                        QFile::copy(sourcefile,destinationfile);
                    }
                }
            }
                break;
            default:
                qDebug()<<"step2 save pic is error！";
            }
        }
    }
        break;
    case 3:{
        //依次将对应目录下的图片存储到对应的结果目录下
        for(int i=0;i<6;++i){
            switch(i){
            case 0:{
                sourcefile = original_dirs.at(i)+filename;
                destinationfile = result_step3_dirs.at(i)+filename;
                QFile::copy(sourcefile,destinationfile);
            }
                break;
            case 1:{
                sourcefile = original_dirs.at(i)+simulation_filename;
                destinationfile = result_step3_dirs.at(i)+simulation_filename;
                QFile::copy(sourcefile,destinationfile);
            }
                break;
            case 2:{
                if(savetype == 2 || savetype == 23){
                    sourcefile = original_dirs.at(i)+algorithm2_filename;
                    QFileInfo fileInfo(sourcefile);
                    if(fileInfo.isFile()){
                        destinationfile = result_step3_dirs.at(i)+algorithm2_filename;
                        QFile::copy(sourcefile,destinationfile);
                    }
                }
            }
                break;
            case 3:{
                if(savetype == 2 || savetype == 23){
                    sourcefile = original_dirs.at(i)+algorithm2_sim_filename;
                    QFileInfo fileInfo(sourcefile);
                    if(fileInfo.isFile()){
                        destinationfile = result_step3_dirs.at(i)+algorithm2_sim_filename;
                        QFile::copy(sourcefile,destinationfile);
                    }
                }
            }
                break;
            case 4:{
                if(savetype == 3 || savetype == 23){
                    sourcefile = original_dirs.at(i)+algorithm3_filename;
                    QFileInfo fileInfo(sourcefile);
                    if(fileInfo.isFile()){
                        destinationfile = result_step3_dirs.at(i)+algorithm3_filename;
                        QFile::copy(sourcefile,destinationfile);
                    }
                }
            }
                break;
            case 5:{
                if(savetype == 3 || savetype == 23){
                    sourcefile = original_dirs.at(i)+algorithm3_sim_filename;
                    QFileInfo fileInfo(sourcefile);
                    if(fileInfo.isFile()){
                        destinationfile = result_step3_dirs.at(i)+algorithm3_sim_filename;
                        QFile::copy(sourcefile,destinationfile);
                    }
                }
            }
                break;
            default:
                qDebug()<<"step3 save pic is error！";
            }
        }
    }
        break;
    default:
        break;
    }
}

XMLOperation* Operation::getXMLOperation()
{
    return xml_operation;
}
