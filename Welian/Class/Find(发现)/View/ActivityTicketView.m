//
//  ActivityTicketView.m
//  Welian
//
//  Created by weLian on 15/2/12.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityTicketView.h"
#import "ActivityTicketViewCell.h"

#define toolBarHeight 50
#define kMarginLeft 15.f
#define kButtonHeight 35.f
#define kTableViewCellHeight 60.f

@interface ActivityTicketView ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (assign,nonatomic) UIView *operateToolView;
@property (assign,nonatomic) UIButton *operateBtn;
@property (assign,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *datasource;

@end

@implementation ActivityTicketView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _operateToolView.frame = CGRectMake(0.f, self.height - toolBarHeight, self.width, toolBarHeight);
    _operateToolView.layer.borderColorFromUIColor = RGB(231.f, 231.f, 231.f);
    _operateToolView.layer.borderWidths = @"{0.6,0,0,0}";
    
    _operateBtn.size = CGSizeMake(_operateToolView.width - kMarginLeft * 2.f, kButtonHeight);
    _operateBtn.centerX = _operateToolView.width / 2.f;
    _operateBtn.centerY = _operateToolView.height / 2.f;
    
    _tableView.size = CGSizeMake(self.width, kTableViewCellHeight * _datasource.count);
    _tableView.bottom = _operateToolView.top;
    _tableView.centerX = self.width / 2.f;
}

#pragma mark - Private
- (void)setup
{
    self.datasource = @[@"VIP门票",@"普通门票",@"免费门票"];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    //设置底部操作栏
    UIView *operateToolView = [[UIView alloc] init];
    operateToolView.backgroundColor = RGB(247.f, 247.f, 247.f);
    [self addSubview:operateToolView];
    self.operateToolView = operateToolView;
    
    //操作按钮
    UIButton *operateBtn = [UIView getBtnWithTitle:@"确认购票" image:nil];
    operateBtn.backgroundColor = RGB(52.f, 115.f, 185.f);
    [operateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [operateBtn addTarget:self action:@selector(favorteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [operateToolView addSubview:operateBtn];
    self.operateBtn = operateBtn;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    //隐藏表格分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableView];
    self.tableView = tableView;
    
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [self dismiss];
    }];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)showInView
{
    self.top = self.top = [[UIScreen mainScreen] bounds].size.height;
    [UIView animateWithDuration:.3f
                          delay:.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.top = 0;
                         self.hidden = NO;
                     } completion:^(BOOL finished) {
                         self.top = 0;
                     }];
}

- (void)dismiss
{
    [UIView animateWithDuration:.2f
                          delay:.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.top = [[UIScreen mainScreen] bounds].size.height;
                     } completion:^(BOOL finished) {
                         self.top = [[UIScreen mainScreen] bounds].size.height;
                         self.hidden = YES;
                     }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    DLog(@"touch.view：%@",[touch.view class]);
    ///UITableViewCellContentView
    if ([[NSString stringWithFormat:@"%@",[touch.view class]] isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    if ([[NSString stringWithFormat:@"%@",[touch.view class]] isEqualToString:@"UIButton"]) {
        return NO;
    }
    if ([[NSString stringWithFormat:@"%@",[touch.view class]] isEqualToString:@"UIView"]) {
        return NO;
    }
    return YES;
}

#pragma mark - UITableView Datasource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Activity_Ticket_View_Cell";
    
    ActivityTicketViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ActivityTicketViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellHeight;
}

@end
