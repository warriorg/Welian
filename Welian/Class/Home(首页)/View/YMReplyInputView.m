//
//  HXReplyInputView.m
//  Hongxiu
//
//  Created by 吴福虎 on 14-8-18.
//  Copyright (c) 2014年 FeeTan. All rights reserved.
//

#import "YMReplyInputView.h"


@interface NSString (YMReplyInputView)
@end

@implementation NSString (HXReplyInputView)

- (CGSize) sizeForFont:(UIFont *)font
{
    if ([self respondsToSelector:@selector(sizeWithAttributes:)])
    {
        NSDictionary* attribs = @{NSFontAttributeName:font};
        return ([self sizeWithAttributes:attribs]);
    }
    return ([self sizeWithFont:font]);
   // return
}

- (CGSize) sizeForFont:(UIFont*)font
     constrainedToSize:(CGSize)constraint
         lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize size;
    if ([self respondsToSelector:@selector(sizeWithAttributes:)])
    {
        NSDictionary *attributes = @{NSFontAttributeName:font};
        
        CGSize boundingBox = [self boundingRectWithSize:constraint options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    }
    else
    {
        size = [self sizeWithFont:font constrainedToSize:constraint lineBreakMode:lineBreakMode];
    }
    
    return size;
}

@end


@implementation YMReplyInputView

- (void) composeView
{
  
    keyboardAnimationDuration = 0.4f;
    self.ymkeyboardHeight = 216;
    topGap = 8;
    
    inputHeight = 38.0f;
    inputHeightWithShadow = 44.0f;
    _autoResizeOnKeyboardVisibilityChanged = NO;
    
    CGSize size = self.frame.size;
    
	_inputBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	_inputBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _inputBackgroundView.contentMode = UIViewContentModeScaleToFill;
    _inputBackgroundView.backgroundColor = [UIColor clearColor];
	[self addSubview:_inputBackgroundView];
    
    
    
    _textViewBackgroundView = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _textViewBackgroundView.borderStyle = UITextBorderStyleRoundedRect;
	_textViewBackgroundView.autoresizingMask = UIViewAutoresizingNone;
    _textViewBackgroundView.userInteractionEnabled = NO;
    _textViewBackgroundView.enabled = NO;
	[self addSubview:_textViewBackgroundView];
    
	_textView = [[UITextView alloc] initWithFrame:CGRectMake(70.0f, topGap, 185, 0)];
    _textView.backgroundColor = [UIColor clearColor];
	_textView.delegate = self;
    _textView.contentInset = UIEdgeInsetsMake(-4, -2, -4, 0);
    _textView.showsVerticalScrollIndicator = NO;
    _textView.showsHorizontalScrollIndicator = NO;
    _textView.returnKeyType = UIReturnKeySend;
	_textView.font = [UIFont systemFontOfSize:15.0f];
	[self addSubview:_textView];
    
    [self adjustTextInputHeightForText:@"" animated:NO];
    
    _lblPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(78.0f, topGap+2, 160, 20)];
    _lblPlaceholder.font = [UIFont systemFontOfSize:15.0f];
    _lblPlaceholder.text = @"评论...";
    _lblPlaceholder.textColor = [UIColor lightGrayColor];
    _lblPlaceholder.backgroundColor = [UIColor clearColor];
	[self addSubview:_lblPlaceholder];
    
	_sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setTitle:@"发表" forState:0];
    [_sendButton setBackgroundImage:[[UIImage imageNamed:@"button_send_comment.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:22] forState:UIControlStateNormal];
	_sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [_sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_sendButton];
    [self sendSubviewToBack:_inputBackgroundView];

    self.backgroundColor = [UIColor colorWithRed:(0xD9 / 255.0) green:(0xDC / 255.0) blue:(0xE0 / 255.0) alpha:1.0];
    [self showCommentView];
 }

- (void)layoutSubviews
{
    [super layoutSubviews];
    
  //最上面的一条细线
    UILabel *dividLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 321, 1)];
   
    dividLbl.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:229/255.0 alpha:1.0];
    [self addSubview:dividLbl];
    
    
    self.backgroundColor = [UIColor whiteColor];
  

    _textView.frame = CGRectMake(5, _textView.frame.origin.y, 310 - 65, _textView.frame.size.height);
    CGRect f = _textView.frame;
    f.size.height = f.size.height+3;
    _textViewBackgroundView.frame = f;
    _lblPlaceholder.frame = CGRectMake(8, topGap+2, 230, 20);
    _lblPlaceholder.backgroundColor = [UIColor clearColor];
    _sendButton.frame = CGRectMake(310 - 55,_textView.frame.origin.y, 55, 27);
}

