//
//  UserInfoBasicVC.m
//  weLian
//
//  Created by dong on 14/10/20.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "UserInfoBasicVC.h"
//#import "InvestAuthModel.h"
#import "HaderInfoCell.h"
#import "SameFriendsCell.h"
#import "StaurCell.h"
#import "SchoolModel.h"
#import "CompanyModel.h"
#import "UIImage+ImageEffects.h"
#import "HomeController.h"
#import "ListdaController.h"
#import "CommonFriendsController.h"
#import "MyFriendUser.h"
#import "NewFriendUser.h"
#import "ChatViewController.h"
#import "IIMeInvestAuthModel.h"
#import "InvestItemM.h"
#import "InvestInfoListVC.h"
#import "NeedAddUser.h"
#import "ICompanyResult.h"
#import "ISchoolResult.h"
#import "MJExtension.h"
#import "FriendsUserModel.h"
#import "MyProjectViewController.h"

@interface UserInfoBasicVC () <UIAlertViewDelegate,UIActionSheetDelegate>
{
    IBaseUserM *_userMode;
    NSMutableDictionary *_dataDicM;
    NSMutableArray *_sameFriendArry;
    NSString *_projectName;
}

@property (nonatomic,strong) UIView *addFriendView;

@property (nonatomic, strong) UIView *sendView;

@property (nonatomic, strong) UIView *askView;

@end

static NSString *sameFriendcellid = @"sameFriendcellid";
static NSString *staurCellid = @"staurCellid";

