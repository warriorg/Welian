//
//  CommentCellView.m
//  weLian
//
//  Created by dong on 14/11/22.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "CommentCellView.h"
#import "CommentInfoController.h"
#import "TOWebViewController.h"
#import "UserInfoViewController.h"

#import "WLStatusM.h"
#import "MLEmojiLabel.h"
#import "CommentMode.h"

@interface CommentCellView() <MLEmojiLabelDelegate>
{
    MLEmojiLabel *oneLabel;
    MLEmojiLabel *twoLabel;
    MLEmojiLabel *threeLabel;
    MLEmojiLabel *fourLabel;
    MLEmojiLabel *fiveLabel;
    MLEmojiLabel *moreLabel;
    
    NSInteger _selectL;
}
@end

@implementation CommentCellView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        self.backgroundColor = [UIColor clearColor];
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
    NSArray *commentDataArray = commenFrame.statusM.comments;
    [oneLabel setHidden:YES];
    [twoLabel setHidden:YES];
    [threeLabel setHidden:YES];
    [fourLabel setHidden:YES];
    [fiveLabel setHidden:YES];
    [moreLabel setHidden:YES];
    if (!commentDataArray.count) return;
    for (NSInteger i = 0; i<commentDataArray.count; i++) {
        CommentMode *commMode = commentDataArray[i];
        
        if (i==0) {
            [oneLabel setHidden:NO];
            [self setLableEmjoWith:oneLabel andCommMode:commMode labelFrame:commenFrame.oneLabelFrame];
        }else if (i==1){
            [twoLabel setHidden:NO];
            [self setLableEmjoWith:twoLabel andCommMode:commMode labelFrame:commenFrame.twoLabelFrame];
        }else if (i==2){
            [threeLabel setHidden:NO];
            [self setLableEmjoWith:threeLabel andCommMode:commMode labelFrame:commenFrame.threeLabelFrame];
        }else if (i==3){
            [fourLabel setHidden:NO];
            [self setLableEmjoWith:fourLabel andCommMode:commMode labelFrame:commenFrame.fourLabelFrame];
        }else if (i==4){
            [fiveLabel setHidden:NO];
            [self setLableEmjoWith:fiveLabel andCommMode:commMode labelFrame:commenFrame.fiveLabelFrame];
        }
    }
    if (commenFrame.statusM.commentcount.integerValue>5) {
        [moreLabel setHidden:NO];
        [moreLabel setFrame:commenFrame.moreLabelFrame];
        [moreLabel setText:commenFrame.moreLabelStr];
        NSRange range = [commenFrame.moreLabelStr rangeOfString:commenFrame.moreLabelStr];
        [moreLabel addLinkToAddress:@{} withRange:range];
    }
}

- (void)setLableEmjoWith:(MLEmojiLabel *)mlLabel andCommMode:(CommentMode *)commMode labelFrame:(CGRect)labelFrame
{
    [mlLabel setText:commMode.commentAndName];
    [mlLabel setFrame:labelFrame];
    NSRange userRange = [commMode.commentAndName  rangeOfString:commMode.user.name];
    [mlLabel addLinkToAddress:@{@"user":commMode.user} withRange:userRange];
    if (commMode.touser) {
        NSRange touserRange = [commMode.commentAndName  rangeOfString:commMode.touser.name];
        [mlLabel addLinkToAddress:@{@"user":commMode.touser} withRange:touserRange];
    }
    [mlLabel sizeToFit];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
    if (label == moreLabel) {
        CommentInfoController *commentInfoVC = [[CommentInfoController alloc] init];
        [commentInfoVC setStatusM:_commenFrame.statusM];
        [self.commentVC.navigationController pushViewController:commentInfoVC animated:YES];
    }else{
        IBaseUserM *userModel = addressComponents[@"user"];
        if (!userModel)  return;
//         = [[IBaseUserM alloc] init];
//        [userModel setUid:usmode.uid];
//        [userModel setAvatar:usmode.avatar];
//        [userModel setName:usmode.name];
//        [userModel setPosition:usmode.position];
//        [userModel setCompany:usmode.company];
        
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithBaseUserM:userModel OperateType:nil HidRightBtn:NO];
        [self.commentVC.navigationController pushViewController:userInfoVC animated:YES];
    }
}

- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type
{
    if (type == MLEmojiLabelLinkTypeURL) {
        //普通链接
        TOWebViewController *webVC = [[TOWebViewController alloc] initWithURLString:link];
        [webVC setShowActionButton:NO];
        webVC.navigationButtonsHidden = YES;//隐藏底部操作栏目
        [self.commentVC.navigationController pushViewController:webVC animated:YES];
    }
}


#pragma mark - Copying Method

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [super becomeFirstResponder];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copyText:));
}
//针对于copy的实现
-(void)copyText:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    NSArray *commentDataArray = _commenFrame.statusM.comments;
    CommentMode *commMode = commentDataArray[_selectL];
    pboard.string = commMode.comment;
}

- (void)longPressGestureRecognizerHandle:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (longPressGestureRecognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
        return;
    
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyText:)];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:@[copyItem]];
    UIView *selectV = longPressGestureRecognizer.view;
    CGRect targetRect = [self convertRect:selectV.frame
                                 fromView:self];
    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    [menu setMenuVisible:YES animated:YES];
    if (selectV == oneLabel) {
        _selectL = 0;
    }else if (selectV == twoLabel){
        _selectL = 1;
    }else if (selectV == threeLabel){
        _selectL = 2;
    }else if (selectV == fourLabel){
        _selectL = 3;
    }else if (selectV == fiveLabel){
        _selectL = 4;
    }
}


- (MLEmojiLabel *)newHBVLabel
{
    MLEmojiLabel *HBlabel = [[MLEmojiLabel alloc] init];
    HBlabel.hidden = YES;
    [HBlabel setTextColor:[UIColor colorWithWhite:0.25 alpha:1.0]];
    HBlabel.font = WLFONT(14);
    [HBlabel setDelegate:self];
    [HBlabel setLineSpacing:1];
    HBlabel.backgroundColor = [UIColor clearColor];
    [self addSubview:HBlabel];
    // 长按手势 复制
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerHandle:)];
    [recognizer setMinimumPressDuration:0.4f];
    [HBlabel addGestureRecognizer:recognizer];
    return HBlabel;
}


@end
