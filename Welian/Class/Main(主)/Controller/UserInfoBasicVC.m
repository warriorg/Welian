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

@interface UserInfoBasicVC () <UIAlertViewDelegate,UIActionSheetDelegate>
{
    IBaseUserM *_userMode;
    NSMutableDictionary *_dataDicM;
    NSMutableArray *_sameFriendArry;
}

@property (nonatomic,strong) UIView *addFriendView;

@property (nonatomic, strong) UIView *sendView;

@property (nonatomic, strong) UIView *askView;

@end

static NSString *sameFriendcellid = @"sameFriendcellid";
static NSString *staurCellid = @"staurCellid";

@implementation UserInfoBasicVC

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
    [self.tableView setTableFooterView:nil];
//    [self.tableView setTableFooterView:self.sendView];
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
    MyFriendUser *user = [MyFriendUser getMyfriendUserWithUid:_userMode.uid];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithUser:user];
    chatVC.isFromUserInfo = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
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
//    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    LogInUser *mode = [LogInUser getNowLogInUser];
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
        } fail:^(NSError *error) {
            
        }];
    }
}

- (void)moreItmeClick:(UIBarButtonItem*)item
{
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    [sheet setDelegate:self];
    [sheet addButtonWithTitle:@"推荐给好友"];
    if ([_userMode.friendship integerValue]==1) {
        [sheet addButtonWithTitle:@"删除该好友"];
        [sheet setDestructiveButtonIndex:1];
    }
    [sheet addButtonWithTitle:@"取消"];
    [sheet setCancelButtonIndex:sheet.numberOfButtons-1];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {  //推荐给好友
        
    }else if(buttonIndex==1){
        if ([_userMode.friendship integerValue]==1) {  // 删除好友
            [WLHttpTool deleteFriendParameterDic:@{@"fid":_userMode.uid} success:^(id JSON) {
                
//                [[WLDataDBTool sharedService] deleteObjectById:[NSString stringWithFormat:@"%@",_userMode.uid] fromTable:KMyAllFriendsKey];
                
                MyFriendUser *friendUser = [MyFriendUser getMyfriendUserWithUid:_userMode.uid];
                //数据库删除当前好友
                [[LogInUser getNowLogInUser] removeRsMyFriendsObject:friendUser];
                
                //删除新的好友本地数据库
                NewFriendUser *newFuser = [NewFriendUser getNewFriendUserWithUid:_userMode.uid];
                if (newFuser) {
                    [newFuser delete];
//                    [[LogInUser getNowLogInUser] removeRsNewFriendsObject:[NewFriendUser getNewFriendUserWithUid:_userMode.uid]];
                }
                
                //聊天状态发送改变
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatUserChanged" object:nil];
                
//                [[WLDataDBTool sharedService] deleteObjectById:[NSString stringWithFormat:@"%@",_userMode.uid] fromTable:KNewFriendsTableName];
                [MOC save];
                [[NSNotificationCenter defaultCenter] postNotificationName:KupdataMyAllFriends object:self];
                [self.navigationController popViewControllerAnimated:YES];
                [WLHUDView showSuccessHUD:@"删除成功！"];
            } fail:^(NSError *error) {
                
            }];
            
        }
    }
    
}


