//
//  NotstringView.m
//  weLian
//
//  Created by dong on 14/11/15.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "NotstringView.h"

@interface NotstringView ()


@end

@implementation NotstringView

- (instancetype)initWithFrame:(CGRect)frame withTitStr:(NSString *)titStr andImageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setCenter:self.center];
        CGRect imageframe = imageView.frame;
        imageframe.origin.y -= 100;
        [imageView setFrame:imageframe];
        [self addSubview:imageView];
        
        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+10, frame.size.width, 40)];
        [titLabel setText:titStr];
        [titLabel setTextAlignment:NSTextAlignmentCenter];
        [titLabel setTextColor:WLRGB(170, 178, 182)];
        [self addSubview:titLabel];
    }
    return self;
}


@end
