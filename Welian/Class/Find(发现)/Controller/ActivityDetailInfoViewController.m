//
//  ActivityDetailInfoViewController.m
//  Welian
//
//  Created by weLian on 15/2/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityDetailInfoViewController.h"
#import "MessageKeyboardView.h"


#define kHeaderImageHeight 178.f
#define kTableViewHeaderHeight 45.f

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
        self.datasource = @[@"",@"",@"",@""];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.tintColor = KBasesColor;
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
    
    CGSize titleSize = [@"德奥经典音乐剧《伊丽莎白》第二轮" calculateSize:CGSizeMake(self.view.width - 30.f, FLT_MAX) font:[UIFont boldSystemFontOfSize:16.f]];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kHeaderImageHeight + titleSize.height + 20.f)];
    headerView.layer.borderColorFromUIColor = RGB(231.f, 231.f, 231.f);
    headerView.layer.borderWidths = @"{0,0,0.6,0}";
    
    //图片
    UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kHeaderImageHeight)];
    imageView.backgroundColor = [UIColor redColor];
    [headerView addSubview:imageView];
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = kTitleNormalTextColor;
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
    favorteBtn.width = 108.f;
    favorteBtn.height = 35.f;
    [favorteBtn addTarget:self action:@selector(favorteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *favorteBarItem = [[UIBarButtonItem alloc] initWithCustomView:favorteBtn];
//    self.favorteBtn = favorteBtn;
    
    //我要报名
    UIButton *joinBtn = [self getBtnWithTitle:@"我要购票" image:nil];
    joinBtn.width = self.view.width - favorteBtn.width - 30.f;
    joinBtn.height = 35.f;
    joinBtn.backgroundColor = RGB(52.f, 115.f, 185.f);
    [joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [joinBtn addTarget:self action:@selector(joinBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *joinBarItem = [[UIBarButtonItem alloc] initWithCustomView:joinBtn];
//    self.zanBtn = zanBtn;
    
    operateToolBar.items = @[spacer,favorteBarItem,spacer,joinBarItem,spacer];
    [self.view addSubview:operateToolBar];
//    self.operateToolBar = operateToolBar;
}

#pragma mark - UITableView Datasource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5.f;
    }else{
        return _datasource.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, self.view.width, kTableViewHeaderHeight)];
    headerView.layer.borderColorFromUIColor = RGB(231.f, 231.f, 231.f);
    headerView.layer.borderWidths = @"{0,0,0.6,0}";
    
    UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, headerView.width, 15.f)];
    topBgView.backgroundColor = RGB(236.f, 238.f, 241.f);
    [headerView addSubview:topBgView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = RGB(125.f, 125.f, 125.f);
    titleLabel.text = @"嘉宾";
    [titleLabel sizeToFit];
    titleLabel.left = 15.f;
    titleLabel.centerY = (headerView.height - topBgView.height) / 2.f + topBgView.height;
    [headerView addSubview:titleLabel];
    
    return headerView;
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
    if (section == 0) {
        return 0.f;
    }else{
        return kTableViewHeaderHeight;
    }
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
    if (indexPath.section == 0) {
        return 60;
    }else if (indexPath.section == 1) {
        return 60.f;
    }else{
        return 100.f;
    }
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
    favoriteBtn.layer.borderWidth = .7f;
    favoriteBtn.layer.masksToBounds = YES;
    //    favoriteBtn.frame = CGRectMake(0.f, 0.f, self.view.width / 3.f, toolBarHeight);
//    favoriteBtn.frame = CGRectMake(0.f, 0.f , (self.view.width - 20 * 2) / 2.f, toolBarHeight - 20.f);
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
