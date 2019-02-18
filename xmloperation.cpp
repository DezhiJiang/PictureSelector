#include "xmloperation.h"
#include <iostream>

using namespace std;



XMLOperation::XMLOperation(QObject *parent):QObject(parent)
{
     pic_data = new Pic_Parameter();
     read_combine_pic_data = new Combine_Parameter();

     current_node = new Pic_Parameter();
     combine_node = new Pic_Parameter();
     current_node2 = new Combine_Parameter();
     combine_node2 = new Combine_Parameter();
}

XMLOperation::~XMLOperation()
{

}

void XMLOperation::setIndex(int value)
{
    index = value;
}


void XMLOperation::setFileName(QString name,int step)
{
    switch (step) {
    case 1:
        filename = "D:/色盲数据整理文件/step1_result_xml/"+name+"_step1_select_result.xml";
        break;
    case 2:
        filename = "D:/色盲数据整理文件/step2_result_xml/"+name+"_step2_select_result.xml";
        break;
    case 3:
        filename = "D:/色盲数据整理文件/step3_result_xml/"+name+"_step3_select_result.xml";
        break;
    default:
        qDebug()<<"filename is wrong!";
        break;
    }
    //filename = "D:/"+name+"_select_result.xml";
}

void XMLOperation::create_xml(QString name,int step)
{
    setFileName(name,step);
    QFileInfo xmlfile(filename);
    //先判断文件是否存在，若不存在，则创建新的xml文件
    if(!xmlfile.isFile()){
        QFile file(filename);
        file.open(QIODevice::ReadWrite);
        QDomDocument doc;
        QDomAttr attr;
        QDomProcessingInstruction instruction;
        instruction = doc.createProcessingInstruction("xml","version=\"1.0\" encoding=\"GB2312\"");
        doc.appendChild(instruction);
        QDomElement root = doc.createElement("Selector_name");
        attr = doc.createAttribute("name");
        attr.setValue(name);
        root.setAttributeNode(attr);
        doc.appendChild(root);
        QTextStream out(&file);
        doc.save(out,4);
        file.close();
    }else{
        qDebug()<<"file:"<<filename<<" is exist.";
    }
}

void XMLOperation::add_xmlnode(QString origin_path, int original_save, int algorithm2_save, int algorithm3_save)
{
    QFile file(filename);
    if (!file.open(QIODevice::ReadOnly | QFile::Text)) {
        qDebug()<<"open for add error..." ;
    }
    QDomDocument doc;
    QString errorStr;
    int errorLine;
    int errorColumn;

    if (!doc.setContent(&file, false, &errorStr, &errorLine, &errorColumn)) {
        qDebug()<<"add setcontent error..." ;
        file.close();
    }
    //QDomNode node = doc.firstChild();
    file.close();
    QDomElement root = doc.documentElement();
    if(root.isNull())
    {
        root = doc.createElement("Selector_name");
    }
    QDomAttr attr;
    QDomElement pic_index = doc.createElement("Pic_index");
    attr = doc.createAttribute("ID");
    QString pic_index_num = QString::number(index,10);
    attr.setValue(pic_index_num);
    pic_index.setAttributeNode(attr);
    root.appendChild(pic_index);
    index += 1;

    QDomElement original_pic_path = doc.createElement("Original_pic_path");

    attr = doc.createAttribute("PATH");
    attr.setValue(origin_path);
    original_pic_path.setAttributeNode(attr);
    pic_index.appendChild(original_pic_path);


    QString origin = QString::number(original_save,10);
    QString algorithm2 = QString::number(algorithm2_save,10);
    QString algorithm3 = QString::number(algorithm3_save,10);

    QDomElement pic_save = doc.createElement("Pic_save_situation");
    attr = doc.createAttribute("Original_save");
    attr.setValue(origin);
    //pic_save.setAttribute("Original_save",0.03);
    pic_save.setAttributeNode(attr);
    attr = doc.createAttribute("Algorithm2_save");
    attr.setValue(algorithm2);
    pic_save.setAttributeNode(attr);
    attr = doc.createAttribute("Algorithm3_save");
    attr.setValue(algorithm3);
    pic_save.setAttributeNode(attr);
    pic_index.appendChild(pic_save);

    QString proportion_s = QString::number(proportion,'f',6);

    QDomElement indistinguishable_proportion = doc.createElement("Indistinguishable_proportion");
    attr = doc.createAttribute("Proportion");
    attr.setValue(proportion_s);
    indistinguishable_proportion.setAttributeNode(attr);
    pic_index.appendChild(indistinguishable_proportion);

//    QDomElement bounding_boxes = doc.createElement("Bounding_boxes");
//    pic_index.appendChild(bounding_boxes);

//    //qDebug()<<"bounding_box_count ="<<bounding_box_count;

//    for(int i =0;i <bounding_box_count; i++){
//        QDomElement bounding_box = doc.createElement("Bounding_box");
//        attr = doc.createAttribute("start_x");
//        QString x_s = QString::number(x[i],'f',6);
//        attr.setValue(x_s);
//        bounding_box.setAttributeNode(attr);
//        attr = doc.createAttribute("start_y");
//        QString y_s = QString::number(y[i],'f',6);
//        attr.setValue(y_s);
//        bounding_box.setAttributeNode(attr);
//        attr = doc.createAttribute("length");
//        QString l_s = QString::number(l[i],'f',6);
//        attr.setValue(l_s);
//        bounding_box.setAttributeNode(attr);
//        attr = doc.createAttribute("width");
//        QString w_s = QString::number(w[i],'f',6);
//        attr.setValue(w_s);
//        bounding_box.setAttributeNode(attr);
//        bounding_boxes.appendChild(bounding_box);
//    }

    if(!file.open(QIODevice::WriteOnly|QFile::Truncate))// 覆盖原文件内容
        qDebug() << "open for add error!";
    QTextStream out(&file);
    doc.save(out,4);
    file.close();
}

