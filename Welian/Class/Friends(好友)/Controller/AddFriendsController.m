//
//  AddFriendsController.m
//  weLian
//
//  Created by dong on 14/10/23.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "AddFriendsController.h"
#import "WLTool.h"
#import "AddWXFriendCell.h"
#import "FriendCell.h"
#import "UserInfoBasicVC.h"
#import "ShareEngine.h"
#import <MessageUI/MessageUI.h>

@interface AddFriendsController () <UISearchBarDelegate,UISearchDisplayDelegate,MFMessageComposeViewControllerDelegate>
{
    FriendsAddressBook *_selecFriend;
}
@property (nonatomic,strong) UISearchDisplayController *searchDisplayVC;//搜索框控件控制器
@property (strong, nonatomic)  UISearchBar *searchBar;//搜索条
@property (nonatomic,strong) NSMutableArray *allArray;//所有数据数组
@property (nonatomic,strong) NSMutableArray *filterArray;//搜索出来的数据数组
@property (nonatomic, retain) NSOperationQueue *searchQueue;


@end


static NSString *addWXFriendCell = @"AddWXFriendCell";

static NSString *fridcellid = @"fridcellid";

@implementation AddFriendsController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMyAllFriends];
    [self setTitle:@"添加好友"];
    [self addUI];
}

- (void)addUI
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismisFriendClick)];
    self.filterArray = [NSMutableArray array];
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar setPlaceholder:@"搜索手机号/姓名"];
    [self.searchBar setDelegate:self];
    self.searchDisplayVC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    [self.searchDisplayVC setDelegate:self];
    [self.searchDisplayVC setSearchResultsDataSource:self];
    [self.searchDisplayVC setSearchResultsDelegate:self];
    [self.tableView setTableHeaderView:self.searchBar];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadMyAllFriends) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    //    [self.tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    
    //    [self.tableView setBackgroundColor:WLLineColor];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setSectionIndexColor:KBasesColor];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddWXFriendCell" bundle:nil] forCellReuseIdentifier:addWXFriendCell];
    
    [self.searchDisplayVC.searchResultsTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.searchDisplayVC.searchResultsTableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:fridcellid];

}


