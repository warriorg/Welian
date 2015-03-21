//
//  WLActivityView.m
//  Welian
//
//  Created by dong on 15/3/4.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "WLActivityView.h"

#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35]
#define ANIMATE_DURATION                        0.25f

@interface WLActivityView ()<UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate>
{
    NSArray *_oneArray;
    NSArray *_twoArray;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WLActivityView

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SuperSize.height, SuperSize.width, 0) style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:WLRGB(116, 116, 116) forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
        _tableView.tableFooterView = cancelButton;
    }
    return _tableView;
}

#pragma mark - Public method
- (id)initWithOneSectionArray:(NSArray *)oneArray andTwoArray:(NSArray *)twoArray;
{
    self = [super init];
    if (self) {
        _oneArray = oneArray;
        _twoArray = twoArray;
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, SuperSize.width, SuperSize.height);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [tapGesture setDelegate:self];
        [self addGestureRecognizer:tapGesture];
        
        [self addSubview:self.tableView];
        
        CGFloat LXActivityHeight = 170;
        if (oneArray.count&&twoArray.count) {
            LXActivityHeight += 120;
        }
        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            [self.tableView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-LXActivityHeight, SuperSize.width, LXActivityHeight)];
        } completion:^(BOOL finished) {
        }];
    }
    return self;
}

- (void)show
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

- (void)didClickOnImageIndex:(UIButton *)button
{
    [self tappedCancel];
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.tableView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_oneArray.count&&_twoArray.count) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *wlActivityCellId = @"WLActivityCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:wlActivityCellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wlActivityCellId];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    POHorizontalList *list;
    
    if ([indexPath row] == 0) {
        if (_oneArray) {
            list = [[POHorizontalList alloc] initWithButItems:_oneArray];
        }else{
            list = [[POHorizontalList alloc] initWithButItems:_twoArray];
        }
    }
    else if ([indexPath row] == 1) {
        
        list = [[POHorizontalList alloc] initWithButItems:_twoArray];
    }
    WEAKSELF
    list.shareBlock = ^(ShareType stype){
        [weakSelf tappedCancel];
        if (weakSelf.wlShareBlock) {
            weakSelf.wlShareBlock(stype);
        }
    };
    [cell.contentView addSubview:list];
    
    return cell;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    DLog(@"touch.view：%@",[touch.view class]);
    if ([[NSString stringWithFormat:@"%@",[touch.view class]] isEqualToString:@"UIScrollView"]) {
        return NO;
    }
    return YES;
}

@end
