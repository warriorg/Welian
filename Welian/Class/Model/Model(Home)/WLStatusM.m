//
//  WLStatusM.m
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLStatusM.h"
#import "WLPhoto.h"

@implementation WLStatusM

- (void)customOperation:(NSDictionary *)dict
{
    self.user = [IBaseUserM objectWithDict:dict[@"user"]];
    self.tuiuser = [IBaseUserM objectWithDict:dict[@"tuiuser"]];
    self.card = [CardStatuModel objectWithDict:dict[@"card"]];
    self.photos = [WLPhoto objectsWithInfo:dict[@"photos"]];
    self.comments = [CommentMode objectsWithInfo:dict[@"comments"]];
    self.zans = [IBaseUserM objectsWithInfo:dict[@"zans"]];
    self.forwards = [IBaseUserM objectsWithInfo:dict[@"forwards"]];
    self.joinedusers = [IBaseUserM objectsWithInfo:dict[@"joinedusers"]];
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
        fmt.dateFormat = @"MM-dd";
        timeStr = [fmt stringFromDate:send];
    }
    return timeStr;
}

@end
