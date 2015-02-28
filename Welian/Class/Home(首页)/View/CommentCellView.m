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
#import "TOWebViewController.h"

@interface CommentCellView() <M80AttributedLabelDelegate>
{
    M80AttributedLabel *oneLabel;
    M80AttributedLabel *twoLabel;
    M80AttributedLabel *threeLabel;
    M80AttributedLabel *fourLabel;
    M80AttributedLabel *fiveLabel;
    M80AttributedLabel *moreLabel;
    
    NSDictionary *_emjoDic;
    NSInteger _selectL;
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
        // 1.获得路径
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"expressionImage_custom" withExtension:@"plist"];
        // 2.读取数据
        _emjoDic = [NSDictionary dictionaryWithContentsOfURL:url];
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
            
            [self setLabelEmjoWith:oneLabel nameArray:nameArray comentStr:commenFrame.oneLabelStr labelFrame:commenFrame.oneLabelFrame];
            
            [twoLabel setHidden:YES];
            [threeLabel setHidden:YES];
            [fourLabel setHidden:YES];
            [fiveLabel setHidden:YES];
            [moreLabel setHidden:YES];
        }else if (i==1){
            [twoLabel setHidden:NO];
            [self setLabelEmjoWith:twoLabel nameArray:nameArray comentStr:commenFrame.twoLabelStr labelFrame:commenFrame.twoLabelFrame];
        }else if (i==2){
            [threeLabel setHidden:NO];
            [self setLabelEmjoWith:threeLabel nameArray:nameArray comentStr:commenFrame.threeLabelStr labelFrame:commenFrame.threeLabelFrame];
            
        }else if (i==3){
            [fourLabel setHidden:NO];
            [self setLabelEmjoWith:fourLabel nameArray:nameArray comentStr:commenFrame.fourLabelStr labelFrame:commenFrame.fourLabelFrame];
        }else if (i==4){
            [fiveLabel setHidden:NO];
            [self setLabelEmjoWith:fiveLabel nameArray:nameArray comentStr:commenFrame.fiveLabelStr labelFrame:commenFrame.fiveLabelFrame];
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

- (void)setLabelEmjoWith:(M80AttributedLabel *)Mlabel nameArray:(NSMutableArray *)nameArray comentStr:(NSString *)comentStr labelFrame:(CGRect)labelFrame
{
    [Mlabel setText:nil];
    [Mlabel setFrame:labelFrame];
    
    for (NSString *name in nameArray) {
        NSRange range = [comentStr  rangeOfString:name];
        [Mlabel addCustomLink:[NSValue valueWithRange:range]
                       forRange:range
                      linkColor:WLRGB(52, 116, 186)];
    }
    
    NSString *text = comentStr;
    // 利用正则表达式找出文本内所有的表情名，也就是中括号里面的内容
    NSArray *emotes = [self match:text withRegex:@"(?<=\\[).*?(?=\\])"];
    
    // 在字符串内前后分别添加]和[，是为了方便找出表情两边的内容
    text = [NSString stringWithFormat:@"]%@[", text];
    // 如有换行，下面的正则表达式无法查出正确的内容（求高手帮忙写个咯），因此先把换行符转义了
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    // 找出表情两边的内容
    NSArray *texts  = [self match:text withRegex:@"(?<=\\]).*?(?=\\[)"];
    
    for (NSUInteger i = 0; i < [texts count]; i++) {
        NSString *s = [texts objectAtIndex:i];
        // 根据上面的转义替换成换行符，这样绘制的时候就能换行了
        s = [s stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        [Mlabel appendText:s];
        if (i < [texts count] - 1) {
            NSString *str = [NSString stringWithFormat:@"[%@]",emotes[i]];
            [Mlabel appendImage:[UIImage imageNamed:[_emjoDic objectForKey:str]]
                          maxSize:CGSizeMake(20, 20)
                           margin:UIEdgeInsetsZero
                        alignment:M80ImageAlignmentBottom];
        }
    }
    [Mlabel sizeToFit];
}


- (NSArray *)match:(NSString *)string withRegex:(NSString *)regex {
    NSError *error;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:&error];
    NSArray *matchResults = [regularExpression matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    NSString *tmpStr = @"";
    NSMutableArray *matchs = [NSMutableArray array];
    for (NSTextCheckingResult *match in matchResults) {
        NSRange matchRange = [match range];
        tmpStr = [string substringWithRange:matchRange];
        [matchs addObject:tmpStr];
    }
    return matchs;
}


- (void)m80AttributedLabel:(M80AttributedLabel *)label clickedOnLink:(id)linkData
{
    if ([linkData isKindOfClass:[NSString class]]) {
        //普通链接
        TOWebViewController *webVC = [[TOWebViewController alloc] initWithURLString:linkData];
        [webVC setShowActionButton:NO];
        webVC.navigationButtonsHidden = YES;//隐藏底部操作栏目
        [self.commentVC.navigationController pushViewController:webVC animated:YES];
    
    }else {
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
    NSArray *commentDataArray = _commenFrame.statusM.commentsArray;
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


- (M80AttributedLabel *)newHBVLabel
{
    M80AttributedLabel *HBlabel = [[M80AttributedLabel alloc] init];
    [HBlabel setTextColor:[UIColor colorWithWhite:0.15 alpha:1.0]];
    HBlabel.font = WLFONT(14);
    [HBlabel setUnderLineForLink:NO];
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
