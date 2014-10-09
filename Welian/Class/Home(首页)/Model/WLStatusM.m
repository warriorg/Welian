//
//  WLStatusM.m
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLStatusM.h"
#import "MJExtension.h"
#import "WLPhoto.h"


@implementation WLStatusM

- (NSDictionary *)arrayModelClasses
{
    return @{@"photos" : [WLPhoto class]};
}


- (NSString *)created
{
    // 1.获得微博的发送时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *send = [fmt dateFromString:_created];
    
    // 2.当前时间
    NSDate *now = [NSDate date];
    
    // 3.获得当前时间和发送时间 的 间隔  (now - send)
    NSString *timeStr = nil;
    NSTimeInterval delta = [now timeIntervalSinceDate:send];
    if (delta < 60) { // 一分钟内
        timeStr = @"刚刚";
    } else if (delta < 60 * 60) { // 一个小时内
        timeStr = [NSString stringWithFormat:@"%.f分钟前", delta/60];
    } else if (delta < 60 * 60 * 24) { // 一天内
        timeStr = [NSString stringWithFormat:@"%.f小时前", delta/60/60];
    } else { // 几天前
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        timeStr = [fmt stringFromDate:send];
    }
    return timeStr;
}

@end
