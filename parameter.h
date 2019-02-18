#ifndef PARAMETER_H
#define PARAMETER_H

typedef struct PIC_PARAMETER
{
    QString origin_path;
    int origin_save;
    int algorithm2_save;
    int algorithm3_save;

    int bounding_box_count;
    double x[8];
    double y[8];
    double l[8];
    double w[8];

}Pic_Parameter;

typedef struct COMBINE_PARAMETER
{
    QString origin_path;
    int origin_save;
    int algorithm2_save;
    int algorithm3_save;

    double proportion;     //boundingbox占图片面积的比例，重叠部分只统计一次
}Combine_Parameter;



#endif // PARAMETER_H
