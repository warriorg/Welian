//
//  MessageKeyboardView.m
//  weLian
//
//  Created by dong on 14-10-13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "MessageKeyboardView.h"
#import "ZBMessageManagerFaceView.h"

@interface MessageKeyboardView() <UITextFieldDelegate,UIScrollViewDelegate,ZBMessageManagerFaceViewDelegate>
{
    UIButton *_emojiBut;
    MessageCommeBlock _messageBlock;
    
    UIView *_iamgeview;
    
    BOOL keyboardIsShow;//键盘是否显示
    
    UIView *_theSuperView;
}

@property (nonatomic,strong) ZBMessageManagerFaceView *faceView;

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
        [_emojiBut addTarget:self action:@selector(showEmojiView:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_emojiBut];
        
        _commentTextView = [[WLTextField alloc] initWithFrame:CGRectMake(IWCellBorderWidth, 7, _emojiBut.frame.origin.x-IWCellBorderWidth, 35)];
        [_commentTextView.layer setMasksToBounds:YES];
        [_commentTextView.layer setCornerRadius:8.0];
        [_commentTextView.layer setBorderWidth:1.0];
        [_commentTextView.layer setBorderColor:[WLLineColor CGColor]];
        [_commentTextView setFont:[UIFont systemFontOfSize:17]];
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
        self.faceView = [[ZBMessageManagerFaceView alloc]initWithFrame:CGRectMake(0, superView.frame.size.height, superView.frame.size.width, keyboardHeight)];//216-->196
        self.faceView.delegate = self;
        [superView addSubview:self.faceView];
        
        
        [superView addSubview:self];
        // Do any additional setup after loading the view, typically from a nib.
    }
    return self;
}

- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele isSend:(BOOL)send
{
    if (send) {
        [self textFieldShouldReturn:_commentTextView];
    }else{
        if (dele) {
            
            NSString *inputString = _commentTextView.text;
            
            NSString *string = nil;
            NSInteger stringLength = inputString.length;
            if (stringLength > 0) {
                if ([@"]" isEqualToString:[inputString substringFromIndex:stringLength-1]]) {
                    if ([inputString rangeOfString:@"["].location == NSNotFound){
                        string = [inputString substringToIndex:stringLength - 1];
                    } else {
                        string = [inputString substringToIndex:[inputString rangeOfString:@"[" options:NSBackwardsSearch].location];
                    }
                } else {
                    string = [inputString substringToIndex:stringLength - 1];
                }
            }
            
            _commentTextView.text = string;
        }else{
            
            _commentTextView.text = [_commentTextView.text stringByAppendingString:faceStr];
        }
    
    }
}

-(void)showEmojiView:(UIButton*)but{
    
    [but setSelected:!but.selected];
    
    //如果直接点击表情，通过toolbar的位置来判断
    if (self.frame.origin.y== _theSuperView.bounds.size.height - toolBarHeight&&self.frame.size.height==toolBarHeight) {
        
        [UIView animateWithDuration:Time animations:^{
            self.frame = CGRectMake(0, _theSuperView.frame.size.height-keyboardHeight-toolBarHeight,  _theSuperView.bounds.size.width,toolBarHeight);
        }];
        [UIView animateWithDuration:Time animations:^{
            [self.faceView setFrame:CGRectMake(0, _theSuperView.frame.size.height-keyboardHeight,_theSuperView.frame.size.width, keyboardHeight)];
        }];
        [_commentTextView resignFirstResponder];
        return;
    }
    //如果键盘没有显示，点击表情了，隐藏表情，显示键盘
    if (!keyboardIsShow) {
        [UIView animateWithDuration:Time animations:^{
            [self.faceView setFrame:CGRectMake(0, _theSuperView.frame.size.height, _theSuperView.frame.size.width, keyboardHeight)];
        }];
        [_commentTextView becomeFirstResponder];
        
    }else{
        [_commentTextView resignFirstResponder];
        //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
        [UIView animateWithDuration:Time animations:^{
            self.frame = CGRectMake(0, _theSuperView.frame.size.height-keyboardHeight-self.frame.size.height,  _theSuperView.bounds.size.width,self.frame.size.height);
        }];
        
        [UIView animateWithDuration:Time animations:^{
            [self.faceView setFrame:CGRectMake(0, _theSuperView.frame.size.height-keyboardHeight,_theSuperView.frame.size.width, keyboardHeight)];
        }];
    }
}

//#pragma mark 隐藏键盘
-(void)dismissKeyBoard{
    //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
    [UIView animateWithDuration:Time animations:^{
        self.frame = CGRectMake(0, _theSuperView.frame.size.height-toolBarHeight,  _theSuperView.bounds.size.width,self.frame.size.height);
    }];

    [UIView animateWithDuration:Time animations:^{
        [self.faceView setFrame:CGRectMake(0, _theSuperView.frame.size.height,_theSuperView.frame.size.width, keyboardHeight)];
    }];
    [_emojiBut setSelected:NO];
    [_commentTextView resignFirstResponder];
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
        CGFloat messageViewFrameBottom = _theSuperView.frame.size.height - toolBarHeight;
        
        if(inputViewFrameY > messageViewFrameBottom){
            
            inputViewFrameY = messageViewFrameBottom;
        }
        self.frame = CGRectMake(0,
                                inputViewFrameY,
                                self.bounds.size.width,
                                toolBarHeight);

    } completion:^(BOOL finished) {
       
        
    }];

    keyboardIsShow=YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_emojiBut setSelected:NO];
}

-(void)inputKeyboardWillHide:(NSNotification *)notification{
    if (!_emojiBut.selected) {
        [self dismissKeyBoard];
    }
    keyboardIsShow=NO;
}

- (void)startCompile:(WLBasicTrends *)touser
{
    [_commentTextView becomeFirstResponder];
    [_commentTextView setPlaceholder:[NSString stringWithFormat:@"回复%@:",touser.name]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyBoard];
    if (textField.text.length) {
        _messageBlock(textField.text);
        [textField setText:nil];
    }
    return YES;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

@end
