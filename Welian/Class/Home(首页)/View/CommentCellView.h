//
//  CommentCellView.h
//  weLian
//
//  Created by dong on 14/11/22.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentHomeViewFrame.h"

@interface CommentCellView : UIImageView

@property (nonatomic, strong) CommentHomeViewFrame *commenFrame;

@property (nonatomic, weak) UIViewController *commentVC;

@end