- (void) awakeFromNib
{
    [self composeView];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview == nil)
    {
        [self listenForKeyboardNotifications:NO];
    }
    else
    {
        [self listenForKeyboardNotifications:YES];
    }
}

- (void) adjustTextInputHeightForText:(NSString*)text animated:(BOOL)animated
{
    int h1 = [text sizeForFont:_textView.font].height;
    int h2 = [text sizeForFont:_textView.font constrainedToSize:CGSizeMake(_textView.frame.size.width - 16, 170.0f) lineBreakMode:NSLineBreakByWordWrapping].height;

    [UIView animateWithDuration:(animated ? .1f : 0) animations:^
     {
         int h = h2 == h1 ? inputHeightWithShadow : h2 + 24;
         if (h>78) {
             h =78;
         }
         int delta = h - self.frame.size.height;
         CGRect r2 = CGRectMake(0, self.frame.origin.y - delta, self.frame.size.width, h);
         self.frame = r2;
         _inputBackgroundView.frame = CGRectMake(0, 0, self.frame.size.width, h);
        
         CGRect r = _textView.frame;
         r.origin.y = topGap;
         r.size.height = h - 18;
         _textView.frame = r;
         
     } completion:^(BOOL finished){ }];
}

- (id) initWithFrame:(CGRect)frame andAboveView:(UIView *)bgView
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        tapView.backgroundColor = [UIColor clearColor];
        tapView.userInteractionEnabled = YES;
        [bgView addSubview:tapView];
       
        tapView.hidden = YES;
        
        UITapGestureRecognizer *tapGer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        [tapView addGestureRecognizer:tapGer];
      
        
        [self composeView];
    }
    return self;
}

- (void) fitText
{
    [self adjustTextInputHeightForText:_textView.text animated:YES];
}

- (BOOL)resignFirstResponder
{
    if (super.isFirstResponder)
        return [super resignFirstResponder];
    else if ([_textView isFirstResponder])
        return [_textView resignFirstResponder];
    return NO;
}

#pragma mark - Public Methods

- (NSString*)text
{
    return _textView.text;
}

- (void) setText:(NSString*)text
{
    _textView.text = text;
    _lblPlaceholder.hidden = text.length > 0;
    [self fitText];
}

- (void) setPlaceholder:(NSString*)text
{
    _lblPlaceholder.text = text;
}

#pragma mark - Display

- (void)beganEditing
{
    if (_autoResizeOnKeyboardVisibilityChanged)
    {
        UIViewAnimationOptions opt = animationOptionsWithCurve(keyboardAnimationCurve);
        
        [UIView animateWithDuration:keyboardAnimationDuration delay:0 options:opt animations:^
         {
             self.transform = CGAffineTransformMakeTranslation(0, -self.ymkeyboardHeight);
         } completion:^(BOOL fin){}];
        [self fitText];
    }
}

- (void)endedEditing
{
    if (_autoResizeOnKeyboardVisibilityChanged)
    {
        UIViewAnimationOptions opt = animationOptionsWithCurve(keyboardAnimationCurve);
        
        [UIView animateWithDuration:keyboardAnimationDuration delay:0 options:opt animations:^
         {
             self.transform = CGAffineTransformIdentity;
         } completion:^(BOOL fin){}];
        
        [self fitText];
    }
    
    _lblPlaceholder.hidden = _textView.text.length > 0;
}

