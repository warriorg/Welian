//
//  PhotoInfos.m
//  Welian
//
//  Created by weLian on 15/2/10.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "PhotoInfos.h"
#import "ProjectDetailInfo.h"


@implementation PhotoInfos

@dynamic photo;
@dynamic title;
@dynamic picid;
@dynamic rsProjectDetailInfo;

//创建照片信息
+ (PhotoInfos *)createWithPhoto:(IPhotoInfo *)iPhotoInfo
{
    PhotoInfos *photoInfo = [PhotoInfos MR_createEntity];
    photoInfo.photo = iPhotoInfo.photo;
    photoInfo.picid = iPhotoInfo.photoid;
    // 获得文件的扩展类型
    photoInfo.title = [iPhotoInfo.photo pathExtension];
    
    return photoInfo;
}

@end