@implementation UserInfoBasicVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (UIView*)askView
{
    if (_askView==nil) {
        _askView = [[UIView alloc] init];
        [_askView setBounds:CGRectMake(0, 0, 0, 40)];
        // 3.要在tableView底部添加一个按钮
        UIButton *askbut = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [askbut setBackgroundImage:[UIImage resizedImage:@"greenbutton"] forState:UIControlStateNormal];
        [askbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [askbut setBackgroundImage:[UIImage resizedImage:@"greenbutton_pressed"] forState:UIControlStateHighlighted];
        askbut.frame = CGRectMake(20, 0, self.view.bounds.size.width-20*2, 40);
        [askbut addTarget:self action:@selector(acceptFriendButClick) forControlEvents:UIControlEventTouchUpInside];
        // 4.设置按钮文字
        [askbut setTitle:@"通过验证" forState:UIControlStateNormal];
        [_askView addSubview:askbut];
    }
    return _askView;
}

- (void)acceptFriendButClick
{
    if (self.acceptFriendBlock) {
        self.acceptFriendBlock();
    }
}

- (void)addSucceed
{
    [self.tableView setTableFooterView:self.sendView];
}

- (UIView*)sendView
{
    if (_sendView == nil) {
        _sendView = [[UIView alloc] init];
        [_sendView setBounds:CGRectMake(0, 0, 0, 40)];
        // 3.要在tableView底部添加一个按钮
        UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [chatBtn setBackgroundImage:[UIImage resizedImage:@"bluebutton"] forState:UIControlStateNormal];
        [chatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [chatBtn setBackgroundImage:[UIImage resizedImage:@"bluebuttton_pressed"] forState:UIControlStateHighlighted];
        chatBtn.frame = CGRectMake(20, 0, self.view.bounds.size.width-20*2, 40);
        // 4.设置按钮文字
        [chatBtn setTitle:@"发送消息" forState:UIControlStateNormal];
        [chatBtn addTarget:self action:@selector(chatBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_sendView addSubview:chatBtn];
    }
    return _sendView;
}

//进入聊天页面
- (void)chatBtnClicked:(UIButton *)sender
{
    //进入聊天页面
    [KNSNotification postNotificationName:kChatFromUserInfo object:self userInfo:@{@"uid":_userMode.uid.stringValue}];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UIView*)addFriendView
{
    if (_addFriendView == nil) {
        _addFriendView = [[UIView alloc] init];
        [_addFriendView setBounds:CGRectMake(0, 0, 0, 40)];
        // 3.要在tableView底部添加一个按钮
        UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [logout setBackgroundImage:[UIImage resizedImage:@"yellowbutton"] forState:UIControlStateNormal];
        [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [logout setBackgroundImage:[UIImage resizedImage:@"yellowbutton_pressed"] forState:UIControlStateHighlighted];
        logout.frame = CGRectMake(20, 0, self.view.bounds.size.width-20*2, 40);
        [logout addTarget:self action:@selector(requestFriend) forControlEvents:UIControlEventTouchUpInside];
        // 4.设置按钮文字
        [logout setTitle:@"+加为好友" forState:UIControlStateNormal];
        [_addFriendView addSubview:logout];
    }
    return _addFriendView;
}

- (void)requestFriend
{
    LogInUser *mode = [LogInUser getCurrentLoginUser];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友验证" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"我是%@的%@",mode.company,mode.position]];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [WLHttpTool requestFriendParameterDic:@{@"fid":_userMode.uid,@"message":[alertView textFieldAtIndex:0].text} success:^(id JSON) {
            [WLHUDView showSuccessHUD:@"好友验证发送成功！"];
            if (_addFriendBlock) {
                _addFriendBlock();
            }
        } fail:^(NSError *error) {
            
        }];
    }
}

- (void)moreItmeClick:(UIBarButtonItem*)item
{
    UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [sheet bk_setDestructiveButtonWithTitle:@"删除该好友" handler:^{
        [self deleteFriend];
    }];
    [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [sheet showInView:self.view];
}

// 删除好友
- (void)deleteFriend
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    [WLHttpTool deleteFriendParameterDic:@{@"fid":_userMode.uid} success:^(id JSON) {
        
        MyFriendUser *friendUser = [loginUser getMyfriendUserWithUid:_userMode.uid];
        //数据库删除当前好友
//        [loginUser removeRsMyFriendsObject:friendUser];
        //更新设置为不是我的好友
        [friendUser updateIsNotMyFriend];
        //聊天状态发送改变
        [friendUser updateIsChatStatus:NO];
        
        //删除新的好友本地数据库
        NewFriendUser *newFuser = [loginUser getNewFriendUserWithUid:_userMode.uid];
        if (newFuser) {
            //删除好友请求数据
            //更新好友请求列表数据为 添加
            [newFuser updateOperateType:0];
        }
        //更新本地添加好友数据库
        NeedAddUser *needAddUser = [loginUser getNeedAddUserWithUid:_userMode.uid];
        if (needAddUser) {
            //更新未好友的好友
            [needAddUser updateFriendShip:2];
        }
        
        [loginUser.managedObjectContext MR_saveToPersistentStoreAndWait];
        //聊天状态发送改变
        [KNSNotification postNotificationName:kChatUserChanged object:nil];
        [KNSNotification postNotificationName:KupdataMyAllFriends object:self];
        [self.navigationController popViewControllerAnimated:YES];
        [WLHUDView showSuccessHUD:@"删除成功！"];
    } fail:^(NSError *error) {
        
    }];

}


- (instancetype)initWithStyle:(UITableViewStyle)style andUsermode:(IBaseUserM *)usermode isAsk:(BOOL)isask
{
    _userMode = usermode;
    _dataDicM = [NSMutableDictionary dictionary];
    self = [super initWithStyle:style];
    if (self) {
        [self.tableView setSectionHeaderHeight:0.0];
        
        LogInUser *mode = [LogInUser getCurrentLoginUser];
        if (!([mode.uid integerValue]==[_userMode.uid integerValue])&&[usermode.friendship integerValue]==1) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_more"] style:UIBarButtonItemStyleBordered target:self action:@selector(moreItmeClick:)];
        }
        YTKKeyValueItem *item = [[WLDataDBTool sharedService] getYTKKeyValueItemById:usermode.uid.stringValue fromTable:KWLUserInfoTableName];
        if (item) {
            _dataDicM = [NSMutableDictionary dictionaryWithDictionary:[self getUserInfoWith:item.itemObject]];
            _userMode = [_dataDicM objectForKey:@"profile"];
            [self.tableView reloadData];
        }
        
        YTKKeyValueItem *sameFitem = [[WLDataDBTool sharedService] getYTKKeyValueItemById:usermode.uid.stringValue fromTable:KWLSamefriendsTableName];
        if (sameFitem) {
            _sameFriendArry = [self getSameFriendsWith:sameFitem.itemObject];
            [self.tableView reloadData];
        }
        
        [WLHttpTool loadUserInfoParameterDic:@{@"uid":_userMode.uid} success:^(id JSON) {

            [WLHttpTool loadSameFriendParameterDic:@{@"uid":mode.uid,@"fid":_userMode.uid,@"size":@(1000)} success:^(id JSON) {
                [[WLDataDBTool sharedService] putObject:JSON withId:_userMode.uid.stringValue intoTable:KWLSamefriendsTableName];
                _sameFriendArry = [self getSameFriendsWith:JSON];
                [self.tableView reloadData];
            } fail:^(NSError *error) {
                
            }];

            _dataDicM = [NSMutableDictionary dictionaryWithDictionary:[self getUserInfoWith:JSON]];
            _userMode = [_dataDicM objectForKey:@"profile"];
            if (!isask) {
                if ([_userMode.friendship integerValue]==-1) {
                    
                }else if ([_userMode.friendship integerValue]==1) {
                    [MyFriendUser createMyFriendUserModel:_userMode];
                    if (!_isHideSendMsgBtn) {
                        [self.tableView setTableFooterView:self.sendView];
                    }
                }else {
                    [[mode getMyfriendUserWithUid:_userMode.uid] MR_deleteEntity];
                    [self.tableView setTableFooterView:self.addFriendView];
                }
            }
            [self.tableView reloadData];
        } fail:^(NSError *error) {
            
        }];
        if (isask) {
            [self.tableView setTableFooterView:self.askView];
        }
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [self.tableView registerNib:[UINib nibWithNibName:@"SameFriendsCell" bundle:nil] forCellReuseIdentifier:sameFriendcellid];
        [self.tableView registerNib:[UINib nibWithNibName:@"StaurCell" bundle:nil] forCellReuseIdentifier:staurCellid];
        [self.tableView setBackgroundColor:IWGlobalBg];
        [self.tableView setSeparatorColor:WLLineColor];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        // 增加底部额外的滚动区域
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    }
    return self;
}