void XMLOperation::getFistNodeData(QString filepath)
{
    //Pic_Parameter* pic_data;
    filepath = filepath.replace("file:///","");
    //qDebug()<<"filepath ="<<filepath;
    QFile file(filepath);
    if (!file.open(QIODevice::ReadOnly | QFile::Text)) {
        qDebug()<<"open for read error..." ;
    }
    QString errorStr;
    int errorLine;
    int errorColumn;

    QDomDocument doc;
    if (!doc.setContent(&file, false, &errorStr, &errorLine, &errorColumn)) {
        qDebug()<<"setcontent error..." ;
        file.close();
    }
    file.close();
    root = doc.documentElement();
    if (root.tagName() != "Selector_name") {
       qDebug()<<"root.tagname != ipconfig..." ;
    }
    this->node = root.firstChild();

    if(!node.isNull())
    {
        if(node.isElement())
        {
            QDomElement element = node.toElement();
            QString id=element.attribute("ID");
            qDebug()<<id;
            //qDebug() << qPrintable(element.tagName())<<qPrintable(element.attribute("id"));
            QDomNodeList list = element.childNodes();
            pic_data->origin_path = list.at(0).toElement().attribute("PATH");
            qDebug()<<"hehehe";
            qDebug()<<pic_data->origin_path;
            bool ok;
            pic_data->origin_save = list.at(1).toElement().attribute("Original_save").toInt(&ok,10);
            pic_data->algorithm2_save = list.at(1).toElement().attribute("Algorithm2_save").toInt(&ok,10);
            pic_data->algorithm3_save = list.at(1).toElement().attribute("Algorithm3_save").toInt(&ok,10);
            qDebug()<<pic_data->origin_save;
            qDebug()<<pic_data->algorithm2_save;
            qDebug()<<pic_data->algorithm3_save ;

            QDomElement bounding_boxes_element = list.at(2).toElement();
            QDomNodeList bounding_boxes_list = bounding_boxes_element.childNodes();

            pic_data->bounding_box_count = bounding_boxes_list.count();
            qDebug()<<pic_data->bounding_box_count;

            for(int i = 0;i<bounding_boxes_list.count();i++){
                QDomNode nodechild = bounding_boxes_list.at(i);
                pic_data->x[i] = nodechild.toElement().attribute("start_x").toDouble();
                pic_data->y[i] = nodechild.toElement().attribute("start_y").toDouble();
                pic_data->l[i] = nodechild.toElement().attribute("length").toDouble();
                pic_data->w[i] = nodechild.toElement().attribute("width").toDouble();
                qDebug()<<"x= "<<pic_data->x[i]<<",y= "<<pic_data->y[i]<<",l= "<<pic_data->l[i]<<",w= "<<pic_data->w[i];
            }
        }
       //node = node.nextSibling();
    }

    //return pic_data;
}

void XMLOperation::getNextNodeData()
{
    //Pic_Parameter* pic_data;
    //跳到下一个节点
    node = node.nextSibling();

    if(!node.isNull())
    {
        if(node.isElement())
        {
            QDomElement element = node.toElement();
            QString id=element.attribute("ID");
            qDebug()<<id;
            //qDebug() << qPrintable(element.tagName())<<qPrintable(element.attribute("id"));
            QDomNodeList list = element.childNodes();
            pic_data->origin_path = list.at(0).toElement().attribute("PATH");
            qDebug()<<pic_data->origin_path;
            bool ok;
            pic_data->origin_save = list.at(1).toElement().attribute("Original_save").toInt(&ok,10);
            pic_data->algorithm2_save = list.at(1).toElement().attribute("Algorithm2_save").toInt(&ok,10);
            pic_data->algorithm3_save = list.at(1).toElement().attribute("Algorithm3_save").toInt(&ok,10);
            qDebug()<<pic_data->origin_save;
            qDebug()<<pic_data->algorithm2_save;
            qDebug()<<pic_data->algorithm3_save ;

            QDomElement bounding_boxes_element = list.at(2).toElement();
            QDomNodeList bounding_boxes_list = bounding_boxes_element.childNodes();

            pic_data->bounding_box_count = bounding_boxes_list.count();
            qDebug()<<pic_data->bounding_box_count;

            for(int i = 0;i<bounding_boxes_list.count();i++){
                QDomNode nodechild = bounding_boxes_list.at(i);
                pic_data->x[i] = nodechild.toElement().attribute("start_x").toDouble();
                pic_data->y[i] = nodechild.toElement().attribute("start_y").toDouble();
                pic_data->l[i] = nodechild.toElement().attribute("length").toDouble();
                pic_data->w[i] = nodechild.toElement().attribute("width").toDouble();
                qDebug()<<"x= "<<pic_data->x[i]<<",y= "<<pic_data->y[i]<<",l= "<<pic_data->l[i]<<",w= "<<pic_data->w[i];
            }
        }
       //node = node.nextSibling();
    }else{
        qDebug()<<"node is null!";
        emit xmlfileEnds();  //发送结束信号
    }
    //return pic_data;
}

QString XMLOperation::getCurrentOriginPath()
{
    return pic_data->origin_path;
}

//读取合并的xml需要的操作
void XMLOperation::getFirstNodeFromCombineXML(QString filepath)
{

    filepath = filepath.replace("file:///","");
    qDebug()<<"filepath ="<<filepath;
    QFile file(filepath);
    if (!file.open(QIODevice::ReadOnly | QFile::Text)) {
        qDebug()<<"step2 open for read error..." ;
    }
    QString errorStr;
    int errorLine;
    int errorColumn;

    QDomDocument doc;
    if (!doc.setContent(&file, false, &errorStr, &errorLine, &errorColumn)) {
        qDebug()<<"setcontent error..." ;
        file.close();
    }
    file.close();
    read_combine_root = doc.documentElement();
    if (read_combine_root.tagName() != "Result_name") {
       qDebug()<<"root.tagname != ipconfig..." ;
    }
    read_combine_node = read_combine_root.firstChild();

    if(!read_combine_node.isNull())
    {
        if(read_combine_node.isElement())
        {
            QDomElement element = read_combine_node.toElement();
            QString id=element.attribute("ID");
            //qDebug()<<"ID="<<id;
            //qDebug() << qPrintable(element.tagName())<<qPrintable(element.attribute("id"));
            QDomNodeList list = element.childNodes();
            read_combine_pic_data->origin_path = list.at(0).toElement().attribute("PATH");
            //qDebug()<<read_combine_pic_data->origin_path;
            bool ok;
            read_combine_pic_data->origin_save = list.at(1).toElement().attribute("Original_save").toInt(&ok,10);
            read_combine_pic_data->algorithm2_save = list.at(1).toElement().attribute("Algorithm2_save").toInt(&ok,10);
            read_combine_pic_data->algorithm3_save = list.at(1).toElement().attribute("Algorithm3_save").toInt(&ok,10);
            //qDebug()<<read_combine_pic_data->origin_save;
            //qDebug()<<read_combine_pic_data->algorithm2_save;
            //qDebug()<<read_combine_pic_data->algorithm3_save ;

            read_combine_pic_data->proportion = list.at(2).toElement().attribute("Proportion").toDouble();
            //qDebug()<<read_combine_pic_data->proportion;

        }
       //node = node.nextSibling();
    }else{
        //qDebug()<<"node is null!";
        step2_xml_is_end = 1;
        emit step2_xmlfileEnds();  //发送结束信号
    }

    //return pic_data;
}

