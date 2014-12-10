//
//  CommentCellView.m
//  weLian
//
//  Created by dong on 14/11/22.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "CommentCellView.h"
#import "M80AttributedLabel.h"
#import "CommentMode.h"
#import "UserInfoBasicVC.h"
#import "WLStatusM.h"
#import "CommentInfoController.h"

@interface CommentCellView() <M80AttributedLabelDelegate>
{
    M80AttributedLabel *oneLabel;
    M80AttributedLabel *twoLabel;
    M80AttributedLabel *threeLabel;
    M80AttributedLabel *fourLabel;
    M80AttributedLabel *fiveLabel;
    M80AttributedLabel *moreLabel;
}
@end

@implementation CommentCellView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        oneLabel = [self newHBVLabel];
        twoLabel = [self newHBVLabel];
        threeLabel = [self newHBVLabel];
        fourLabel = [self newHBVLabel];
        fiveLabel = [self newHBVLabel];
        moreLabel = [self newHBVLabel];
        [moreLabel setTextAlignment:kCTTextAlignmentCenter];
    }
    return self;
}

- (void)setCommenFrame:(CommentHomeViewFrame *)commenFrame
{
    _commenFrame = commenFrame;
    NSArray *commentDataArray = commenFrame.statusM.commentsArray;
    
    for (NSInteger i = 0; i<commentDataArray.count; i++) {
        CommentMode *commMode = commentDataArray[i];
        NSMutableArray *nameArray = [NSMutableArray array];
        [nameArray addObject:commMode.user.name];
        if (commMode.touser) {
            [nameArray addObject:commMode.touser.name];
        }
        if (i==0) {
            [oneLabel setFrame:commenFrame.oneLabelFrame];
            [oneLabel setText:commenFrame.oneLabelStr];
            
            for (NSString *name in nameArray) {
                NSRange range = [commenFrame.oneLabelStr  rangeOfString:name];
                [oneLabel addCustomLink:[NSValue valueWithRange:range]
                                 forRange:range
                                linkColor:WLRGB(52, 116, 186)];
            }
            
            [twoLabel setHidden:YES];
            [threeLabel setHidden:YES];
            [fourLabel setHidden:YES];
            [fiveLabel setHidden:YES];
            [moreLabel setHidden:YES];
        }else if (i==1){
            [twoLabel setHidden:NO];
            [twoLabel setFrame:commenFrame.twoLabelFrame];
            [twoLabel setText:commenFrame.twoLabelStr];
            for (NSString *name in nameArray) {
                
                NSRange range = [commenFrame.twoLabelStr rangeOfString:name];
                [twoLabel addCustomLink:[NSValue valueWithRange:range]
                               forRange:range
                              linkColor:WLRGB(52, 116, 186)];
            }
            
        }else if (i==2){
            [threeLabel setHidden:NO];
            [threeLabel setFrame:commenFrame.threeLabelFrame];
            [threeLabel setText:commenFrame.threeLabelStr];
            for (NSString *name in nameArray) {
                
                NSRange range = [commenFrame.threeLabelStr rangeOfString:name];
                [threeLabel addCustomLink:[NSValue valueWithRange:range]
                               forRange:range
                              linkColor:WLRGB(52, 116, 186)];
            }

            
        }else if (i==3){
            [fourLabel setHidden:NO];
            [fourLabel setFrame:commenFrame.fourLabelFrame];
            [fourLabel setText:commenFrame.fourLabelStr];
            for (NSString *name in nameArray) {
                NSRange range = [commenFrame.fourLabelStr rangeOfString:name];
                [fourLabel addCustomLink:[NSValue valueWithRange:range]
                                 forRange:range
                                linkColor:WLRGB(52, 116, 186)];
            }
            
        }else if (i==4){
            [fiveLabel setHidden:NO];
            [fiveLabel setFrame:commenFrame.fiveLabelFrame];
            [fiveLabel setText:commenFrame.fiveLabelStr];
            for (NSString *name in nameArray) {
                NSRange range = [commenFrame.fiveLabelStr rangeOfString:name];
                [fiveLabel addCustomLink:[NSValue valueWithRange:range]
                                forRange:range
                               linkColor:WLRGB(52, 116, 186)];
            }
            
        }
    }
    if (commenFrame.statusM.commentcount>5) {
        [moreLabel setHidden:NO];
        [moreLabel setFrame:commenFrame.moreLabelFrame];
        [moreLabel setText:commenFrame.moreLabelStr];
        NSRange range = [commenFrame.moreLabelStr rangeOfString:commenFrame.moreLabelStr];
        [moreLabel addCustomLink:[NSValue valueWithRange:range] forRange:range linkColor:WLRGB(52, 116, 186)];
    }
}


