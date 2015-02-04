//
//  ProjectDetailView.h
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectDetailView : UIView

@property (strong,nonatomic) IProjectDetailInfo *projectInfo;

+ (CGFloat)configureWithInfo:(NSString *)info Images:(NSArray *)images;

@end