void XMLOperation::getNextNodeFromCombineXML()
{

    //qDebug()<<"hehehehe";
    //Pic_Parameter* pic_data;
    //跳到下一个节点
    read_combine_node = read_combine_node.nextSibling();

    if(!read_combine_node.isNull())
    {
        if(read_combine_node.isElement())
        {
            QDomElement element = read_combine_node.toElement();
            QString id=element.attribute("ID");
            //qDebug()<<id;
            //qDebug() << qPrintable(element.tagName())<<qPrintable(element.attribute("id"));
            QDomNodeList list = element.childNodes();
            read_combine_pic_data->origin_path = list.at(0).toElement().attribute("PATH");
            //qDebug()<<read_combine_pic_data->origin_path;
            bool ok;
            read_combine_pic_data->origin_save = list.at(1).toElement().attribute("Original_save").toInt(&ok,10);
            read_combine_pic_data->algorithm2_save = list.at(1).toElement().attribute("Algorithm2_save").toInt(&ok,10);
            read_combine_pic_data->algorithm3_save = list.at(1).toElement().attribute("Algorithm3_save").toInt(&ok,10);
            //qDebug()<<read_combine_pic_data->origin_save;
            //qDebug()<<read_combine_pic_data->algorithm2_save;
            //qDebug()<<read_combine_pic_data->algorithm3_save ;

            read_combine_pic_data->proportion = list.at(2).toElement().attribute("Proportion").toDouble();
            //qDebug()<<read_combine_pic_data->proportion;
        }
       //node = node.nextSibling();
    }else{
        qDebug()<<"node is end!";
        step2_xml_is_end = 1;
        emit step2_xmlfileEnds();  //发送结束信号
    }
    //return pic_data;
}

QString XMLOperation::getCurrentCombineOriginPath()
{
    return read_combine_pic_data->origin_path;
}

double XMLOperation::getCurrentProportion()
{
    return read_combine_pic_data->proportion;
}

QString XMLOperation::getOriginOfIndexFromXML(QString filepath, int index)
{
    QString path;

    if(index == 0){
        //如果索引号为0，则读取第一个节点
        getFirstNodeFromCombineXML(filepath);

    }else{
        //否则，读取到对应索引的节点
        for(int i=0;i<index;i++){
            if(i==0)
                getFirstNodeFromCombineXML(filepath);
            getNextNodeFromCombineXML();
        }
    }
    if(step2_xml_is_end == 0){
        path = getCurrentCombineOriginPath();
        proportion = getCurrentProportion();
    }else{
        path = "step2_xml_is_end";
    }

    return path;

}

int XMLOperation::getNodeCountsOfXML(QString filepath)
{
    int count = 0;
    filepath = filepath.replace("file:///","");
    qDebug()<<"filepath ="<<filepath;
    QFile file(filepath);
    if (!file.open(QIODevice::ReadOnly | QFile::Text)) {
        qDebug()<<"open for read error..." ;
    }
    QString errorStr;
    int errorLine;
    int errorColumn;

    QDomDocument doc;
    if (!doc.setContent(&file, false, &errorStr, &errorLine, &errorColumn)) {
        qDebug()<<"setcontent error..." ;
        file.close();
    }
    file.close();
    read_combine_root = doc.documentElement();
    if (read_combine_root.tagName() != "Result_name") {
       qDebug()<<"root.tagname != ipconfig..." ;
    }
    read_combine_node = read_combine_root.firstChild();
    while(!read_combine_node.isNull()){
        count++;
        read_combine_node = read_combine_node.nextSibling();
    }

    return count;
}

//步骤三读取合并xml的一些函数
void XMLOperation::getFirstNodeFromCombineXML_step3(QString filepath)
{
    filepath = filepath.replace("file:///","");
    qDebug()<<"filepath ="<<filepath;
    QFile file(filepath);
    if (!file.open(QIODevice::ReadOnly | QFile::Text)) {
        qDebug()<<"open for read error..." ;
    }
    QString errorStr;
    int errorLine;
    int errorColumn;

    QDomDocument doc;
    if (!doc.setContent(&file, false, &errorStr, &errorLine, &errorColumn)) {
        qDebug()<<"setcontent error..." ;
        file.close();
    }
    file.close();
    read_combine_root = doc.documentElement();
    if (read_combine_root.tagName() != "Result_name") {
       qDebug()<<"root.tagname != ipconfig..." ;
    }
    read_combine_node = read_combine_root.firstChild();

    if(!read_combine_node.isNull())
    {
        if(read_combine_node.isElement())
        {
            QDomElement element = read_combine_node.toElement();
            QString id=element.attribute("ID");
            //qDebug()<<"ID="<<id;
            //qDebug() << qPrintable(element.tagName())<<qPrintable(element.attribute("id"));
            QDomNodeList list = element.childNodes();
            read_combine_pic_data->origin_path = list.at(0).toElement().attribute("PATH");
            //qDebug()<<read_combine_pic_data->origin_path;
            bool ok;
            read_combine_pic_data->origin_save = list.at(1).toElement().attribute("Original_save").toInt(&ok,10);
            read_combine_pic_data->algorithm2_save = list.at(1).toElement().attribute("Algorithm2_save").toInt(&ok,10);
            read_combine_pic_data->algorithm3_save = list.at(1).toElement().attribute("Algorithm3_save").toInt(&ok,10);
            //qDebug()<<read_combine_pic_data->origin_save;
            //qDebug()<<read_combine_pic_data->algorithm2_save;
            //qDebug()<<read_combine_pic_data->algorithm3_save ;

            read_combine_pic_data->proportion = list.at(2).toElement().attribute("Proportion").toDouble();
            //qDebug()<<read_combine_pic_data->proportion;

        }
       //node = node.nextSibling();
    }else{
        qDebug()<<"node is null!";
        step3_xml_is_end = 1;
        emit step3_xmlfileEnds();  //发送结束信号
    }
}

void XMLOperation::getNextNodeFromCombineXML_step3()
{

    //qDebug()<<"hehehehe";
    //Pic_Parameter* pic_data;
    //跳到下一个节点
    read_combine_node = read_combine_node.nextSibling();

    if(!read_combine_node.isNull())
    {
        if(read_combine_node.isElement())
        {
            QDomElement element = read_combine_node.toElement();
            QString id=element.attribute("ID");
            //qDebug()<<id;
            //qDebug() << qPrintable(element.tagName())<<qPrintable(element.attribute("id"));
            QDomNodeList list = element.childNodes();
            read_combine_pic_data->origin_path = list.at(0).toElement().attribute("PATH");
            //qDebug()<<read_combine_pic_data->origin_path;
            bool ok;
            read_combine_pic_data->origin_save = list.at(1).toElement().attribute("Original_save").toInt(&ok,10);
            read_combine_pic_data->algorithm2_save = list.at(1).toElement().attribute("Algorithm2_save").toInt(&ok,10);
            read_combine_pic_data->algorithm3_save = list.at(1).toElement().attribute("Algorithm3_save").toInt(&ok,10);
            //qDebug()<<read_combine_pic_data->origin_save;
            //qDebug()<<read_combine_pic_data->algorithm2_save;
            //qDebug()<<read_combine_pic_data->algorithm3_save ;

            read_combine_pic_data->proportion = list.at(2).toElement().attribute("Proportion").toDouble();
            //qDebug()<<read_combine_pic_data->proportion;
        }
       //node = node.nextSibling();
    }else{
        qDebug()<<"node is end!";
        step3_xml_is_end = 1;
        emit step3_xmlfileEnds();  //发送结束信号
    }
    //return pic_data;
}

