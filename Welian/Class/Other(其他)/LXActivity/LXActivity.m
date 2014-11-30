//
//  LXActivity.m
//  LXActivityDemo
//
//  Created by lixiang on 14-3-17.
//  Copyright (c) 2014年 lcolco. All rights reserved.
//

#import "LXActivity.h"
#import "UIImage+ImageEffects.h"
#import "DockItem.h"

#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35]
#define ACTIONSHEET_BACKGROUNDCOLOR              [UIColor whiteColor]
#define ANIMATE_DURATION                        0.25f
#define KBUTTONX                                50.0f
#define KBUTTON_Width                           80.0f
#define KBUTTON_High                            90.0f
#define KTOP_High                               10.0f


@interface LXActivity ()
{
    CGFloat LXActivityHeight;
}
@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,assign) id<LXActivityDelegate>delegate;

@end

@implementation LXActivity

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

#pragma mark - Public method
- (id)initWithDelegate:(id<LXActivityDelegate>)delegate WithTitle:(NSString *)title otherButtonTitles:(NSArray *)buttonsTitle ShareButtonTitles:(NSArray *)shareButtonTitlesArray withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray
{
    self = [super init];
    if (self) {
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        if (delegate) {
            self.delegate = delegate;
        }
        
        [self creatButtonTitles:shareButtonTitlesArray withShareButtonImagesName:shareButtonImagesNameArray WithTitle:title otherButtonTitles:buttonsTitle];
        
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

#pragma mark - Praviate method
- (void)creatButtonTitles:(NSArray *)shareButtonTitlesArray withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray WithTitle:(NSString *)title otherButtonTitles:(NSArray *)buttonsTitle
{
    CGFloat backGWidth = [UIScreen mainScreen].bounds.size.width-20;
    //生成LXActionSheetView
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height, backGWidth, 0)];
    self.backGroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backGroundView];
    
    
    
    CGFloat gap = (self.backGroundView.bounds.size.width-(2*KBUTTONX) - (shareButtonImagesNameArray.count*KBUTTON_Width))/(shareButtonImagesNameArray.count-1);
    UIView *butBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backGWidth, KBUTTON_High+2*KTOP_High)];
    [butBackView.layer setMasksToBounds:YES];
    [butBackView.layer setCornerRadius:8.0f];
    [butBackView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.99]];
    [self.backGroundView addSubview:butBackView];
    if (buttonsTitle.count) {
        for (NSInteger i = 0; i<buttonsTitle.count; i++) {
            
            UIButton *oterBut = [[UIButton alloc] initWithFrame:CGRectMake(0, (44+1)*i, butBackView.frame.size.width, 44)];
            [oterBut setBackgroundColor:[UIColor whiteColor]];
            [oterBut setTitle:buttonsTitle[i] forState:UIControlStateNormal];
            [oterBut setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [oterBut addTarget:self action:@selector(didClickOnImageIndex:) forControlEvents:UIControlEventTouchUpInside];
            [butBackView addSubview:oterBut];
        }
        LXActivityHeight = (buttonsTitle.count*(44+1));
    }
    UIView *itmesView = [[UIView alloc] init];
    [itmesView setBackgroundColor:[UIColor whiteColor]];
    [butBackView addSubview:itmesView];
    
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, butBackView.frame.size.width, 30)];
    [titLabel setText:title];
    [titLabel setFont:[UIFont systemFontOfSize:13]];
    [titLabel setBackgroundColor:[UIColor whiteColor]];
    [titLabel setTextAlignment:NSTextAlignmentCenter];
    [titLabel setTextColor:[UIColor lightGrayColor]];
    [itmesView addSubview:titLabel];
    
    if (shareButtonImagesNameArray.count > 0) {
        for (int i = 0; i < shareButtonImagesNameArray.count; i++) {
            
            DockItem *shareButton = [[DockItem alloc] initWithFrame:CGRectMake(KBUTTONX+i*(KBUTTON_Width+gap),30, KBUTTON_Width, KBUTTON_High)];
            [shareButton setImage:[UIImage imageNamed:[shareButtonImagesNameArray objectAtIndex:i]] forState:UIControlStateNormal];
            [shareButton setBackgroundColor:[UIColor whiteColor]];
            [shareButton setTitle:[shareButtonTitlesArray objectAtIndex:i] forState:UIControlStateNormal];
            [shareButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [shareButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            shareButton.tag = i;
            [shareButton addTarget:self action:@selector(didClickOnImageIndex:) forControlEvents:UIControlEventTouchUpInside];
            
            [itmesView addSubview:shareButton];
        }
    }
    [itmesView setFrame:CGRectMake(0, LXActivityHeight, backGWidth, KBUTTON_High+30)];
    [butBackView setFrame:CGRectMake(0, 0, backGWidth, LXActivityHeight+KBUTTON_High+30)];
    
    //再次计算加入shareButtons后LXActivity的高度
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, LXActivityHeight+KBUTTON_High+30+10, backGWidth, 44)];
    [cancelButton setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.99]];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.layer setMasksToBounds:YES];
    [cancelButton.layer setCornerRadius:8.0f];
    [cancelButton setTitleColor:[UIColor colorWithRed:60.0/255 green:183.0/255 blue:226.0/255 alpha:1] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:cancelButton];
    
    LXActivityHeight = CGRectGetMaxY(cancelButton.frame);
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height-LXActivityHeight-10, backGWidth, LXActivityHeight)];
    } completion:^(BOOL finished) {
    }];
}

- (void)didClickOnImageIndex:(UIButton *)button
{
    if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(didClickOnImageIndex:)] == YES) {
                [self.delegate didClickOnImageIndex:button.titleLabel.text];
            }
    }
    [self tappedCancel];
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width-20, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


@end
