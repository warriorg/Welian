//
//  BSearchFriendsController.m
//  Welian
//
//  Created by dong on 15/1/6.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BSearchFriendsController.h"
#import "MainViewController.h"
#import "UserInfoBasicVC.h"
#import "UserInfoViewController.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "WLTool.h"
#import "UIImage+ImageEffects.h"
#import "FriendsAddressBook.h"
#import "MJExtension.h"
#import "NotstringView.h"
#import "FriendCell.h"

@interface BSearchFriendsController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_leidaImage;
    UIView *_searchView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *addressBookRefView;
@property (nonatomic, strong) NSMutableArray *friendsBook;
@property (nonatomic, strong) NSMutableArray *friendsWeixing;
@property (nonatomic, strong) NotstringView *notFriendsView;

@end

static NSString *fridcellid = @"fridcellid";

@implementation BSearchFriendsController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (NotstringView *)notFriendsView
{
    if (_notFriendsView == nil) {
        _notFriendsView = [[NotstringView alloc] initWithFrame:CGRectMake(0, 120, SuperSize.width, SuperSize.height-120) withTitleStr:@"很遗憾，未能搜索到好友"];
    }
    return _notFriendsView;
}


- (UIView *)addressBookRefView
{
    if (_addressBookRefView == nil) {
        _addressBookRefView = [[UIView alloc] init];
        NSString *tisStr = @"请到“设置->隐私->通讯录”中打开微链访问通讯录的权限，将为你找到更多好友";
        CGSize labelsize = [tisStr calculateSize:CGSizeMake(SuperSize.width-60, FLT_MAX) font:WLFONT(14)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, labelsize.width, labelsize.height)];
        [label setText:tisStr];
        [label setTextColor:WLRGB(161, 161, 161)];
        [label setNumberOfLines:0];
        [label setFont:WLFONT(14)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [_addressBookRefView addSubview:label];
        UIButton *but = [UIButton buttonWithType:UIButtonTypeSystem];
        [but setFrame:CGRectMake(40, CGRectGetMaxY(label.frame)+10, SuperSize.width-80, 44)];
        [but setImage:[UIImage imageNamed:@"login_research"] forState:UIControlStateNormal];
        [but setBackgroundImage:[UIImage resizedImage:@"research_bg"] forState:UIControlStateNormal];
        [but setBackgroundImage:[UIImage resizedImage:@"research_bg_pre"] forState:UIControlStateHighlighted];
        [but.titleLabel setFont:WLFONT(17)];
        [but setTitle:@"重新搜索" forState:UIControlStateNormal];
//        [but addTarget:self action:@selector(getaddressBook) forControlEvents:UIControlEventTouchUpInside];
        [but setTitleColor:WLRGB(52, 116, 186) forState:UIControlStateNormal];
        [but setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [_addressBookRefView addSubview:but];
        [_addressBookRefView setFrame:CGRectMake(0, 80, SuperSize.width, CGRectGetMaxY(but.frame))];
        
    }
    return _addressBookRefView;
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:fridcellid];
    }
    return _tableView;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:WLRGB(231, 234, 238)];
    UIButton *cancelBut = [[UIButton alloc] initWithFrame:CGRectMake(10, 35, 40, 40)];
    [cancelBut setImage:[UIImage imageNamed:@"login_chacha"] forState:UIControlStateNormal];
    [cancelBut addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBut];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, SuperSize.width, SuperSize.height-80)];
    _searchView = searchView;
    [self.view addSubview:searchView];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, 30)];
    [welcomeLabel setText:@"欢迎来到微链！"];
    [welcomeLabel setTextColor:WLRGB(52, 116, 186)];
    [welcomeLabel setTextAlignment:NSTextAlignmentCenter];
    [welcomeLabel setFont:WLFONT(19)];
    [searchView addSubview:welcomeLabel];
    UILabel *asdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(welcomeLabel.frame)+10, SuperSize.width, 20)];
    [asdLabel setTextAlignment:NSTextAlignmentCenter];
    [asdLabel setText:@"想知道有多少好友已加入微链？"];
    [asdLabel setTextColor:WLRGB(173, 173, 173)];
    [asdLabel setFont:WLFONT(14)];
    [searchView addSubview:asdLabel];
    
    UIImageView *leidaImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-42, CGRectGetMaxY(asdLabel.frame)+30, 85, 85)];
    [leidaImage setUserInteractionEnabled:YES];
    _leidaImage = leidaImage;
    [leidaImage setImage:[UIImage imageNamed:@"leida6"]];
    [leidaImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapiconImage:)]];
    NSMutableArray *imageArray = [NSMutableArray array];
    
    for (NSInteger i = 1; i<7; i++) {
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"leida%d",i]]];
    }
    [leidaImage setAnimationImages:imageArray];
    [searchView addSubview:leidaImage];
    [leidaImage setAnimationDuration:2.5];
    
    UILabel *beginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(leidaImage.frame)+20, SuperSize.width, 20)];
    [beginLabel setTextAlignment:NSTextAlignmentCenter];
    [beginLabel setText:@"点击雷达，开始搜索"];
    [beginLabel setTextColor:WLRGB(125, 125, 125)];
    [searchView addSubview:beginLabel];
}


- (void)tapiconImage:(UITapGestureRecognizer *)tap
{
    [_leidaImage startAnimating];
    self.friendsBook = [NSMutableArray array];
    self.friendsWeixing = [NSMutableArray array];
    
    [self getaddressBook];

}

