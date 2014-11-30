//
//  FeedAndZanView.m
//  weLian
//
//  Created by dong on 14/11/22.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "FeedAndZanView.h"
//#import "HBVLinkedTextView.h"
#import "M80AttributedLabel.h"
#import "UserInfoBasicVC.h"

@interface FeedAndZanView() <M80AttributedLabelDelegate>
{
    UIImageView *_zanimageview;
    M80AttributedLabel *_zanLabel;
    
    M80AttributedLabel *_feedLabel;
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
        
        _zanLabel = [[M80AttributedLabel alloc] init];
        [_zanLabel setTextColor:[UIColor grayColor]];
        [_zanLabel setDelegate:self];
        [_zanLabel setUnderLineForLink:NO];
        _zanLabel.font = WLZanNameFont;
        _zanLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_zanLabel];
        
        _feedLabel = [[M80AttributedLabel alloc] init];
        [_feedLabel setTextColor:[UIColor grayColor]];
        [_feedLabel setDelegate:self];
        [_feedLabel setUnderLineForLink:NO];
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
    
    if (zanArray.count) {
        [_zanimageview setHidden:NO];
        [_zanLabel setHidden:NO];
        [_zanimageview setFrame:feedAndZanFrame.zanImageF];
        [_zanLabel setFrame:feedAndZanFrame.zanLabelF];
        [_zanLabel setText:feedAndZanFrame.zanNameStr];
        
        for (FeedAndZanModel *zanModel  in zanArray) {
            
            NSRange range = [feedAndZanFrame.zanNameStr rangeOfString:zanModel.user.name];
            [_zanLabel addCustomLink:[NSValue valueWithRange:range]
                                    forRange:range
                                   linkColor:IWRetweetNameColor];
        }
        
    }else{
        [_zanLabel setHidden:YES];
        [_zanimageview setHidden:YES];
    }
    if (feedArray.count) {
        [_feedLabel setHidden:NO];
        [_feedimageview setHidden:NO];
        [_feedLabel setFrame:feedAndZanFrame.feedLabelF];
        [_feedimageview setFrame:feedAndZanFrame.feedImageF];
        [_feedLabel setText:feedAndZanFrame.feedNameStr];
        for (FeedAndZanModel *feedModel in feedArray) {
            NSRange range = [feedAndZanFrame.feedNameStr rangeOfString:feedModel.user.name];
            [_feedLabel addCustomLink:[NSValue valueWithRange:range]
                            forRange:range
                           linkColor:IWRetweetNameColor];
        }
    }else{
        [_feedLabel setHidden:YES];
        [_feedimageview setHidden:YES];
    }
}

- (void)m80AttributedLabel:(M80AttributedLabel *)label clickedOnLink:(id)linkData
{
    
    NSDictionary *dataDic = self.feedAndZanFrame.feedAndzanDic;
    NSRange range = [linkData rangeValue];
    if ([linkData isKindOfClass:[NSString class]]) {
        
    }else {
        
        UserInfoModel *mode;
        if (label == _zanLabel ) {
            NSString *linkedString = [_feedAndZanFrame.zanNameStr substringWithRange:range];
            NSArray *zanArray = [dataDic objectForKey:@"zans"];
            for (FeedAndZanModel *zanmode in zanArray) {
                if ([zanmode.user.name isEqualToString:linkedString]) {
                    mode = zanmode.user;
                }
            }
            
        }else if (label == _feedLabel){
            NSString *linkedString = [_feedAndZanFrame.feedNameStr substringWithRange:range];
            NSArray *feedArray = [dataDic objectForKey:@"forwards"];
            for (FeedAndZanModel *feedmode in feedArray) {
                if ([feedmode.user.name isEqualToString:linkedString]) {
                    mode = feedmode.user;
                }
            }
        }
        if (!mode) return;
        UserInfoBasicVC *userbasVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:mode isAsk:NO];
        [self.commentVC.navigationController pushViewController:userbasVC animated:YES];
    }
}

@end