- (void)m80AttributedLabel:(M80AttributedLabel *)label clickedOnLink:(id)linkData
{
    NSRange range = [linkData rangeValue];
     NSArray *commentDataArray = _commenFrame.statusM.commentsArray;
    WLBasicTrends *usmode;
    if (label == oneLabel) {
        CommentMode *commMode = commentDataArray[0];
        NSString *linkedString = [_commenFrame.oneLabelStr substringWithRange:range];
        if ([linkedString isEqualToString:commMode.user.name]) {
            usmode = commMode.user;
        }else if ([linkedString isEqualToString:commMode.touser.name]){
            usmode = commMode.touser;
        }
    }else if(label == twoLabel){
        CommentMode *commMode = commentDataArray[1];
        NSString *linkedString = [_commenFrame.twoLabelStr substringWithRange:range];
        if ([linkedString isEqualToString:commMode.user.name]) {
            usmode = commMode.user;
        }else if ([linkedString isEqualToString:commMode.touser.name]){
            usmode = commMode.touser;
        }

    }else if (label == threeLabel){
        CommentMode *commMode = commentDataArray[2];
        NSString *linkedString = [_commenFrame.threeLabelStr substringWithRange:range];
        if ([linkedString isEqualToString:commMode.user.name]) {
            usmode = commMode.user;
        }else if ([linkedString isEqualToString:commMode.touser.name]){
            usmode = commMode.touser;
        }

    }else if (label == fourLabel){
        CommentMode *commMode = commentDataArray[3];
        NSString *linkedString = [_commenFrame.fourLabelStr substringWithRange:range];
        if ([linkedString isEqualToString:commMode.user.name]) {
            usmode = commMode.user;
        }else if ([linkedString isEqualToString:commMode.touser.name]){
            usmode = commMode.touser;
        }

    }else if (label == fiveLabel){
        CommentMode *commMode = commentDataArray[4];
        NSString *linkedString = [_commenFrame.fiveLabelStr substringWithRange:range];
        if ([linkedString isEqualToString:commMode.user.name]) {
            usmode = commMode.user;
        }else if ([linkedString isEqualToString:commMode.touser.name]){
            usmode = commMode.touser;
        }

    }else if (label == moreLabel){
        CommentInfoController *commentInfoVC = [[CommentInfoController alloc] init];
        [commentInfoVC setStatusM:_commenFrame.statusM];
        [self.commentVC.navigationController pushViewController:commentInfoVC animated:YES];
        
    }
    
    if (!usmode)  return;
    UserInfoModel *userModel = [[UserInfoModel alloc] init];
    [userModel setUid:usmode.uid];
    [userModel setAvatar:usmode.avatar];
    [userModel setName:usmode.name];
    [userModel setPosition:usmode.position];
    [userModel setCompany:usmode.company];

    UserInfoBasicVC *userbasVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:userModel isAsk:NO];
    [self.commentVC.navigationController pushViewController:userbasVC animated:YES];
}

- (M80AttributedLabel *)newHBVLabel
{
    M80AttributedLabel *HBlabel = [[M80AttributedLabel alloc] init];
    [HBlabel setTextColor:[UIColor colorWithWhite:0.15 alpha:1.0]];
    HBlabel.font = WLFONT(13);
    [HBlabel setUnderLineForLink:NO];
    [HBlabel setDelegate:self];
    HBlabel.backgroundColor = [UIColor clearColor];
    [self addSubview:HBlabel];
    return HBlabel;
}


@end