QString XMLOperation::getOriginOfIndexFromXML_step3(QString filepath, int index)
{
    QString path;

    if(index == 0){
        //如果索引号为0，则读取第一个节点
        getFirstNodeFromCombineXML_step3(filepath);

    }else{
        //否则，读取到对应索引的节点
        for(int i=0;i<index;i++){
            if(i==0)
                getFirstNodeFromCombineXML_step3(filepath);
            getNextNodeFromCombineXML_step3();
        }
    }
    if(step3_xml_is_end == 0){
        path = getCurrentCombineOriginPath();
        proportion = getCurrentProportion();
    }else{
        path = "step3_xml_is_end";
    }

    return path;
}


//关于boundingbox的一些操作
int XMLOperation::getBoundingBoxCount()
{
    return bounding_box_count;
}

void XMLOperation::setBoundingBoxCount(int value)
{
    bounding_box_count = value;
}

void XMLOperation::setStart_XOfIndex(int index, double value)
{
    x[index] = value;
    //qDebug()<<"x ="<<x[index];
}

void XMLOperation::setStart_YOfIndex(int index, double value)
{
    y[index] = value;
}

void XMLOperation::setLengthOfIndex(int index, double value)
{
    l[index] = value;
}

void XMLOperation::setWidthOfIndex(int index, double value)
{
    w[index] = value;
}

double XMLOperation::getStart_XOfIndex(int index)
{
    return x[index];
}

double XMLOperation::getStart_YOfIndex(int index)
{
    return y[index];
}

double XMLOperation::getLengthOfIndex(int index)
{
    return l[index];
}

double XMLOperation::getWidthOfIndex(int index)
{
    return w[index];
}

double* XMLOperation::getStart_X()
{
    return x;
}

double* XMLOperation::getStart_Y()
{
    return y;
}

double* XMLOperation::getLength()
{
    return l;
}

double* XMLOperation::getWidth()
{
    return w;
}


//XML合并*************************************************************

void XMLOperation::getXMLFilefromDir(QString filepath)
{
    //清空原先的列表
    xml_list.clear();
    combine_nodes.clear();
    combine_roots.clear();
    //去掉路径头file///
    filepath = filepath.replace("file:///","");

    QDir dir(filepath);
    if(!dir.exists())
        return;
    //查看路径中后缀为.xml的文件
    QStringList filters;
    filters<<QString("*.xml");
    dir.setFilter(QDir::Files | QDir::NoSymLinks); //设置类型过滤器，只为文件格式
    dir.setNameFilters(filters);  //设置文件名称过滤器，只为filters格式

    //统计格式的文件个数
    int dir_count = dir.count();
    xml_count = dir_count;
    if(dir_count <= 0)
        return;

    //存储文件名称
   // QStringList string_list;
    for(int i=0; i<dir_count; i++)
    {
        QString file_name =filepath +"/"+ dir[i];  //文件名称
        //ts<<file_name<<"\r\n"<<"\r\n";
        //qDebug()<<file_name;
        QDomNode temp_node;
        QDomElement temp_root;
        xml_list.append(file_name);
        combine_nodes.append(temp_node);
        combine_roots.append(temp_root);
    }
    return ;

}

void XMLOperation::create_combinexml(int step)
{

    switch (step) {
    case 1:{
        combine_filename = "D:/色盲数据整理文件/combine_xml_result/step1_select_result_combine.xml";
        break;
    }
    case 2:{
        combine_filename = "D:/色盲数据整理文件/combine_xml_result/step2_select_result_combine.xml";
        break;
    }
    case 3:{
        combine_filename = "D:/色盲数据整理文件/combine_xml_result/step3_select_result_combine.xml";
        break;
    }
    default:
        break;
    }

    QFileInfo xmlfile(combine_filename);
    //先判断文件是否存在，若不存在，则创建新的xml文件
    if(!xmlfile.isFile()){
        QFile file(combine_filename);
        file.open(QIODevice::ReadWrite);
        QDomDocument doc;
        QDomAttr attr;
        QDomProcessingInstruction instruction;
        instruction = doc.createProcessingInstruction("xml","version=\"1.0\" encoding=\"GB2312\"");
        doc.appendChild(instruction);
        QDomElement root = doc.createElement("Result_name");
        attr = doc.createAttribute("name");
        switch (step) {
        case 1:
            attr.setValue("step1_result");
            break;
        case 2:
            attr.setValue("step2_result");
            break;
        case 3:
            attr.setValue("step3_result");
            break;
        default:
            break;
        }
        root.setAttributeNode(attr);
        doc.appendChild(root);
        QTextStream out(&file);
        doc.save(out,4);
        file.close();
    }else{
        qDebug()<<"file:"<<combine_filename<<" is exist.";
    }
}

