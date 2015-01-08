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
#import "UIImage+ImageEffects.h"

@interface BSearchFriendsController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_leidaImage;
    UIView *_searchView;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *addressBookRefView;

@end

@implementation BSearchFriendsController

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
        _tableView = [[UITableView alloc] init];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
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
    

    [UIView animateWithDuration:0.25 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [_searchView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.view insertSubview:self.addressBookRefView belowSubview:_searchView];
        [_leidaImage stopAnimating];
        [_searchView removeFromSuperview];
    }];
    [UIView animateWithDuration:0.25 animations:^{
       
    } completion:^(BOOL finished) {

    }];
//    [self getaddressBook];
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
            [self.view insertSubview:self.addressBookRefView belowSubview:_searchView];
            [UIView animateWithDuration:0.25 animations:^{
                [_searchView setAlpha:0.0];
            } completion:^(BOOL finished) {
                [_leidaImage stopAnimating];
                [_searchView removeFromSuperview];
            }];

            
            
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
