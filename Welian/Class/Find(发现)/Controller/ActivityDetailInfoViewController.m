//
//  ActivityDetailInfoViewController.m
//  Welian
//
//  Created by weLian on 15/2/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityDetailInfoViewController.h"
#import "MessageKeyboardView.h"


#define kTableViewHeaderHeight 178.f

@interface ActivityDetailInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (assign,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *datasource;

@end

@implementation ActivityDetailInfoViewController

- (NSString *)title
{
    return @"活动详情";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.navigationBar.alpha = 0.5f;
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加分享按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_more"] style:UIBarButtonItemStyleBordered target:self action:@selector(shareBtnClicked)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0.f,0.f,self.view.width,self.view.height - toolBarHeight)];
    tableView.dataSource = self;
    tableView.delegate = self;
    //隐藏表格分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
//    [tableView registerNib:[UINib nibWithNibName:@"NoCommentCell" bundle:nil] forCellReuseIdentifier:noCommentCell];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kTableViewHeaderHeight)];
    //图片
    UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kTableViewHeaderHeight)];
    imageView.backgroundColor = [UIColor redColor];
    [headerView addSubview:imageView];
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.text = @"德奥经典音乐剧《伊丽莎白》第二轮";
    [titleLabel sizeToFit];
    titleLabel.top = imageView.bottom + 10.f;
    titleLabel.left = 15.f;
    [headerView addSubview:titleLabel];
    headerView.height += titleLabel.height + 20.f;
    
    [_tableView setTableHeaderView:headerView];
    
    //设置底部操作栏
    UIToolbar *operateToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.f, tableView.bottom, self.view.width, toolBarHeight)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    //收藏
    UIButton *favorteBtn = [self getBtnWithTitle:@"收藏" image:[UIImage imageNamed:@"me_mywriten_shoucang"]];
    [favorteBtn addTarget:self action:@selector(favorteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *favorteBarItem = [[UIBarButtonItem alloc] initWithCustomView:favorteBtn];
//    self.favorteBtn = favorteBtn;
    
    //我要报名
    UIButton *joinBtn = [self getBtnWithTitle:@"我要报名" image:[UIImage imageNamed:@"me_mywriten_good"]];
    [joinBtn addTarget:self action:@selector(joinBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *joinBarItem = [[UIBarButtonItem alloc] initWithCustomView:joinBtn];
//    self.zanBtn = zanBtn;
    
    operateToolBar.items = @[favorteBarItem,spacer,joinBarItem];
    [self.view addSubview:operateToolBar];
//    self.operateToolBar = operateToolBar;
}

#pragma mark - UITableView Datasource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //微信联系人
    static NSString *cellIdentifier = @"Activity_Info_View_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    //    cell.projectInfo = _datasource[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - Private
//获取按钮对象
- (UIButton *)getBtnWithTitle:(NSString *)title image:(UIImage *)image{
    UIButton *favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteBtn.backgroundColor = [UIColor whiteColor];
    favoriteBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [favoriteBtn setTitle:title forState:UIControlStateNormal];
    [favoriteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [favoriteBtn setImage:image forState:UIControlStateNormal];
    favoriteBtn.imageEdgeInsets = UIEdgeInsetsMake(0.f, -10.f, 0.f, 0.f);
    favoriteBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    favoriteBtn.layer.cornerRadius = 5.f;
    favoriteBtn.layer.borderWidth = .5f;
    favoriteBtn.layer.masksToBounds = YES;
    //    favoriteBtn.frame = CGRectMake(0.f, 0.f, self.view.width / 3.f, toolBarHeight);
    favoriteBtn.frame = CGRectMake(0.f, 10.f , (self.view.width - 20 * 2) / 2.f, toolBarHeight - 20.f);
    return favoriteBtn;
}

//分享
- (void)shareBtnClicked
{
    
}

//收藏
- (void)favorteBtnClicked:(UIButton *)sender
{
    
}

//我要报名
- (void)joinBtnClicked:(UIButton *)sender
{
    
}

@end
