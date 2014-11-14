//
//  FeedAndZanCell.m
//  weLian
//
//  Created by dong on 14/11/13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "FeedAndZanCell.h"
#import "HBVLinkedTextView.h"
#import "UserInfoBasicVC.h"


@interface FeedAndZanCell ()
{
    UIImageView *_zanimageview;
    HBVLinkedTextView *_zanLabel;
    
    HBVLinkedTextView *_feedLabel;
    UIImageView *_feedimageview;
    
    
}
@end

@implementation FeedAndZanCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _zanimageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"good_small"]];
        [self.contentView addSubview:_zanimageview];
        
        _feedimageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"repost_small"]];
        [self.contentView addSubview:_feedimageview];
        
        // 1.
        _zanLabel = [[HBVLinkedTextView alloc] init];
        [_zanLabel setTextColor:[UIColor grayColor]];
        _zanLabel.font = WLZanNameFont;
        [_zanLabel setScrollEnabled:NO];
        _zanLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_zanLabel];
        
        _feedLabel = [[HBVLinkedTextView alloc] init];
        [_feedLabel setTextColor:[UIColor grayColor]];
        _feedLabel.font = WLZanNameFont;
        [_feedLabel setScrollEnabled:NO];
        _feedLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_feedLabel];

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
        [_zanimageview setFrame:feedAndZanFrame.zanImageF];
        [_zanLabel setFrame:feedAndZanFrame.zanLabelF];
        
        for (FeedAndZanModel *zanModel  in zanArray) {
            [zannameA addObject:zanModel.user.name];
        }
        
        [_zanLabel setText:feedAndZanFrame.zanNameStr];
    }else{
        [_zanLabel setHidden:YES];
        [_zanimageview setHidden:YES];
    }
    if (feedArray.count) {
        [_feedLabel setHidden:NO];
        [_feedimageview setHidden:NO];
        [_feedimageview setFrame:feedAndZanFrame.feedImageF];
        [_feedLabel setFrame:feedAndZanFrame.feedLabelF];
        
        for (FeedAndZanModel *feedModel in feedArray) {
            [feednameA addObject:feedModel.user.name];
        }
        [_feedLabel setText:feedAndZanFrame.feedNameStr];
    }else{
        [_feedLabel setHidden:YES];
        [_feedimageview setHidden:YES];
    }
    
    [_zanLabel linkStrings:zannameA
                defaultAttributes:[self exampleAttributes]
            highlightedAttributes:[self exampleAttributes]
                       tapHandler:[self exampleHandlerWithTitle:@"zan"]];
    
    [_feedLabel linkStrings:feednameA
          defaultAttributes:[self exampleAttributes]
      highlightedAttributes:[self exampleAttributes]
                 tapHandler:[self exampleHandlerWithTitle:@"feed"]];
}

- (NSMutableDictionary *)exampleAttributes
{
    return [@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
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


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
