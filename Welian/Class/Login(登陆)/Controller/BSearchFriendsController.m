//
//  BSearchFriendsController.m
//  Welian
//
//  Created by dong on 15/1/6.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BSearchFriendsController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "WLTool.h"

@interface BSearchFriendsController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_leidaImage;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *addressBookRefView;

@end

@implementation BSearchFriendsController

- (UIView *)addressBookRefView
{
    if (_addressBookRefView == nil) {
        NSString *tisStr = @"请到“设置->隐私->通讯录”中打开微链访问通讯录的权限，将为你找到更多好友";
        
//        _addressBookRefView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, SuperSize.width, <#CGFloat height#>)]
    }
    return _addressBookRefView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, SuperSize.height) style:UITableViewStylePlain];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
    }
    return _tableView;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:WLRGB(231, 234, 238)];
    UIButton *cancelBut = [[UIButton alloc] initWithFrame:CGRectMake(20, 35, 40, 40)];
    [cancelBut setImage:[UIImage imageNamed:@"login_chacha"] forState:UIControlStateNormal];
    [cancelBut addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBut];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, SuperSize.width, SuperSize.height-80)];
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
    [leidaImage setImage:[UIImage imageNamed:@"leida1"]];
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
            
        }else {
            [UserDefaults setObject:@"0" forKey:KAddressBook];
            
        }
        [WLTool getAddressBookArray:^(NSArray *friendsAddress) {
            DLog(@"%@",friendsAddress);
            [_leidaImage stopAnimating];
        }];
    });

}


- (void)cancelClick
{
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