-(void)loadMyAllFriends
{
    [WLTool getAddressBookArray:^(NSArray *friendsAddress) {
        
        [self.allArray removeAllObjects];
        self.allArray = [NSMutableArray array];
        
        NSMutableArray *myFriend = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *wlFriend = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *noFriend = [NSMutableArray arrayWithCapacity:0];
        for (FriendsAddressBook *friend in friendsAddress) {
            if ([friend.friendship integerValue]==1) {
                
                [myFriend addObject:friend];
            }else if (friend.uid) {
                
                [wlFriend addObject:friend];
            }else if (!friend.uid){
                
                [noFriend addObject:friend];
            }
        }
        
        if (wlFriend.count) {
            [self.allArray addObject:@{@"n":@"1",@"key":[NSString stringWithFormat:@"  %d个通讯录好友待添加",wlFriend.count],@"array":wlFriend}];
        }
        if (noFriend.count) {
            [self.allArray addObject:@{@"n":@"2",@"key":[NSString stringWithFormat:@"  %d个通讯录好友可邀请",noFriend.count],@"array":noFriend}];
        }
        if (myFriend.count) {
            [self.allArray addObject:@{@"n":@"3",@"key":[NSString stringWithFormat:@"  %d个通讯录好友已添加",myFriend.count],@"array":myFriend}];
        }
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView== self.tableView) {
        
        return self.allArray.count+1;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        if (section==0) {
            return 1;
        }else{
            
            NSArray *array = [self.allArray[section-1] objectForKey:@"array"];
            return array.count;
        }
    }else{
        return self.filterArray.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        
        return indexPath.section?50.0:70;
    }else{
        return 60.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        
        return section?35.0:0.0;
    }else{
        return 35.0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section==0) {
            return nil;
        }else{
            if (self.allArray.count) {
                NSDictionary * dic = self.allArray[section-1];
                return [dic objectForKey:@"key"];
            }else{
                return nil;
            }
        }
        

    }else{
        return @"  搜索结果";
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section==0) {
            AddWXFriendCell *wxcell = [tableView dequeueReusableCellWithIdentifier:addWXFriendCell];
            return wxcell;
        }else{
            static NSString *cellidfriendid = @"cellidfriendid";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidfriendid];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellidfriendid];
                UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
                [cell setAccessoryView:detailLabel];
            }
            NSDictionary *dic =self.allArray[indexPath.section-1];
            UILabel *detai =  (UILabel*)cell.accessoryView;
            if ([[dic objectForKey:@"n"] isEqualToString:@"1"]) {
                [detai setTextColor:[UIColor greenColor]];
                [detai setText:@"添加"];

            }else if ([[dic objectForKey:@"n"] isEqualToString:@"2"]){
                [detai setTextColor:[UIColor blueColor]];
                [detai setText:@"邀请"];
            }else if ([[dic objectForKey:@"n"] isEqualToString:@"3"]){
                [detai setText:@"已添加"];
            }
            NSArray *array = [dic objectForKey:@"array"];
            FriendsAddressBook *friend = array[indexPath.row];
            [cell.textLabel setText:friend.name];
            [cell.detailTextLabel setText:friend.mobile];
            return cell;
        }
        
    }else{
        FriendCell *searchcell = [tableView dequeueReusableCellWithIdentifier:fridcellid];
        
        UserInfoModel *modeIM = self.filterArray[indexPath.row];
        
        [searchcell setUserMode:modeIM];
        return searchcell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView) {
        if (indexPath.section==0) {
            
            [[ShareEngine sharedShareEngine] sendWeChatMessage:@"请求添加为好友" andDescription:@"" WithUrl:@"" andImage:nil WithScene:weChat];
        }else{
            NSDictionary *dic =self.allArray[indexPath.section-1];
                NSArray *array = [dic objectForKey:@"array"];
            _selecFriend = array[indexPath.row];
            
            if ([[dic objectForKey:@"n"] isEqualToString:@"1"]) {
                
                UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友验证" message:[NSString stringWithFormat:@"发送至好友：%@",_selecFriend.name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
                [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"我是%@",mode.name]];
                [alert show];
            }else if ([[dic objectForKey:@"n"] isEqualToString:@"2"]){  // 短信验证
                
                [self showMessageView:_selecFriend.mobile title:@"邀请好友" body:@"我正在玩weLian，认识了不少投资和创业的朋友，嘿，你也来吧！http://welian.com"];
                
            }
        }
        
    }else{
        
        UserInfoModel *mode = self.filterArray[indexPath.row];
        UserInfoBasicVC *userBasic = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:mode];
        [self.navigationController pushViewController:userBasic animated:YES];
    }
}


#pragma mark - 短信邀请
-(void)showMessageView : (NSString *)phone title : (NSString *)title body : (NSString *)body
{
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = [NSArray arrayWithObject:phone];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [controller setTitle:title];//修改短信界面标题
        [self presentViewController:controller animated:YES completion:^{
            
        }];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    switch (result) {
        case MessageComposeResultCancelled:
        {
            //click cancel button
        }
            break;
        case MessageComposeResultFailed:// send failed
            
            break;
            
        case MessageComposeResultSent:
        {
            //do something
        }
            break;
        default:
            break;
    } 
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [WLHttpTool requestFriendParameterDic:@{@"fid":_selecFriend.uid,@"message":[alertView textFieldAtIndex:0].text} success:^(id JSON) {
            
        } fail:^(NSError *error) {
            
        }];
    }
}
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self.filterArray removeAllObjects];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{

    if ([self.filterArray count] == 0) {
        UITableView *tableView1 = self.searchDisplayController.searchResultsTableView;
        for( UIView *subview in tableView1.subviews ) {
            if( [subview class] == [UILabel class] ) {
                UILabel *lbl = (UILabel*)subview; // sv changed to subview.
                lbl.text = @"点击键盘搜索";
            }
        }
    }

    return NO;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.filterArray removeAllObjects];
    [WLHttpTool searchUserParameterDic:@{@"keyword":searchBar.text,@"page":@(1),@"size":@(100)} success:^(id JSON) {
        
        self.filterArray = JSON;
        if (!self.filterArray.count) {
            [WLHUDView showCustomHUD:@"暂无该好友" imageview:nil];
            
        }else{
        
            [self.searchDisplayVC.searchResultsTableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}



- (void)dismisFriendClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
