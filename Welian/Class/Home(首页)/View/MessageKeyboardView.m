//
//  MessageKeyboardView.m
//  weLian
//
//  Created by dong on 14-10-13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "MessageKeyboardView.h"
#import "ZBMessageManagerFaceView.h"
#import "WUDemoKeyboardBuilder.h"

@interface MessageKeyboardView() <UITextViewDelegate,UIScrollViewDelegate,HPGrowingTextViewDelegate>
{
    UIButton *_emojiBut;
    MessageCommeBlock _messageBlock;
    
    UIView *_iamgeview;
    
    BOOL keyboardIsShow;//键盘是否显示
    
    UIView *_theSuperView;
}

//@property (nonatomic,strong) ZBMessageManagerFaceView *faceView;

@end

@implementation MessageKeyboardView


- (instancetype)initWithFrame:(CGRect)frame andSuperView:(UIView *)superView withMessageBlock:(MessageCommeBlock)messageBlock
{
    keyboardIsShow=NO;
    _theSuperView = superView;
    _messageBlock = messageBlock;
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        [linView setBackgroundColor:WLLineColor];
        [self addSubview:linView];
        
        _emojiBut = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-IWCellBorderWidth-40, 5, 40, 40)];
        [_emojiBut setImage:[UIImage imageNamed:@"me_circle_chat_emoji"] forState:UIControlStateNormal];
        [_emojiBut setImage:[UIImage imageNamed:@"me_circle_chat_keybroad"] forState:UIControlStateSelected];
        [_emojiBut addTarget:self action:@selector(switchKeyboard:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_emojiBut];
        
        _commentTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(IWCellBorderWidth, 7, _emojiBut.frame.origin.x-IWCellBorderWidth, 35)];
        _commentTextView.animateHeightChange = NO;
        _commentTextView.animationDuration = 0.01;
        _commentTextView.minNumberOfLines = 1;
        _commentTextView.maxNumberOfLines = 3;
        [_commentTextView.layer setMasksToBounds:YES];
        [_commentTextView.layer setCornerRadius:8.0];
        [_commentTextView.layer setBorderWidth:1.0];
        [_commentTextView.layer setBorderColor:[WLLineColor CGColor]];
        [_commentTextView setFont:kNormal15Font];
        [_commentTextView setReturnKeyType:UIReturnKeySend];
        [_commentTextView setPlaceholder:@"写评论..."];
        [_commentTextView setDelegate:self];
        [self addSubview:_commentTextView];
        
        //给键盘注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [superView addSubview:self];
        // Do any additional setup after loading the view, typically from a nib.
    }
    return self;
}


- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float bottom = self.bottom;
    [self setHeight:height + 13];
    [self setBottom:bottom];
    if (self.textHighBlock) {
        self.textHighBlock(self.height);
    }
}

- (void)switchKeyboard:(UIButton *)sender {
    [_emojiBut setSelected:!_emojiBut.selected];
    WEAKSELF
    if (_commentTextView.internalTextView.isFirstResponder) {
        if (_commentTextView.internalTextView.emoticonsKeyboard) [_commentTextView.internalTextView switchToDefaultKeyboard];
        else {
            WUEmoticonsKeyboard *keyboard = [WUDemoKeyboardBuilder sharedEmoticonsKeyboard];
            [keyboard setHideSendBut:NO];
            [keyboard setSpaceButtonTappedBlock:^{
//                _messageBlock(_commentTextView.text);
                [weakSelf sendMessgeText];
            }];
            [_commentTextView.internalTextView switchToEmoticonsKeyboard:keyboard];

//            [_commentTextView switchToEmoticonsKeyboard:[WUDemoKeyboardBuilder sharedEmoticonsKeyboard]];
        }
    }else{
        WUEmoticonsKeyboard *keyboard = [WUDemoKeyboardBuilder sharedEmoticonsKeyboard];
        [keyboard setHideSendBut:NO];
        [keyboard setSpaceButtonTappedBlock:^{
            [weakSelf sendMessgeText];
        }];
        [_commentTextView.internalTextView switchToEmoticonsKeyboard:keyboard];
//        [_commentTextView switchToEmoticonsKeyboard:[WUDemoKeyboardBuilder sharedEmoticonsKeyboard]];
        [_commentTextView.internalTextView becomeFirstResponder];
    }
}


//#pragma mark 隐藏键盘
-(void)dismissKeyBoard{
    //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
    [UIView animateWithDuration:Time animations:^{
        self.frame = CGRectMake(0, _theSuperView.frame.size.height-self.frame.size.height,  _theSuperView.bounds.size.width,self.frame.size.height);
    }];
    [_emojiBut setSelected:NO];
    [_commentTextView.internalTextView switchToDefaultKeyboard];
    [_commentTextView.internalTextView resignFirstResponder];
}

#pragma mark 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification{
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:animationTime animations:^{
        
        CGFloat keyboardY = [_theSuperView convertRect:keyBoardFrame fromView:nil].origin.y;
        
        CGFloat inputViewFrameY = keyboardY - self.bounds.size.height;
        
        // for ipad modal form presentations
        CGFloat messageViewFrameBottom = _theSuperView.frame.size.height - self.frame.size.height;
        
        if(inputViewFrameY > messageViewFrameBottom){
            
            inputViewFrameY = messageViewFrameBottom;
        }
        self.frame = CGRectMake(0,
                                inputViewFrameY,
                                self.bounds.size.width,
                                self.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    keyboardIsShow=YES;
}

-(void)inputKeyboardWillHide:(NSNotification *)notification{
    if (!_emojiBut.selected) {
        [self dismissKeyBoard];
    }
    keyboardIsShow=NO;
}

- (void)startCompile:(WLBasicTrends *)touser
{
    if (!touser) {
        [_commentTextView setPlaceholder:@"写评论..."];
        return;
    }
    [_commentTextView becomeFirstResponder];
    [_commentTextView setPlaceholder:[NSString stringWithFormat:@"回复%@:",touser.name]];
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self sendMessgeText];
        //        if (textView.text.length) {
        //            _messageBlock(textView.text);
        //            [textView setText:nil];
        //        }
        //        [self textviewChangeHigh:CGSizeMake(textView.bounds.size.width, 35) withTextView:textView];
        //        [self dismissKeyBoard];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)sendMessgeText
{
    if (_commentTextView.text.length) {
        _messageBlock(_commentTextView.text);
        [_commentTextView setText:nil];
    }
    [self dismissKeyBoard];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

@end
