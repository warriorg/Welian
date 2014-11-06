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
#define KBUTTONX                                15.0f
#define KBUTTON_Width                           80.0f
#define KBUTTON_High                            90.0f
#define KTOP_High                               10.0f


@interface LXActivity ()

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
- (id)initWithDelegate:(id<LXActivityDelegate>)delegate ShareButtonTitles:(NSArray *)shareButtonTitlesArray withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray
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
        
        [self creatButtonTitles:shareButtonTitlesArray withShareButtonImagesName:shareButtonImagesNameArray];
        
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

#pragma mark - Praviate method

- (void)creatButtonTitles:(NSArray *)shareButtonTitlesArray withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray
{
    CGFloat backGWidth = [UIScreen mainScreen].bounds.size.width;
    //生成LXActionSheetView
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height, backGWidth-20, 0)];
    self.backGroundView.backgroundColor = [UIColor clearColor];

    [self addSubview:self.backGroundView];
    CGFloat gap = (self.backGroundView.bounds.size.width-(2*KBUTTONX) - (shareButtonImagesNameArray.count*KBUTTON_Width))/(shareButtonImagesNameArray.count-1);
    UIView *butBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.backGroundView.bounds.size.width, KBUTTON_High+2*KTOP_High)];
    [butBackView.layer setMasksToBounds:YES];
    [butBackView.layer setCornerRadius:8.0f];
    [butBackView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.99]];
    [self.backGroundView addSubview:butBackView];
    
    if (shareButtonImagesNameArray) {
        if (shareButtonImagesNameArray.count > 0) {
            for (int i = 0; i < shareButtonImagesNameArray.count; i++) {
                
                DockItem *shareButton = [[DockItem alloc] initWithFrame:CGRectMake(KBUTTONX+i*(KBUTTON_Width+gap), KTOP_High, KBUTTON_Width, KBUTTON_High)];
                [shareButton setImage:[UIImage imageNamed:[shareButtonImagesNameArray objectAtIndex:i]] forState:UIControlStateNormal];
                [shareButton setTitle:[shareButtonTitlesArray objectAtIndex:i] forState:UIControlStateNormal];
                [shareButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [shareButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                shareButton.tag = i;
                [shareButton addTarget:self action:@selector(didClickOnImageIndex:) forControlEvents:UIControlEventTouchUpInside];
                
                [butBackView addSubview:shareButton];
            }
        }
    }
    
    //再次计算加入shareButtons后LXActivity的高度
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, KBUTTON_High+2*KTOP_High+10, backGWidth-20, 44)];
    [cancelButton setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.99]];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.layer setMasksToBounds:YES];
    [cancelButton.layer setCornerRadius:8.0f];
    [cancelButton setTitleColor:[UIColor colorWithRed:60.0/255 green:183.0/255 blue:226.0/255 alpha:1] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:cancelButton];
    
    CGFloat LXActivityHeight = CGRectGetMaxY(cancelButton.frame);
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height-LXActivityHeight-10, backGWidth-20, LXActivityHeight)];
    } completion:^(BOOL finished) {
    }];
}

- (void)didClickOnImageIndex:(UIButton *)button
{
    if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(didClickOnImageIndex:)] == YES) {
                [self.delegate didClickOnImageIndex:button.tag];
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
