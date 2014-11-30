//
//  MessageFaceView.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-12.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "ZBMessageManagerFaceView.h"
#import "ZBExpressionSectionBar.h"
#import "UIImage+ImageEffects.h"


#define FaceSectionBarHeight  36   // 表情下面控件
#define FacePageControlHeight 20  // 表情pagecontrol

#define Pages 5

@implementation ZBMessageManagerFaceView
{
    UIPageControl *pageControl;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor colorWithRed:248.0f/255 green:248.0f/255 blue:255.0f/255 alpha:1.0];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f,10.0f,CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds)-FacePageControlHeight-FaceSectionBarHeight)];
    scrollView.delegate = self;
    [self addSubview:scrollView];
    [scrollView setPagingEnabled:YES];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.frame)*Pages,CGRectGetHeight(scrollView.frame))];
    
    for (int i= 0;i<Pages;i++) {
        ZBFaceView *faceView = [[ZBFaceView alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(self.bounds),0.0f,CGRectGetWidth(self.bounds),CGRectGetHeight(scrollView.bounds)) forIndexPath:i];
        [scrollView addSubview:faceView];
        faceView.delegate = self;
    }
    
    pageControl = [[UIPageControl alloc]init];
    [pageControl setFrame:CGRectMake(0,CGRectGetMaxY(scrollView.frame),CGRectGetWidth(self.bounds),FacePageControlHeight)];
    [self addSubview:pageControl];
    [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
    pageControl.numberOfPages = Pages;
    pageControl.currentPage   = 0;
    
    _sendBut = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-50-15, CGRectGetMaxY(scrollView.frame)+5, 50, 34)];
    [_sendBut setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBut setBackgroundImage:[UIImage resizedImage:@"bluebutton"] forState:UIControlStateNormal];
    [_sendBut addTarget:self action:@selector(sendButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendBut];
}

#pragma mark  scrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/320;
    pageControl.currentPage = page;
    
}

#pragma mark - 发送
- (void)sendButClick:(UIButton*)send
{
    if ([self.delegate respondsToSelector:@selector(SendTheFaceStr:isDelete:isSend:)]) {
        [self.delegate SendTheFaceStr:nil isDelete:NO isSend:YES];
    }
}

#pragma mark ZBFaceView Delegate
- (void)didSelecteFace:(NSString *)faceName andIsSelecteDelete:(BOOL)del{
    if ([self.delegate respondsToSelector:@selector(SendTheFaceStr:isDelete:isSend:) ]) {
        [self.delegate SendTheFaceStr:faceName isDelete:del isSend:NO];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
