//
//  ProjectDetailView.h
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLPhotoView.h"

typedef void(^ProjectDetailImageClickedBlock)(NSIndexPath *indexPath,WLPhotoView *imageView);

@interface ProjectDetailView : UIView

@property (strong,nonatomic) IProjectDetailInfo *projectInfo;
@property (strong,nonatomic) ProjectDetailImageClickedBlock imageClickedBlock;

+ (CGFloat)configureWithInfo:(NSString *)info Images:(NSArray *)images;

@end
