//
//  CommentHeadView.m
//  weLian
//
//  Created by dong on 14/11/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "CommentHeadView.h"
#import "WLContentCellView.h"

@interface CommentHeadView()
{
    //    /** 内容 */
    WLContentCellView *_contentView;
}
@end


@implementation CommentHeadView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        // 清除cell默认的背景色(才能只显示背景view、背景图片)
        self.backgroundColor = [UIColor clearColor];
        
        _cellHeadView = [[WLCellHead alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
        [self addSubview:_cellHeadView];
        
        _contentView = [[WLContentCellView alloc] init];
        __weak CommentHeadView *weakcell = self;
        _contentView.feedzanBlock = ^(WLStatusM *statusM){
            if (weakcell.feezanBlock) {
                weakcell.feezanBlock (statusM);
            }
        };
        
        [self addSubview:_contentView];
    }
    return self;
}

- (void)setCommHeadFrame:(CommentHeadFrame *)commHeadFrame
{
    _commHeadFrame = commHeadFrame;
    
    WLStatusM *status = commHeadFrame.status;
    WLBasicTrends *user = status.user;
    WLContentCellFrame *contenFrame = commHeadFrame.contentFrame;
    
    [_cellHeadView setUser:user];
    [_cellHeadView setControllVC:self.homeVC];
    
    [_contentView setCommentFrame:commHeadFrame];
    [_contentView setFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, contenFrame.cellHeight)];
    [_contentView setHomeVC:self.homeVC];
}

@end
