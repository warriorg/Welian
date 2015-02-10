//
//  PhotoInfos.h
//  Welian
//
//  Created by weLian on 15/2/10.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectDetailInfo;

@interface PhotoInfos : NSManagedObject

@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) ProjectDetailInfo *rsProjectDetailInfo;

@end