void XMLOperation::combineXMLFilefromDir(QString filepath,int stepvalue)
{

//    int stepvalue;
//    if(filepath.contains("step1_result_xml")){
//        stepvalue = 1;
//    }else if(filepath.contains("step2_result_xml")){
//        stepvalue = 2;
//    }else if(filepath.contains("step3_result_xml")){
//        stepvalue = 3;
//    }else {
//        qDebug()<<"combine filepath is error!";
//    }
    //创建一个合并结果的xml
    create_combinexml(stepvalue);

    //将用于标记合并xml中的图片节点的索引号置0
    combine_index = 0;

    //获取目录下的xml文件
    getXMLFilefromDir(filepath);

    switch (stepvalue) {
    case 1:
        combine1();
        break;
    case 2:
        combine2();
        break;
    case 3:
        combine2();
        break;
    default:
        break;
    }



//    Combine_Parameter *combine_result =  new Combine_Parameter;  //合并的结果

//    /****** 对步骤一筛选的结果xml的合并 ********/
//    //顺序读取每个xml文件中对应的图片节点进行一一合并

//    bool node_is_not_null = true;  //用于判断当前xml文件中是否还有节点
//    int is_first = 1; //用于标记当前是xml文件的第一个节点的标志位，因为读取第一个节点的函数和读取其他节点的函数不同
//    int is_last = 0;  //用于标记当前是xml文件中的最后一个节点的标志位，用于结束while循环

//    while(node_is_not_null){
//        //将用于统计色盲区域的数组先重置，每一个节点统计一次
//        memset(image,0,400*300*sizeof(int));

//        for(int i =0;i <xml_list.count();i++){
//            //从xml文件中读取一个节点
//            if(is_first == 1){
//                current_node = getFistNodeData_C1(xml_list.at(i),i);   //这里的i指第几个xml文件

//                if(current_node == 0){
//                    //若首节点都为空，说明xml文件为空，直接结束合并函数
//                    node_is_not_null = false; //将标志位置为false,以结束外围循环
//                    qDebug()<<"xml file is empty！！！";
//                    return ;
//                }
//            }else{
//                current_node = getNextNodeData_C1(i);
//                if(current_node == 0){
//                    node_is_not_null = false; //将标志位置为false,以结束外围循环
//                    is_last = 1;  //用于结束while循环
//                    break; //结束for循环
//                }
//            }

//            //对该节点进行合并
//            if(i == 0){
//                //当前是第一个xml文件读出的节点，将以这个节点为基准进行合并
//                combine_result->origin_path = current_node->origin_path;
//                combine_result->origin_save = current_node->origin_save;
//                combine_result->algorithm2_save = current_node->algorithm2_save;
//                combine_result->algorithm3_save = current_node->algorithm3_save;
////                qDebug()<<"origin_path = "<<combine_result->origin_path;
////                qDebug()<<"origin_save = "<<combine_result->origin_save;
////                qDebug()<<"algorithm2_save = "<<combine_result->algorithm2_save;
////                qDebug()<<"algorithm3_save = "<<combine_result->algorithm3_save;

//                if(combine_result->origin_save == 0){
//                    //如果原始图不需要保存，说明这张图片色盲可区分，所以此xml文件中的这张图片色盲像素点为0
//                }else{
//                    //若色盲不可区分，则根据像素进行色盲区域的统计
//                    for(int count=0; count<current_node->bounding_box_count; count++){
//                        for(int y=current_node->y[count],flag1=0;flag1<current_node->w[count];flag1++,y++){
//                            for(int x=current_node->x[count],flag2=0;flag2<current_node->l[count];flag2++,x++)
//                            {
//                                image[x][y] = 1;
//                            }
//                        }
//                    }
//                }
//            }else{
//                //当前点不是第一个xml文件读出来的节点
//                if(combine_result->origin_path != current_node->origin_path){
//                    //如果xml文件间的节点原始图没有一一对应，停止合并
//                    qDebug()<<"xml file nodes are not same!!! combine xml ends!!!";
//                    return ;
//                }
//                //xml的节点可以对应上,则将读出的节点合并进去
//                combine_result->origin_save += current_node->origin_save;
//                combine_result->algorithm2_save += current_node->algorithm2_save;
//                combine_result->algorithm3_save += current_node->algorithm3_save;

//                for(int count=0; count<current_node->bounding_box_count; count++){
//                    for(int y=current_node->y[count],flag1=0;flag1<current_node->w[count];flag1++,y++){
//                        for(int x=current_node->x[count],flag2=0;flag2<current_node->l[count];flag2++,x++)
//                        {
//                            image[x][y] = 1;
//                        }
//                    }
//                }
//            }
//        }//选定目录下所有xml文件中的同一个节点读取完毕,色盲区域像素点统计结束

//        //如果当前是最后一个节点，结束while循环，不再继续后面这些操作
//        if(is_last == 1)
//            break;

//        is_first = 0;  //将首节点标志为清零

//        //步骤一： 统计原始图、算法一的图和算法二的图的保存率，若保存率超过50%则保存这张图片，否则则不保存，先统计原始图，若原始图不保存，则算法2和3肯定不保存
//        //功能一的话只需考虑原始图片即可。功能2、3需要将算法2、算法3的图片分别判断是否需要保存
//        double rate;
//        rate = (double)combine_result->origin_save /(double) xml_list.count();
//        if(rate < 0.5){
//            //该图片不是色盲图片
//            combine_result->origin_save = 0;
//            combine_result->algorithm2_save = 0;
//            combine_result->algorithm3_save = 0;
//            combine_result->proportion = (double)0;
//        }else{
//            combine_result->origin_save = 1;
//            rate = (double)combine_result->algorithm2_save /(double) xml_list.count();
//            if(rate < 0.5)
//                combine_result->algorithm2_save = 0;
//            else
//                combine_result->algorithm2_save = 1;
//            rate = (double)combine_result->algorithm3_save / (double)xml_list.count();
//            if(rate < 0.5)
//                combine_result->algorithm3_save = 0;
//            else
//                combine_result->algorithm3_save = 1;

//            //步骤二： 统计image数组中值为一的元素个数，从而可以计算出这张图片的色盲区域占比
//            int box_value = 0;
//            for(int y=0; y<300; y++){
//                //cout<<endl;
//                for(int x=0; x<400; x++){
//                    //cout<<image[z][y];
//                    if(image[x][y] == 1)
//                        box_value++;
//                }
//            }
//            combine_result->proportion = (double)box_value / (400*300);
//            cout<<"proportion = "<<combine_result->proportion<<endl;

//            //节点处理完毕，将该节点写入步骤一的结果xml文件中
//            add_step1_xmlcombinenode(combine_result);

//            //统计需要保存的原始图的数目
//            step1_result_count += 1;
//        }
//    }

//    //发送合并完成的信号
//    emit combineSucceed();
}

