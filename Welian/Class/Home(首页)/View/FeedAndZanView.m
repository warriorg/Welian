//
//  FeedAndZanView.m
//  weLian
//
//  Created by dong on 14/11/22.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "FeedAndZanView.h"
#import "HBVLinkedTextView.h"
#import "UserInfoBasicVC.h"

@interface FeedAndZanView()
{
    UIImageView *_zanimageview;
    HBVLinkedTextView *_zanLabel;
    
    HBVLinkedTextView *_feedLabel;
    UIImageView *_feedimageview;
    
}

@end

@implementation FeedAndZanView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        _zanimageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"good_small"]];
        [self addSubview:_zanimageview];
        
        _feedimageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"repost_small"]];
        [self addSubview:_feedimageview];
        
        _zanLabel = [[HBVLinkedTextView alloc] init];
        [_zanLabel setTextColor:[UIColor grayColor]];
        _zanLabel.font = WLZanNameFont;
        _zanLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_zanLabel];
        
        _feedLabel = [[HBVLinkedTextView alloc] init];
        [_feedLabel setTextColor:[UIColor grayColor]];
        _feedLabel.font = WLZanNameFont;
        _feedLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_feedLabel];
    }
    return self;
}

- (void)setFeedAndZanFrame:(FeedAndZanFrameM *)feedAndZanFrame
{
    _feedAndZanFrame = feedAndZanFrame;
    NSDictionary *dataDic = feedAndZanFrame.feedAndzanDic;
    NSArray *zanArray = [dataDic objectForKey:@"zans"];
    NSArray *feedArray = [dataDic objectForKey:@"forwards"];
    NSMutableArray *zannameA = [NSMutableArray array];
    NSMutableArray *feednameA = [NSMutableArray array];
    
    if (zanArray.count) {
        [_zanimageview setHidden:NO];
        [_zanLabel setHidden:NO];
        [_zanLabel setUserInteractionEnabled:YES];
        [_zanimageview setFrame:feedAndZanFrame.zanImageF];
        [_zanLabel setFrame:feedAndZanFrame.zanLabelF];
        [_zanLabel setText:feedAndZanFrame.zanNameStr];
        
        for (FeedAndZanModel *zanModel  in zanArray) {
            [zannameA addObject:zanModel.user.name];
        }
        [_zanLabel linkStrings:zannameA
             defaultAttributes:[self exampleAttributes]
         highlightedAttributes:[self exampleAttributes]
                    tapHandler:[self exampleHandlerWithTitle:@"zan"]];
        
    }else{
        [_zanLabel setUserInteractionEnabled:NO];
        [_zanLabel setHidden:YES];
        [_zanimageview setHidden:YES];
    }
    if (feedArray.count) {
        [_feedLabel setHidden:NO];
        [_feedLabel setUserInteractionEnabled:YES];
        [_feedimageview setHidden:NO];
        [_feedLabel setFrame:feedAndZanFrame.feedLabelF];
        [_feedimageview setFrame:feedAndZanFrame.feedImageF];
        [_feedLabel setText:feedAndZanFrame.feedNameStr];
        for (FeedAndZanModel *feedModel in feedArray) {
            [feednameA addObject:feedModel.user.name];
        }
        [_feedLabel linkStrings:feednameA
              defaultAttributes:[self exampleAttributes]
          highlightedAttributes:[self exampleAttributes]
                     tapHandler:[self exampleHandlerWithTitle:@"feed"]];
    }else{
        [_feedLabel setHidden:YES];
        [_feedLabel setUserInteractionEnabled:NO];
        [_feedimageview setHidden:YES];
    }
//    DLog(@"%@----%@",feedAndZanFrame.zanNameStr,feedAndZanFrame.feedNameStr);
}

- (NSMutableDictionary *)exampleAttributes
{
    return [@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
              NSForegroundColorAttributeName:IWRetweetNameColor}mutableCopy];
}

- (LinkedStringTapHandler)exampleHandlerWithTitle:(NSString *)title
{
    NSDictionary *dataDic = self.feedAndZanFrame.feedAndzanDic;
    
    LinkedStringTapHandler exampleHandler = ^(NSString *linkedString) {
        UserInfoModel *mode;
        if ([title isEqualToString:@"zan"]) {
            
            NSArray *zanArray = [dataDic objectForKey:@"zans"];
            for (FeedAndZanModel *zanmode in zanArray) {
                if ([zanmode.user.name isEqualToString:linkedString]) {
                    mode = zanmode.user;
                }
            }
        }else if ([title isEqualToString:@"feed"]){
            
            NSArray *feedArray = [dataDic objectForKey:@"forwards"];
            for (FeedAndZanModel *feedmode in feedArray) {
                if ([feedmode.user.name isEqualToString:linkedString]) {
                    mode = feedmode.user;
                }
            }
        }
        UserInfoBasicVC *userbasVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:mode isAsk:NO];
        [self.commentVC.navigationController pushViewController:userbasVC animated:YES];
        
    };
    return exampleHandler;
}


@end
