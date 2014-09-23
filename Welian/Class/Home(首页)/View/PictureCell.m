//
//  PictureCell.m
//  textF
//
//  Created by dong on 14-9-13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "PictureCell.h"

@implementation PictureCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.picImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        // 内容模式
        self.picImageV.clipsToBounds = YES;
        self.picImageV.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.picImageV];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
