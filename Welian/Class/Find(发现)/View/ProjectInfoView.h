//
//  ProjectInfoView.h
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ProjectInfoClickedBlock)(void);

@interface ProjectInfoView : UIView

@property (strong,nonatomic) ProjectInfoClickedBlock infoBlock;

@end