//从一个xml文件中获取第一个节点并返回
Pic_Parameter* XMLOperation::getFistNodeData_C1(QString filepath, int index)
{

    Pic_Parameter *temp_pic_data = new Pic_Parameter;

    QFile file(filepath);
    //qDebug()<<"filepath ="<<filepath;

    if (!file.open(QIODevice::ReadOnly | QFile::Text)) {
        qDebug()<<"open for read error..." ;
    }
    QString errorStr;
    int errorLine;
    int errorColumn;

    QDomDocument doc;
    if (!doc.setContent(&file, false, &errorStr, &errorLine, &errorColumn)) {
        qDebug()<<"setcontent error..." ;
        file.close();
    }
    file.close();
    combine_roots[index] = doc.documentElement();
    if (combine_roots.at(index).tagName() != "Selector_name") {
       qDebug()<<"root.tagname != ipconfig..." ;
    }
    combine_nodes[index] = combine_roots.at(index).firstChild();

    if(!combine_nodes.at(index).isNull())
    {
        if(combine_nodes.at(index).isElement())
        {
            QDomElement element = combine_nodes.at(index).toElement();
            QString id=element.attribute("ID");
            //qDebug()<<id;
            //qDebug() << qPrintable(element.tagName())<<qPrintable(element.attribute("id"));
            QDomNodeList list = element.childNodes();
            //qDebug()<<"path =)"<<list.at(0).toElement().attribute("PATH");
            temp_pic_data->origin_path = list.at(0).toElement().attribute("PATH");
            //qDebug()<<"pic_data->origin_path ="<<temp_pic_data->origin_path;

            bool ok;
            temp_pic_data->origin_save = list.at(1).toElement().attribute("Original_save").toInt(&ok,10);
            temp_pic_data->algorithm2_save = list.at(1).toElement().attribute("Algorithm2_save").toInt(&ok,10);
            temp_pic_data->algorithm3_save = list.at(1).toElement().attribute("Algorithm3_save").toInt(&ok,10);
            //qDebug()<<temp_pic_data->origin_save;
            //qDebug()<<temp_pic_data->algorithm2_save;
            //qDebug()<<temp_pic_data->algorithm3_save ;


            QDomElement bounding_boxes_element = list.at(2).toElement();
            QDomNodeList bounding_boxes_list = bounding_boxes_element.childNodes();

            temp_pic_data->bounding_box_count = bounding_boxes_list.count();
            //qDebug()<<temp_pic_data->bounding_box_count;

            for(int i = 0;i<bounding_boxes_list.count();i++){
                QDomNode nodechild = bounding_boxes_list.at(i);
                temp_pic_data->x[i] = nodechild.toElement().attribute("start_x").toDouble();
                temp_pic_data->y[i] = nodechild.toElement().attribute("start_y").toDouble();
                temp_pic_data->l[i] = nodechild.toElement().attribute("length").toDouble();
                temp_pic_data->w[i] = nodechild.toElement().attribute("width").toDouble();
                //qDebug()<<"x= "<<temp_pic_data->x[i]<<",y= "<<temp_pic_data->y[i]<<",l= "<<temp_pic_data->l[i]<<",w= "<<temp_pic_data->w[i];
            }
        }
        return temp_pic_data;
    }else{
        return 0;
    }


}

//获取下一个节点并返回
Pic_Parameter* XMLOperation::getNextNodeData_C1(int index)
{
    Pic_Parameter* temp_pic_data = new Pic_Parameter;
    //跳到下一个节点
    combine_nodes[index] = combine_nodes[index].nextSibling();

    if(!combine_nodes.at(index).isNull())
    {
        if(combine_nodes.at(index).isElement())
        {
            QDomElement element = combine_nodes.at(index).toElement();
            QString id=element.attribute("ID");
            //qDebug()<<id;
            //qDebug() << qPrintable(element.tagName())<<qPrintable(element.attribute("id"));
            QDomNodeList list = element.childNodes();
            temp_pic_data->origin_path = list.at(0).toElement().attribute("PATH");
            //qDebug()<<temp_pic_data->origin_path;
            bool ok;
            temp_pic_data->origin_save = list.at(1).toElement().attribute("Original_save").toInt(&ok,10);
            temp_pic_data->algorithm2_save = list.at(1).toElement().attribute("Algorithm2_save").toInt(&ok,10);
            temp_pic_data->algorithm3_save = list.at(1).toElement().attribute("Algorithm3_save").toInt(&ok,10);
            //qDebug()<<temp_pic_data->origin_save;
            //qDebug()<<temp_pic_data->algorithm2_save;
            //qDebug()<<temp_pic_data->algorithm3_save ;

            QDomElement bounding_boxes_element = list.at(2).toElement();
            QDomNodeList bounding_boxes_list = bounding_boxes_element.childNodes();

            temp_pic_data->bounding_box_count = bounding_boxes_list.count();
            //qDebug()<<temp_pic_data->bounding_box_count;

            for(int i = 0;i<bounding_boxes_list.count();i++){
                QDomNode nodechild = bounding_boxes_list.at(i);
                temp_pic_data->x[i] = nodechild.toElement().attribute("start_x").toDouble();
                temp_pic_data->y[i] = nodechild.toElement().attribute("start_y").toDouble();
                temp_pic_data->l[i] = nodechild.toElement().attribute("length").toDouble();
                temp_pic_data->w[i] = nodechild.toElement().attribute("width").toDouble();
                //qDebug()<<"x= "<<temp_pic_data->x[i]<<",y= "<<temp_pic_data->y[i]<<",l= "<<temp_pic_data->l[i]<<",w= "<<temp_pic_data->w[i];
            }
        }
        return temp_pic_data;
    }else{
        //qDebug()<<"node is null!";
        //emit xmlfileEnds();  //发送结束信号
        return 0;
    }

}

void XMLOperation::add_step1_xmlcombinenode(Combine_Parameter *combine_result)
{
    QFile file(combine_filename);
    //QFile file("D:/色盲数据整理文件/combine_xml_result/step1_select_result_combine.xml");
    if (!file.open(QIODevice::ReadOnly | QFile::Text)) {
        qDebug()<<"open for add error..." ;
    }

    QDomDocument doc;
    QString errorStr;
    int errorLine;
    int errorColumn;

    if (!doc.setContent(&file, false, &errorStr, &errorLine, &errorColumn)) {
        qDebug()<<"add setcontent error..." ;
        file.close();
    }
    //QDomNode node = doc.firstChild();
    file.close();

    QDomElement root = doc.documentElement();
    if(root.isNull()){
        root = doc.createElement("Result_name");
    }
    QDomAttr attr;
    QDomElement pic_index = doc.createElement("Pic_index");
    attr = doc.createAttribute("ID");
    QString pic_index_num = QString::number(combine_index,10);
    attr.setValue(pic_index_num);
    pic_index.setAttributeNode(attr);
    root.appendChild(pic_index);
    combine_index += 1;

    QDomElement original_pic_path = doc.createElement("Original_pic_path");
    attr = doc.createAttribute("PATH");
    attr.setValue(combine_result->origin_path);
    original_pic_path.setAttributeNode(attr);
    pic_index.appendChild(original_pic_path);

    QString origin = QString::number(combine_result->origin_save,10);
    QString algorithm2 = QString::number(combine_result->algorithm2_save,10);
    QString algorithm3 = QString::number(combine_result->algorithm3_save,10);

    QDomElement pic_save = doc.createElement("Pic_save_situation");
    attr = doc.createAttribute("Original_save");
    attr.setValue(origin);
    pic_save.setAttributeNode(attr);
    attr = doc.createAttribute("Algorithm2_save");
    attr.setValue(algorithm2);
    pic_save.setAttributeNode(attr);
    attr = doc.createAttribute("Algorithm3_save");
    attr.setValue(algorithm3);
    pic_save.setAttributeNode(attr);
    pic_index.appendChild(pic_save);

    QString proportion = QString::number(combine_result->proportion,'f',6);
    QDomElement pic_proportion = doc.createElement("Indistinguishable_proportion");
    attr = doc.createAttribute("Proportion");
    attr.setValue(proportion);
    pic_proportion.setAttributeNode(attr);
    pic_index.appendChild(pic_proportion);

    if(!file.open(QIODevice::WriteOnly|QFile::Truncate))// 覆盖原文件内容
        qDebug() << "open for add error!";
    QTextStream out(&file);
    doc.save(out,4);
    file.close();
}

