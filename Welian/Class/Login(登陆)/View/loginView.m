//
//  loginView.m
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "loginView.h"

@implementation loginView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.layer setCornerRadius:10];
        [self.layer setMasksToBounds:YES];
        

    }
    return self;
}

@end
