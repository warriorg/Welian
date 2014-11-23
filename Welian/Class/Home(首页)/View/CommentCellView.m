//
//  CommentCellView.m
//  weLian
//
//  Created by dong on 14/11/22.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "CommentCellView.h"
#import "HBVLinkedTextView.h"
#import "CommentMode.h"
#import "UserInfoBasicVC.h"
#import "WLStatusM.h"
#import "CommentInfoController.h"

@interface CommentCellView()
{
    HBVLinkedTextView *oneLabel;
    HBVLinkedTextView *twoLabel;
    HBVLinkedTextView *threeLabel;
    HBVLinkedTextView *fourLabel;
    HBVLinkedTextView *fiveLabel;
    HBVLinkedTextView *moreLabel;
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
        [moreLabel setTextAlignment:NSTextAlignmentCenter];
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

            [oneLabel linkStrings:nameArray
                 defaultAttributes:[self exampleAttributes]
             highlightedAttributes:[self exampleAttributes]
                        tapHandler:[self exampleHandlerWithTitle:@"0"]];
            [twoLabel setUserInteractionEnabled:NO];
            [threeLabel setUserInteractionEnabled:NO];
            [fourLabel setUserInteractionEnabled:NO];
            [fiveLabel setUserInteractionEnabled:NO];
            [moreLabel setUserInteractionEnabled:NO];
            [twoLabel setHidden:YES];
            [threeLabel setHidden:YES];
            [fourLabel setHidden:YES];
            [fiveLabel setHidden:YES];
            [moreLabel setHidden:YES];
        }else if (i==1){
            [twoLabel setHidden:NO];
            [twoLabel setUserInteractionEnabled:YES];
            [twoLabel setFrame:commenFrame.twoLabelFrame];
            [twoLabel setText:commenFrame.twoLabelStr];
            [twoLabel linkStrings:nameArray
               defaultAttributes:[self exampleAttributes]
           highlightedAttributes:[self exampleAttributes]
                      tapHandler:[self exampleHandlerWithTitle:@"1"]];
            
        }else if (i==2){
            [threeLabel setHidden:NO];
            [threeLabel setUserInteractionEnabled:YES];
            [threeLabel setFrame:commenFrame.threeLabelFrame];
            [threeLabel setText:commenFrame.threeLabelStr];
            [threeLabel linkStrings:nameArray
               defaultAttributes:[self exampleAttributes]
           highlightedAttributes:[self exampleAttributes]
                      tapHandler:[self exampleHandlerWithTitle:@"2"]];
            
        }else if (i==3){
            [fourLabel setHidden:NO];
            [fourLabel setUserInteractionEnabled:YES];
            [fourLabel setFrame:commenFrame.fourLabelFrame];
            [fourLabel setText:commenFrame.fourLabelStr];
            [fourLabel linkStrings:nameArray
               defaultAttributes:[self exampleAttributes]
           highlightedAttributes:[self exampleAttributes]
                      tapHandler:[self exampleHandlerWithTitle:@"3"]];
            
        }else if (i==4){
            [fiveLabel setHidden:NO];
            [fiveLabel setUserInteractionEnabled:YES];
            [fiveLabel setFrame:commenFrame.fiveLabelFrame];
            [fiveLabel setText:commenFrame.fiveLabelStr];
            [fiveLabel linkStrings:nameArray
               defaultAttributes:[self exampleAttributes]
           highlightedAttributes:[self exampleAttributes]
                      tapHandler:[self exampleHandlerWithTitle:@"4"]];
            
        }
    }
    if (commenFrame.statusM.commentcount>5) {
        [moreLabel setHidden:NO];
        [moreLabel setUserInteractionEnabled:YES];
        [moreLabel setFrame:commenFrame.moreLabelFrame];
        [moreLabel setText:commenFrame.moreLabelStr];
        [moreLabel linkString:commenFrame.moreLabelStr
            defaultAttributes:[self exampleAttributes]
        highlightedAttributes:[self exampleAttributes]
                   tapHandler:[self exampleHandlerWithTitle:@"5"]];
    }
}

- (NSMutableDictionary *)exampleAttributes
{
    return [@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
              NSForegroundColorAttributeName:IWRetweetNameColor}mutableCopy];
}

- (LinkedStringTapHandler)exampleHandlerWithTitle:(NSString *)title
{
    NSArray *commentDataArray = _commenFrame.statusM.commentsArray;
    NSInteger indx = [title integerValue];
    if (indx != 5) {
        CommentMode *commMode = commentDataArray[indx];
        LinkedStringTapHandler exampleHandler = ^(NSString *linkedString) {
            WLBasicTrends *usmode;
            if ([linkedString isEqualToString:commMode.user.name]) {
                usmode = commMode.user;
            }else if ([linkedString isEqualToString:commMode.touser.name]){
                usmode = commMode.touser;
            }
            UserInfoModel *userModel = [[UserInfoModel alloc] init];
            [userModel setUid:usmode.uid];
            [userModel setAvatar:usmode.avatar];
            [userModel setName:usmode.name];
            [userModel setPosition:usmode.position];
            [userModel setCompany:usmode.company];
            
            UserInfoBasicVC *userbasVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:userModel isAsk:NO];
            [self.commentVC.navigationController pushViewController:userbasVC animated:YES];

        };
        return exampleHandler;
    }else if(indx == 5){
        
        LinkedStringTapHandler exampleHandler = ^(NSString *linkedString) {
            
            
        };
        return exampleHandler;
//        CommentInfoController *commentInfoVC = [[CommentInfoController alloc] init];
////        commentInfoVC setStatusFrame:<#(WLStatusFrame *)#>
//        [self.commentVC.navigationController pushViewController:commentInfoVC animated:YES];
        
    }
    return nil;
    
}


- (HBVLinkedTextView *)newHBVLabel
{
    HBVLinkedTextView *HBlabel = [[HBVLinkedTextView alloc] init];
    [HBlabel setTextColor:[UIColor darkGrayColor]];
    HBlabel.font = WLZanNameFont;
    HBlabel.backgroundColor = [UIColor clearColor];
    [self addSubview:HBlabel];
    return HBlabel;
}


@end