- (void)getaddressBook
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(nil, nil);
    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
    //这个只会在第一次访问时调用
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool greanted, CFErrorRef error){
        dispatch_semaphore_signal(sema);
        
        if (greanted) {
            [UserDefaults setObject:@"1" forKey:KAddressBook];
            
            [WLTool getAddressBookArray:^(NSMutableArray *friendsAddress) {
                [WLHttpTool uploadPhonebook2ParameterDic:friendsAddress success:^(id JSON) {
                    NSArray *array = JSON;
                    for (NSDictionary *dic  in array) {
                        FriendsAddressBook *friendBook = [[FriendsAddressBook alloc] init];
                        [friendBook setKeyValues:dic];
                        if (friendBook.type.integerValue == 0) {
                            [self.friendsBook addObject:friendBook];
                        }else if (friendBook.type.integerValue==1){
                            [self.friendsWeixing addObject:friendBook];
                        }
                    }
                    
                    
                    [UIView animateWithDuration:2 animations:^{
                        [_searchView setAlpha:0.0];
                    } completion:^(BOOL finished) {
                        if (self.friendsBook.count||self.friendsWeixing.count) {
                            [self.tableView setFrame:CGRectMake(0, 80, SuperSize.width, SuperSize.height-80)];
                            [self.view addSubview:self.tableView];
                        }else{
                            [self.view addSubview:self.notFriendsView];
                        }
                        [_leidaImage stopAnimating];
                        [_searchView removeFromSuperview];
                    }];
                } fail:^(NSError *error) {
                    
                }];
            }];

            
        }else {
            
            [UserDefaults setObject:@"0" forKey:KAddressBook];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            [WLHttpTool uploadPhonebook2ParameterDic:[NSMutableArray array] success:^(id JSON) {
                NSArray *array = JSON;
                for (NSDictionary *dic  in array) {
                    FriendsAddressBook *friendBook = [[FriendsAddressBook alloc] init];
                    [friendBook setKeyValues:dic];
                    [self.friendsWeixing addObject:friendBook];
                }
                
                [UIView animateWithDuration:2 animations:^{
                    [_searchView setAlpha:0.0];
                } completion:^(BOOL finished) {
                    if (self.friendsWeixing.count) {
                        [self.tableView setFrame:CGRectMake(0, CGRectGetMaxY(self.addressBookRefView.frame)+20, SuperSize.width, SuperSize.height- CGRectGetMaxY(self.addressBookRefView.frame)+20)];
                        [self.view insertSubview:self.tableView belowSubview:_searchView];
                        
                    }else{
                        [self.view insertSubview:self.notFriendsView belowSubview:_searchView];
                    }
                    [self.view insertSubview:self.addressBookRefView belowSubview:_searchView];
                    [_leidaImage stopAnimating];
                    [_searchView removeFromSuperview];
                }];

            } fail:^(NSError *error) {
                
            }];

        }
        
    });
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger i = 0;
    if (self.friendsBook.count) {
        i++;
    }
    if (self.friendsWeixing.count) {
        i++;
    }
    return i;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        if (self.friendsBook.count) {
            return self.friendsBook.count;
        }else if (self.friendsWeixing.count){
            return self.friendsWeixing.count;
        }
    }else if (section==1){
        return self.friendsWeixing.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:fridcellid];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    FriendsAddressBook *friends;
    if (indexPath.section==0) {
        if (self.friendsBook.count) {
            friends = self.friendsBook[indexPath.row];
        }else if(self.friendsWeixing.count){
            friends = self.friendsWeixing[indexPath.row];
        }
    }else if (indexPath.section==1){
            friends = self.friendsWeixing[indexPath.row];
    }
    [cell setUserMode:friends];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, 20)];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setTextColor:WLRGB(153, 153, 153)];
    [headerLabel setFont:WLFONT(14)];
    NSString *headStr = @"";
    NSInteger  length = 0;
    if (section==0) {
        if (self.friendsBook.count) {
           headStr =  [NSString stringWithFormat:@"为你搜索到 %d 个通讯录好友",self.friendsBook.count];
            length = [[NSString stringWithFormat:@"%d",self.friendsBook.count] length];
            
        }else if (self.friendsWeixing.count){
           headStr =  [NSString stringWithFormat:@"为你搜索到 %d 个微信好友",self.friendsWeixing.count];
            length = [[NSString stringWithFormat:@"%d",self.friendsWeixing.count] length];
        }
        
    }else if (section==1){
        headStr =  [NSString stringWithFormat:@"为你搜索到 %d 个微信好友",self.friendsWeixing.count];
        length = [[NSString stringWithFormat:@"%d",self.friendsWeixing.count] length];
    }
    
    NSDictionary *attrsDic = @{NSForegroundColorAttributeName: WLRGB(52, 116, 186),NSFontAttributeName:WLFONTBLOD(17)};
    NSMutableAttributedString *attrstr = [[NSMutableAttributedString alloc] initWithString:headStr];
    [attrstr addAttributes:attrsDic range:NSMakeRange(6, length)];
    
    [headerLabel setAttributedText:attrstr];
    
    return headerLabel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsAddressBook *friends;
    if (indexPath.section==0) {
        if (self.friendsBook.count) {
            friends = self.friendsBook[indexPath.row];
        }else if(self.friendsWeixing.count){
            friends = self.friendsWeixing[indexPath.row];
        }
    }else if (indexPath.section==1){
        friends = self.friendsWeixing[indexPath.row];
    }
    
//    UserInfoBasicVC *userVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:friends isAsk:NO];
//    [userVC setIsHideSendMsgBtn:YES];
    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithBaseUserM:friends OperateType:@(10) HidRightBtn:YES];
    [self.navigationController pushViewController:userInfoVC animated:YES];
//    [self cancelClick];
}

- (void)cancelClick
{
    if (_isStart) {
        MainViewController *mainVC = [[MainViewController alloc] init];
        [mainVC setSelectedIndex:1];
        [[UIApplication sharedApplication].keyWindow setRootViewController:mainVC];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