#pragma mark - Keyboard Notifications

- (void)listenForKeyboardNotifications:(BOOL)listen
{
    if (listen)
    {
        [self listenForKeyboardNotifications:NO];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    }
}

- (void)updateKeyboardProperties:(NSNotification*)n
{
    NSNumber *d = [[n userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    if (d!=nil && [d isKindOfClass:[NSNumber class]])
        keyboardAnimationDuration = [d floatValue];
    d = [[n userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    if (d!=nil && [d isKindOfClass:[NSNumber class]])
        keyboardAnimationCurve = [d integerValue];
    NSValue *v = [[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    if ([v isKindOfClass:[NSValue class]])
    {
        CGRect r = [v CGRectValue];
        r = [self.window convertRect:r toView:self];
        self.ymkeyboardHeight = r.size.height;
    }

}

- (void)keyboardWillShow:(NSNotification*)n
{
    _autoResizeOnKeyboardVisibilityChanged = YES;
    [self updateKeyboardProperties:n];

}

- (void)keyboardWillHide:(NSNotification*)n
{
    [self updateKeyboardProperties:n];

}

- (void)keyboardDidHide:(NSNotification*)n
{

}

- (void)keyboardDidShow:(NSNotification*)n
{
    if ([_textView isFirstResponder])
    {
        [self beganEditing];
    }

}

static inline UIViewAnimationOptions animationOptionsWithCurve(UIViewAnimationCurve curve)
{
    UIViewAnimationOptions opt = (UIViewAnimationOptions)curve;
    return opt << 16;
}

#pragma mark - UITextFieldDelegate Delegate

- (void) textViewDidBeginEditing:(UITextView*)textview
{
    [self beganEditing];
   

}

- (void) textViewDidEndEditing:(UITextView*)textview
{
    [self endedEditing];
   
    _autoResizeOnKeyboardVisibilityChanged = NO;
}

- (BOOL) textView:(UITextView*)textview shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self performSelector:@selector(returnButtonPressed:) withObject:nil afterDelay:.1];
        return NO;
    }
    else if (range.location >= 140||range.location + text.length >140){
        
        //[self.superview makeToast:@"超过字数限制啦" duration:0.5f position:@"center-38"];
        return  YES;
    }

    else if (text.length > 0)
    {
        [self adjustTextInputHeightForText:[NSString stringWithFormat:@"%@%@", textview.text, text] animated:YES];
    }
    return YES;
}

- (void) textViewDidChange:(UITextView*)textview
{

    _lblPlaceholder.hidden = textview.text.length > 0;
    
    [self fitText];
    
    if(_textView.text.length == 141){
        
      // [self.superview makeToast:@"超过字数限制啦" duration:0.5f position:@"center-38"];
    }

}

#pragma mark THChatInput Delegate

- (void) sendButtonPressed:(id)sender
{
   
    if ([_textView.text isEqualToString:@""]) {
        
        NSLog(@"无内容");
        return;
    }
    
    [_delegate YMReplyInputWithReply:_textView.text appendTag:_replyTag];
    [self disappear];
    
}





- (void)returnButtonPressed:(id)sender
{
    [self sendButtonPressed:sender];
}

- (void)showCommentView
{
    
    self.hidden = NO;
    tapView.hidden = NO;
    tapView.alpha = 0.6;
    _autoResizeOnKeyboardVisibilityChanged = YES;
    [self.textView becomeFirstResponder];
    [self beganEditing];
    
   

}

- (void)disappear
{
    [self endedEditing];
    self.hidden = YES;
    tapView.hidden = YES;
    tapView.alpha = 1.0;
    _autoResizeOnKeyboardVisibilityChanged = NO;
    [self.textView resignFirstResponder];
   
    [_delegate destorySelf];
   
}


@end
