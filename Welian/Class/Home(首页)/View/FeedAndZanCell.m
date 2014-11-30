//
//  FeedAndZanCell.m
//  weLian
//
//  Created by dong on 14/11/13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "FeedAndZanCell.h"
#import "FeedAndZanView.h"

@interface FeedAndZanCell ()
{
    FeedAndZanView *_feedAndZanView;
}
@end

@implementation FeedAndZanCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _feedAndZanView = [[FeedAndZanView alloc] init];
        [self.contentView addSubview:_feedAndZanView];
        
    }
    return self;
}

- (void)setFeedAndZanFrame:(FeedAndZanFrameM *)feedAndZanFrame
{
    _feedAndZanFrame = feedAndZanFrame;
    [_feedAndZanView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, feedAndZanFrame.cellHigh)];
    [_feedAndZanView setFeedAndZanFrame:feedAndZanFrame];
    [_feedAndZanView setCommentVC:self.commentVC];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
