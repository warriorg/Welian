//
//  IPhotoUp.m
//  Welian
//
//  Created by dong on 15/5/5.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IPhotoUp.h"

@implementation IPhotoUp

- (void)customOperation:(NSDictionary *)dict
{
    self.order = [[dict objectForKey:@"order"] integerValue];
}

@end