- (NSMutableArray *)getSameFriendsWith:(NSDictionary *)friendsDic
{
    NSArray *sameFA = [friendsDic objectForKey:@"samefriends"];
    NSMutableArray *sameFrindM = [NSMutableArray arrayWithCapacity:sameFA.count];
    for (NSDictionary *infoD in sameFA) {
        FriendsUserModel *fmode = [[FriendsUserModel alloc] init];
        [fmode setKeyValues:infoD];
        [sameFrindM addObject:fmode];
    }
    return sameFrindM;
}

- (NSDictionary *)getUserInfoWith:(NSDictionary *)dataDic
{
    // 详细信息
    NSDictionary *profile = [dataDic objectForKey:@"profile"];
    UserInfoModel *profileM = [UserInfoModel objectWithKeyValues:profile];
    // 动态
    NSDictionary *feed = [dataDic objectForKey:@"feed"];
    WLStatusM *feedM = [WLStatusM objectWithKeyValues:feed];
    
    // 投资案例
    NSDictionary *investor = [dataDic objectForKey:@"investor"];
    IIMeInvestAuthModel *investorM = [IIMeInvestAuthModel objectWithDict:investor];
    
    // 我的项目
    _projectName = [[dataDic objectForKey:@"project"] objectForKey:@"name"];
    // 创业者
    //        NSDictionary *startup = [dataDic objectForKey:@"startup"];
    
    // 工作经历列表
    NSArray *usercompany = [dataDic objectForKey:@"usercompany"];
    NSMutableArray *companyArrayM = [NSMutableArray arrayWithCapacity:usercompany.count];
    for (NSDictionary *dic in usercompany) {
        ICompanyResult *usercompanyM = [ICompanyResult objectWithKeyValues:dic];
        [companyArrayM addObject:usercompanyM];
    }
    
    // 教育经历列表
    NSArray *userschool = [dataDic objectForKey:@"userschool"];
    NSMutableArray *schoolArrayM = [NSMutableArray arrayWithCapacity:userschool.count];
    for (NSDictionary *dic  in userschool) {
        ISchoolResult *userschoolM = [ISchoolResult objectWithKeyValues:dic];
        [schoolArrayM addObject:userschoolM];
    }
    return (@{@"feed":feedM,@"investor":investorM,@"profile":profileM,@"usercompany":companyArrayM,@"userschool":schoolArrayM});
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSInteger i = 2;
    IIMeInvestAuthModel *inve = [_dataDicM objectForKey:@"investor"];
    if (inve.items.count||inve.stages.count||inve.industry.count||_projectName.length) {
        i+=1;
    }
    if (section == i) {
        return 15;
    }
    return 0;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"个人信息"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger n = 3;
    IIMeInvestAuthModel *inve = [_dataDicM objectForKey:@"investor"];
    if (inve.items.count||inve.industry.count||inve.stages.count||_projectName.length) {
        n+=1;
    }
    return n;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section ==1){
        NSInteger a = 1;
        if (_userMode.provincename||_userMode.cityname) {
            a+=1;
        }
        
        if (_sameFriendArry.count) {
            a+=1;
        }
        return a;
    }else if (section == 2){
        IIMeInvestAuthModel *inve = [_dataDicM objectForKey:@"investor"];
        if ((inve.items.count||inve.industry.count||inve.stages.count) && (_projectName.length)) {
            return 2;
        }else if (inve.items.count||inve.industry.count||inve.stages.count ||_projectName.length){
            return 1;
        }else{
            return 2;
        }
    }else if (section == 3){
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *yibancellid = @"yibancellid";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:yibancellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:yibancellid];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    WLStatusM *statMode = [_dataDicM objectForKey:@"feed"];
    NSArray *userschool = [_dataDicM objectForKey:@"userschool"];
    NSArray *usercompany = [_dataDicM objectForKey:@"usercompany"];
    
    if (indexPath.section==0) {
        HaderInfoCell *hacell = [HaderInfoCell cellWithTableView:self.tableView];
        [hacell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [hacell setUserM:_userMode];
        return hacell;
    }else if (indexPath.section==1){
        
        if (indexPath.row==0) {
            if (_userMode.provincename||_userMode.cityname) {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                [cell.textLabel setText:@"所在地区"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@   %@",_userMode.provincename,_userMode.cityname]];
            }else if(_sameFriendArry.count){
                SameFriendsCell *samcell = [tableView dequeueReusableCellWithIdentifier:sameFriendcellid];
                [samcell setImageURLArray:_sameFriendArry];
                return samcell;
            }else{
                StaurCell *staucell = [tableView dequeueReusableCellWithIdentifier:staurCellid];
                [staucell setStatusM:statMode];
                return staucell;
            }
        }else if (indexPath.row==1){
            if ((_userMode.provincename||_userMode.cityname)&&_sameFriendArry.count) {
                SameFriendsCell *samcell = [tableView dequeueReusableCellWithIdentifier:sameFriendcellid];
                [samcell setImageURLArray:_sameFriendArry];
                return samcell;
            }else{
                StaurCell *staucell = [tableView dequeueReusableCellWithIdentifier:staurCellid];
                [staucell setStatusM:statMode];
                return staucell;
            }
            
        }else if (indexPath.row==2){
            StaurCell *staucell = [tableView dequeueReusableCellWithIdentifier:staurCellid];
            [staucell setStatusM:statMode];
            return staucell;
        }
    }else if (indexPath.section==2){
        IIMeInvestAuthModel *inve = [_dataDicM objectForKey:@"investor"];
        if (inve.items.count||inve.industry.count||inve.stages.count || _projectName.length) {
            if (inve.items.count||inve.industry.count||inve.stages.count) {
                if (indexPath.row ==0) {
                    [cell.textLabel setText:@"我是投资人"];
                    NSMutableString *stagesStr = [NSMutableString string];
                    NSArray *investIndustryarray = inve.items;
                    for (InvestItemM *item in investIndustryarray) {
                        [stagesStr appendFormat:@"%@  ",item.item];
                    }
                    [cell.detailTextLabel setText:stagesStr];
                }else if (_projectName.length) {
                    [cell.textLabel setText:@"我的项目"];
                    [cell.detailTextLabel setText:_projectName];
                }
            }else if(_projectName.length){
                if (indexPath.row==0) {
                    [cell.textLabel setText:@"我的项目"];
                    [cell.detailTextLabel setText:_projectName];
                }
            }
            
        }else{
        
            if (indexPath.row==0) {
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                [cell.textLabel setText:@"教育背景"];
                
                if (userschool.count) {
                    SchoolModel *schoolM = userschool.firstObject;
                    [cell.detailTextLabel setText:schoolM.schoolname];
                }else{
                    [cell.detailTextLabel setText:@"暂无"];
                }
                
            }else if (indexPath.row==1){
                [cell.textLabel setText:@"工作经历"];
                if (usercompany.count) {
                    CompanyModel *companM = usercompany.firstObject;
                    [cell.detailTextLabel setText:companM.companyname];
                }else{
                    [cell.detailTextLabel setText:@"暂无"];
                }
            }
        }

    }else if (indexPath.section ==3){
        if (indexPath.row==0) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell.textLabel setText:@"教育背景"];
            
            if (userschool.count) {
                SchoolModel *schoolM = userschool.firstObject;
                [cell.detailTextLabel setText:schoolM.schoolname];
            }else{
                [cell.detailTextLabel setText:@"暂无"];
            }
            
        }else if (indexPath.row==1){
            [cell.textLabel setText:@"工作经历"];
            if (usercompany.count) {
                CompanyModel *companM = usercompany.firstObject;
                [cell.detailTextLabel setText:companM.companyname];
            }else{
                [cell.detailTextLabel setText:@"暂无"];
            }
        }
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 90.0;
    }else if(indexPath.section==1){
        if (indexPath.row==0) {
            if (_userMode.provincename||_userMode.cityname) {
                return 44.0;
            }else if (_sameFriendArry.count){
                return 60.0;
            }else{
                return 60.0;
            }
        }else {
            return 60.0;
        }
    }else {
        return 44.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *celltext = cell.textLabel.text;
    if ([celltext isEqualToString:@"我的项目"]) {
        
        MyProjectViewController *projectVC = [[MyProjectViewController alloc] initWithUid:_userMode.uid];
        [projectVC setTitle:@"我的项目"];
        [self.navigationController pushViewController:projectVC animated:YES];
        
    }else if ([celltext isEqualToString:@"教育背景"]) {
        NSArray *userschool = [_dataDicM objectForKey:@"userschool"];

        ListdaController *schooL = [[ListdaController alloc] initWithStyle:UITableViewStyleGrouped WithList:userschool andType:@"1"];

        [self.navigationController pushViewController:schooL animated:YES];
    }else if ([celltext isEqualToString:@"工作经历"]){
        NSArray *usercompany = [_dataDicM objectForKey:@"usercompany"];

        ListdaController *workVC = [[ListdaController alloc] initWithStyle:UITableViewStyleGrouped WithList:usercompany andType:@"2"];
        [self.navigationController pushViewController:workVC animated:YES];
    }else if([celltext isEqualToString:@"我是投资人"]){
        
        InvestInfoListVC *investListVC = [[InvestInfoListVC alloc] initWithStyle:UITableViewStyleGrouped];
        [investListVC setUserName:_userMode.name];
        IIMeInvestAuthModel *inves = [_dataDicM objectForKey:@"investor"];
        [investListVC setIimeInvestM:inves];
        [self.navigationController pushViewController:investListVC animated:YES];
    }else{
        if (indexPath.section==1) {
            if (indexPath.row==0) {
                if (_userMode.provincename||_userMode.cityname) {
                    
                }else if (_sameFriendArry.count){
                    [self.navigationController pushViewController:[[CommonFriendsController alloc] initWithStyle:UITableViewStylePlain withFriends:_sameFriendArry] animated:YES];
                }else{
                    HomeController *homeVC = [[HomeController alloc] initWithUid:_userMode.uid];
                    [homeVC setTitle:@"最新动态"];
                    [self.navigationController pushViewController:homeVC animated:YES];
                }
            }else if (indexPath.row==1){
                if ((_userMode.provincename||_userMode.cityname)&&_sameFriendArry.count) {
                    
                    [self.navigationController pushViewController:[[CommonFriendsController alloc] initWithStyle:UITableViewStylePlain withFriends:_sameFriendArry] animated:YES];
                }else{
                    HomeController *homeVC = [[HomeController alloc] initWithUid:_userMode.uid];
                    [homeVC setTitle:@"最新动态"];
                    [self.navigationController pushViewController:homeVC animated:YES];
                }
            }else if (indexPath.row==2){
                
                HomeController *homeVC = [[HomeController alloc] initWithUid:_userMode.uid];
                [homeVC setTitle:@"最新动态"];
                [self.navigationController pushViewController:homeVC animated:YES];
            }
        }
    
    }
    
}

@end
