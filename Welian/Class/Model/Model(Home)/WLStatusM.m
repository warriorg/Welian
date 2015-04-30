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
    if ([dict objectForKey:@"tuiuser"]) {
        self.tuiuser = [IBaseUserM objectWithDict:dict[@"tuiuser"]];
    }
    if ([dict objectForKey:@"card"]) {
        
        self.card = [CardStatuModel objectWithDict:dict[@"card"]];
    }
    if ([dict objectForKey:@"photos"]) {
        
        self.photos = [WLPhoto objectsWithInfo:dict[@"photos"]];
    }
    if ([dict objectForKey:@"comments"]) {
        
        self.comments = [CommentMode objectsWithInfo:dict[@"comments"]];
    }
    if ([dict objectForKey:@"zans"]) {
        
        self.zans = [IBaseUserM objectsWithInfo:dict[@"zans"]];
    }
    if ([dict objectForKey:@"forwards"]) {
        
        self.forwards = [IBaseUserM objectsWithInfo:dict[@"forwards"]];
    }
    if ([dict objectForKey:@"joinedusers"]) {
        
        self.joinedusers = [NSMutableArray arrayWithArray:[IBaseUserM objectsWithInfo:dict[@"joinedusers"]]];
    }
    
    if (self.type.integerValue==5||self.type.integerValue==12) {
        [self.joinedusers addObject:self.user];
    }
    self.created = [self getCreated];
}

- (NSString *)getCreated
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