- (instancetype)initWithStyle:(UITableViewStyle)style andUsermode:(IBaseUserM *)usermode isAsk:(BOOL)isask
{
    _userMode = usermode;
    _dataDicM = [NSMutableDictionary dictionary];
    self = [super initWithStyle:style];
    if (self) {
        [self.tableView setSectionHeaderHeight:0.0];
        
        LogInUser *mode = [LogInUser getNowLogInUser];
        if (!([mode.uid integerValue]==[_userMode.uid integerValue])) {
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_more"] style:UIBarButtonItemStyleBordered target:self action:@selector(moreItmeClick:)];
        }
        [WLHttpTool loadUserInfoParameterDic:@{@"uid":_userMode.uid} success:^(id JSON) {
            
            [WLHttpTool loadSameFriendParameterDic:@{@"uid":mode.uid,@"fid":_userMode.uid,@"size":@(1000)} success:^(id JSON) {
                _sameFriendArry = [JSON objectForKey:@"samefriends"];
                [self.tableView reloadData];
            } fail:^(NSError *error) {
                
            }];

            _dataDicM = [NSMutableDictionary dictionaryWithDictionary:JSON];
            _userMode = [_dataDicM objectForKey:@"profile"];
            if (!isask) {
                if ([_userMode.friendship integerValue]==-1) {
                    
                }else if ([_userMode.friendship integerValue]==1) {
                    if (!_isHideSendMsgBtn) {
                        [self.tableView setTableFooterView:self.sendView];
                    }
                }else {
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSInteger i = 2;
    IIMeInvestAuthModel *inve = [_dataDicM objectForKey:@"investor"];
    if (inve.items.count||inve.stages.count||inve.industry.count) {
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
    if (inve.items.count||inve.industry.count||inve.stages.count) {
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
        return 2;
    }else if (section == 3){
        return 1;
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
    }else if (indexPath.section ==3){
        IIMeInvestAuthModel *inve = [_dataDicM objectForKey:@"investor"];
        if (inve.items.count||inve.industry.count||inve.stages.count) {
            [cell.textLabel setText:@"我是投资人"];
            NSMutableString *stagesStr = [NSMutableString string];
            NSArray *investIndustryarray = inve.items;
            for (InvestItemM *item in investIndustryarray) {
                [stagesStr appendFormat:@"%@  ",item.item];
            }
            [cell.detailTextLabel setText:stagesStr];
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
    if ([celltext isEqualToString:@"教育背景"]) {
        NSArray *userschool = [_dataDicM objectForKey:@"userschool"];

        ListdaController *schooL = [[ListdaController alloc] initWithStyle:UITableViewStyleGrouped WithList:userschool andType:@"1"];

        [self.navigationController pushViewController:schooL animated:YES];
    }else if ([celltext isEqualToString:@"工作经历"]){
        NSArray *usercompany = [_dataDicM objectForKey:@"usercompany"];

        ListdaController *workVC = [[ListdaController alloc] initWithStyle:UITableViewStyleGrouped WithList:usercompany andType:@"2"];
        [self.navigationController pushViewController:workVC animated:YES];
    }else if([celltext isEqualToString:@"我是投资人"]){
        IIMeInvestAuthModel *inves = [_dataDicM objectForKey:@"investor"];

        ListdaController *investVC = [[ListdaController alloc] initWithStyle:UITableViewStyleGrouped WithList:inves.items andType:@"3"];
        [self.navigationController pushViewController:investVC animated:YES];
    }else{
        if (indexPath.section==1) {
            if (indexPath.row==0) {
                if (_userMode.provincename||_userMode.cityname) {
                    
                }else if (_sameFriendArry.count){
                    [self.navigationController pushViewController:[[CommonFriendsController alloc] initWithStyle:UITableViewStylePlain withFriends:_sameFriendArry] animated:YES];
                }else{
                    HomeController *homeVC = [[HomeController alloc] initWithStyle:UITableViewStylePlain anduid:_userMode.uid];
                    [homeVC setTitle:@"最新动态"];
                    [self.navigationController pushViewController:homeVC animated:YES];
                }
            }else if (indexPath.row==1){
                if ((_userMode.provincename||_userMode.cityname)&&_sameFriendArry.count) {
                    
                    [self.navigationController pushViewController:[[CommonFriendsController alloc] initWithStyle:UITableViewStylePlain withFriends:_sameFriendArry] animated:YES];
                }else{
                    HomeController *homeVC = [[HomeController alloc] initWithStyle:UITableViewStylePlain anduid:_userMode.uid];
                    [homeVC setTitle:@"最新动态"];
                    [self.navigationController pushViewController:homeVC animated:YES];
                }
            }else if (indexPath.row==2){
                
                HomeController *homeVC = [[HomeController alloc] initWithStyle:UITableViewStylePlain anduid:_userMode.uid];
                [homeVC setTitle:@"最新动态"];
                [self.navigationController pushViewController:homeVC animated:YES];
            }
        }
    
    }
    
}

@end