//合并步骤二xml需要的操作
Combine_Parameter* XMLOperation::getFirstNodeData_C2(QString filepath, int index)
{
    Combine_Parameter *temp_pic_data = new Combine_Parameter;

    //filepath = filepath.replace("file:///","");
    //qDebug()<<"filepath ="<<filepath;
    QFile file(filepath);
    if (!file.open(QIODevice::ReadOnly | QFile::Text)) {
        qDebug()<<"open for read error..." ;
    }
    QString errorStr;
    int errorLine;
    int errorColumn;

    QDomDocument doc;
    if (!doc.setContent(&file, false, &errorStr, &errorLine, &errorColumn)) {
        qDebug()<<"setcontent error..." ;
        file.close();
    }
    file.close();
    combine_roots[index] = doc.documentElement();
    if (combine_roots.at(index).tagName() != "Selector_name") {
       qDebug()<<"root.tagname != ipconfig..." ;
    }
    combine_nodes[index] = combine_roots.at(index).firstChild();

    if(!combine_nodes.at(index).isNull())
    {
        if(combine_nodes.at(index).isElement())
        {
            QDomElement element = combine_nodes.at(index).toElement();
            QString id=element.attribute("ID");
            //qDebug()<<"ID="<<id;
            //qDebug() << qPrintable(element.tagName())<<qPrintable(element.attribute("id"));
            QDomNodeList list = element.childNodes();
            temp_pic_data->origin_path = list.at(0).toElement().attribute("PATH");
            //qDebug()<<read_combine_pic_data->origin_path;
            bool ok;
            temp_pic_data->origin_save = list.at(1).toElement().attribute("Original_save").toInt(&ok,10);
            temp_pic_data->algorithm2_save = list.at(1).toElement().attribute("Algorithm2_save").toInt(&ok,10);
            temp_pic_data->algorithm3_save = list.at(1).toElement().attribute("Algorithm3_save").toInt(&ok,10);
            //qDebug()<<read_combine_pic_data->origin_save;
            //qDebug()<<read_combine_pic_data->algorithm2_save;
            //qDebug()<<read_combine_pic_data->algorithm3_save ;

            temp_pic_data->proportion = list.at(2).toElement().attribute("Proportion").toDouble();
            //qDebug()<<read_combine_pic_data->proportion;

        }
       return temp_pic_data;
    }else{
        return 0;
    }
}

Combine_Parameter* XMLOperation::getNextNodeData_C2(int index)
{

    Combine_Parameter* temp_pic_data = new Combine_Parameter;
    //跳到下一个节点
    combine_nodes[index] = combine_nodes[index].nextSibling();

    if(!combine_nodes.at(index).isNull())
    {
        if(combine_nodes.at(index).isElement())
        {
            QDomElement element = combine_nodes.at(index).toElement();
            QString id=element.attribute("ID");
            //qDebug()<<id;
            //qDebug() << qPrintable(element.tagName())<<qPrintable(element.attribute("id"));
            QDomNodeList list = element.childNodes();
            temp_pic_data->origin_path = list.at(0).toElement().attribute("PATH");
            //qDebug()<<read_combine_pic_data->origin_path;
            bool ok;
            temp_pic_data->origin_save = list.at(1).toElement().attribute("Original_save").toInt(&ok,10);
            temp_pic_data->algorithm2_save = list.at(1).toElement().attribute("Algorithm2_save").toInt(&ok,10);
            temp_pic_data->algorithm3_save = list.at(1).toElement().attribute("Algorithm3_save").toInt(&ok,10);
            //qDebug()<<read_combine_pic_data->origin_save;
            //qDebug()<<read_combine_pic_data->algorithm2_save;
            //qDebug()<<read_combine_pic_data->algorithm3_save ;

            temp_pic_data->proportion = list.at(2).toElement().attribute("Proportion").toDouble();
            //qDebug()<<read_combine_pic_data->proportion;
        }
       return temp_pic_data;
    }else{
        return 0;
    }
}

void XMLOperation::combine1()
{
    Combine_Parameter *combine_result =  new Combine_Parameter;  //合并的结果

    bool node_is_not_null = true;  //用于判断当前xml文件中是否还有节点
    int is_first = 1; //用于标记当前是xml文件的第一个节点的标志位，因为读取第一个节点的函数和读取其他节点的函数不同
    int is_last = 0;  //用于标记当前是xml文件中的最后一个节点的标志位，用于结束while循环

    while(node_is_not_null){
        //将用于统计色盲区域的数组先重置，每一个节点统计一次
        memset(image,0,400*300*sizeof(int));

        for(int i =0;i <xml_list.count();i++){
            //从xml文件中读取一个节点
            if(is_first == 1){
                current_node = getFistNodeData_C1(xml_list.at(i),i);   //这里的i指第几个xml文件

                if(current_node == 0){
                    //若首节点都为空，说明xml文件为空，直接结束合并函数
                    node_is_not_null = false; //将标志位置为false,以结束外围循环
                    qDebug()<<"xml file is empty！！！";
                    return ;
                }
            }else{
                current_node = getNextNodeData_C1(i);
                if(current_node == 0){
                    node_is_not_null = false; //将标志位置为false,以结束外围循环
                    is_last = 1;  //用于结束while循环
                    break; //结束for循环
                }
            }

            //对该节点进行合并
            if(i == 0){
                //当前是第一个xml文件读出的节点，将以这个节点为基准进行合并
                combine_result->origin_path = current_node->origin_path;
                combine_result->origin_save = current_node->origin_save;
                combine_result->algorithm2_save = current_node->algorithm2_save;
                combine_result->algorithm3_save = current_node->algorithm3_save;

                if(combine_result->origin_save == 0){
                    //如果原始图不需要保存，说明这张图片色盲可区分，所以此xml文件中的这张图片色盲像素点为0
                }else{
                    //若色盲不可区分，则根据像素进行色盲区域的统计
                    for(int count=0; count<current_node->bounding_box_count; count++){
                        for(int y=current_node->y[count],flag1=0;flag1<current_node->w[count];flag1++,y++){
                            for(int x=current_node->x[count],flag2=0;flag2<current_node->l[count];flag2++,x++)
                            {
                                image[x][y] = 1;
                            }
                        }
                    }
                }
            }else{
                //当前点不是第一个xml文件读出来的节点
                if(combine_result->origin_path != current_node->origin_path){
                    //如果xml文件间的节点原始图没有一一对应，停止合并
                    qDebug()<<"step1 xml file nodes are not same!!! combine xml ends!!!";
                    return ;
                }
                //xml的节点可以对应上,则将读出的节点合并进去
                combine_result->origin_save += current_node->origin_save;
                combine_result->algorithm2_save += current_node->algorithm2_save;
                combine_result->algorithm3_save += current_node->algorithm3_save;

                for(int count=0; count<current_node->bounding_box_count; count++){
                    for(int y=current_node->y[count],flag1=0;flag1<current_node->w[count];flag1++,y++){
                        for(int x=current_node->x[count],flag2=0;flag2<current_node->l[count];flag2++,x++)
                        {
                            image[x][y] = 1;
                        }
                    }
                }
            }
        }//选定目录下所有xml文件中的同一个节点读取完毕,色盲区域像素点统计结束

        //如果当前是最后一个节点，结束while循环，不再继续后面这些操作
        if(is_last == 1)
            break;

        is_first = 0;  //将首节点标志为清零

        //步骤一： 统计原始图、算法一的图和算法二的图的保存率，若保存率超过50%则保存这张图片，否则则不保存，先统计原始图，若原始图不保存，则算法2和3肯定不保存
        //功能一的话只需考虑原始图片即可。功能2、3需要将算法2、算法3的图片分别判断是否需要保存
        double rate;
        rate = (double)combine_result->origin_save /(double) xml_list.count();
        if(rate < 0.5){
            //该图片不是色盲图片
            combine_result->origin_save = 0;
            combine_result->algorithm2_save = 0;
            combine_result->algorithm3_save = 0;
            combine_result->proportion = (double)0;
        }else{
            combine_result->origin_save = 1;
            rate = (double)combine_result->algorithm2_save /(double) xml_list.count();
            if(rate < 0.5)
                combine_result->algorithm2_save = 0;
            else
                combine_result->algorithm2_save = 1;
            rate = (double)combine_result->algorithm3_save / (double)xml_list.count();
            if(rate < 0.5)
                combine_result->algorithm3_save = 0;
            else
                combine_result->algorithm3_save = 1;

            //步骤二： 统计image数组中值为一的元素个数，从而可以计算出这张图片的色盲区域占比
            int box_value = 0;
            for(int y=0; y<300; y++){
                //cout<<endl;
                for(int x=0; x<400; x++){
                    //cout<<image[z][y];
                    if(image[x][y] == 1)
                        box_value++;
                }
            }
            combine_result->proportion = (double)box_value / (400*300);
            cout<<"proportion = "<<combine_result->proportion<<endl;

            //节点处理完毕，将该节点写入步骤一的结果xml文件中
            add_step1_xmlcombinenode(combine_result);
        }
    }

    //发送合并完成的信号
    emit combineSucceed();

}

void XMLOperation::combine2()
{
    Combine_Parameter *combine_result =  new Combine_Parameter;  //合并的结果

    bool node_is_not_null = true;  //用于判断当前xml文件中是否还有节点
    int is_first = 1; //用于标记当前是xml文件的第一个节点的标志位，因为读取第一个节点的函数和读取其他节点的函数不同
    int is_last = 0;  //用于标记当前是xml文件中的最后一个节点的标志位，用于结束while循环

    while(node_is_not_null){

        for(int i =0;i <xml_list.count();i++){
            //从xml文件中读取一个节点
            if(is_first == 1){
                current_node2 = getFirstNodeData_C2(xml_list.at(i),i);   //这里的i指第几个xml文件

                if(current_node2 == 0){
                    //若首节点都为空，说明xml文件为空，直接结束合并函数
                    node_is_not_null = false; //将标志位置为false,以结束外围循环
                    qDebug()<<"xml file is empty！！！";
                    return ;
                }
            }else{
                current_node2 = getNextNodeData_C2(i);
                if(current_node2 == 0){
                    node_is_not_null = false; //将标志位置为false,以结束外围循环
                    is_last = 1;  //用于结束while循环
                    break; //结束for循环
                }
            }

            //对该节点进行合并
            if(i == 0){
                //当前是第一个xml文件读出的节点，将以这个节点为基准进行合并
                combine_result->origin_path = current_node2->origin_path;
                combine_result->origin_save = current_node2->origin_save;
                combine_result->algorithm2_save = current_node2->algorithm2_save;
                combine_result->algorithm3_save = current_node2->algorithm3_save;
                combine_result->proportion = current_node2->proportion;


            }else{
                //当前点不是第一个xml文件读出来的节点
                if(combine_result->origin_path != current_node2->origin_path){
                    //如果xml文件间的节点原始图没有一一对应，停止合并
                    qDebug()<<"step23 xml file nodes are not same!!! combine xml ends!!!";
                    return ;
                }
                //xml的节点可以对应上,则将读出的节点合并进去
                combine_result->origin_save += current_node2->origin_save;
                combine_result->algorithm2_save += current_node2->algorithm2_save;
                combine_result->algorithm3_save += current_node2->algorithm3_save;

            }
        }//选定目录下所有xml文件中的同一个节点读取完毕

        //如果当前是最后一个节点，结束while循环，不再继续后面这些操作
        if(is_last == 1)
            break;

        is_first = 0;  //将首节点标志为清零

        //步骤一： 统计原始图、算法一的图和算法二的图的保存率，若保存率超过50%则保存这张图片，否则则不保存，先统计原始图，若原始图不保存，则算法2和3肯定不保存
        //功能一的话只需考虑原始图片即可。功能2、3需要将算法2、算法3的图片分别判断是否需要保存
        double rate;
        rate = (double)combine_result->origin_save /(double) xml_list.count();
        if(rate < 0.5){
            //该图片不需要保存
            combine_result->origin_save = 0;
            combine_result->algorithm2_save = 0;
            combine_result->algorithm3_save = 0;
            combine_result->proportion = (double)0;
        }else{
            combine_result->origin_save = 1;
            rate = (double)combine_result->algorithm2_save /(double) xml_list.count();
            if(rate < 0.5)
                combine_result->algorithm2_save = 0;
            else
                combine_result->algorithm2_save = 1;
            rate = (double)combine_result->algorithm3_save / (double)xml_list.count();
            if(rate < 0.5)
                combine_result->algorithm3_save = 0;
            else
                combine_result->algorithm3_save = 1;

            qDebug()<<"combine_result->origin_path"<<combine_result->origin_path;

            //节点处理完毕，将该节点写入步骤一的结果xml文件中
            add_step1_xmlcombinenode(combine_result);
        }
    }

    //发送合并完成的信号
    emit combineSucceed();
}
