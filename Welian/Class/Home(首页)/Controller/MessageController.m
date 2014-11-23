//
//  MessageController.m
//  weLian
//
//  Created by dong on 14/11/13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "MessageController.h"
#import "WLDataDBTool.h"
#import "MessageHomeModel.h"
#import "MJExtension.h"
#import "MessageCell.h"
#import "CommentInfoController.h"
#import "WLStatusFrame.h"
#import "WLStatusM.h"
#import "NotstringView.h"
#import "UIImage+ImageEffects.h"

@interface MessageController ()
{
    NSMutableArray *_messageDataArray;
    NSArray *_allMessgeArray;
}

@property (nonatomic, strong) NotstringView *notView;

@property (nonatomic, strong) UIButton *footButton;

@end

@implementation MessageController

- (UIView *)footButton
{
    if (_footButton== nil) {
        _footButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
//        [_footButton setBackgroundImage:[UIImage resizedImage:@"tabbar_b"] forState:UIControlStateNormal];
        [_footButton setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateNormal];
//        [_footButton setBackgroundImage:[UIImage resizedImage:@"tabbar_b@2x"] forState:UIControlStateHighlighted];
        // tableFooterView的宽度是不需要设置。默认就是整个tableView的宽度
        _footButton.bounds = CGRectMake(0, 0, 0, 44);
        [_footButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        // 4.设置按钮文字
        [_footButton setTitle:@"查看更早的信息" forState:UIControlStateNormal];
        
        [_footButton addTarget:self action:@selector(loadAllMessgeData:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footButton;
}


- (void)loadAllMessgeData:(UIButton*)but
{
    [self.tableView setTableFooterView:nil];
    [_messageDataArray removeAllObjects];
    for (NSDictionary *mesitme in _allMessgeArray) {
        MessageHomeModel *messageM = [MessageHomeModel objectWithKeyValues:mesitme];
        MessageFrameModel *messageFrameM = [[MessageFrameModel alloc] init];
        [messageFrameM setMessageDataM:messageM];
        [_messageDataArray addObject:messageFrameM];
    }
    [self.tableView reloadData];
}

- (NotstringView *)notView
{
    if (_notView == nil ) {
        _notView = [[NotstringView alloc] initWithFrame:self.tableView.frame withTitStr:@"还没有消息通知哦！" andImageName:@"remind_big_logo"];
    }
    return _notView;
}

- (instancetype)initWithStyle:(UITableViewStyle)style isAllMessage:(BOOL)isAllMessage
{
    self = [super initWithStyle:style];
    if (self) {
        [UserDefaults removeObjectForKey:KMessagebadge];
        _messageDataArray = [NSMutableArray array];
        [self.tableView setSectionHeaderHeight:0.1];
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self.tableView setSectionFooterHeight:0];
        
       NSArray *dataA = [[WLDataDBTool sharedService] getAllItemsFromTable:KMessageHomeTableName];

        if (dataA.count) {
            [self.notView removeFromSuperview];
            
            NSMutableArray *itmeArrayM = [NSMutableArray arrayWithCapacity:dataA.count];
            
            for (YTKKeyValueItem *itemob in dataA) {
                [itmeArrayM addObject:itemob.itemObject];
            }
            NSSortDescriptor *bookNameDes=[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO];
            
            [itmeArrayM sortUsingDescriptors:@[bookNameDes]];
            
            _allMessgeArray = [NSArray arrayWithArray:itmeArrayM];
            
            if (isAllMessage) {
                for (NSDictionary *mesitme in itmeArrayM) {
                    MessageHomeModel *messageM = [MessageHomeModel objectWithKeyValues:mesitme];
                    MessageFrameModel *messageFrameM = [[MessageFrameModel alloc] init];
                    [messageFrameM setMessageDataM:messageM];
                    [_messageDataArray addObject:messageFrameM];
                }
                
                [self.tableView reloadData];
                
            }else{
                for (NSDictionary *mesitme in itmeArrayM) {

                    if (![[mesitme objectForKey:@"isLook"] isEqualToString:@"1"]) {
                        MessageHomeModel *messageM = [[MessageHomeModel alloc] init];
                        [messageM setKeyValues:mesitme];
                        
                        [messageM setIsLook:@"1"];
                        MessageFrameModel *messageFrameM = [[MessageFrameModel alloc] init];
                        [messageFrameM setMessageDataM:messageM];
                        
                        [_messageDataArray addObject:messageFrameM];
                        
                        [[WLDataDBTool sharedService] putObject:[messageM keyValues] withId:messageM.commentid intoTable:KMessageHomeTableName];
                    }
                }
                [self.tableView setTableFooterView:self.footButton];
                [self.tableView reloadData];
            }
        
        }else{

            [self.tableView addSubview:self.notView];
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"消息列表"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _messageDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *messageCell = [MessageCell cellWithTableView:tableView];
    
    MessageFrameModel *messageFrameModel = _messageDataArray[indexPath.row];
    
    [messageCell setMessageFrameModel:messageFrameModel];
    
    return messageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageFrameModel *messageFrameModel = _messageDataArray[indexPath.row];
    
    return messageFrameModel.cellHigh;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageFrameModel *messageFrameModel = _messageDataArray[indexPath.row];
    MessageHomeModel *messagedata = messageFrameModel.messageDataM;
    NSInteger fid = [messagedata.feedid integerValue];
    [WLHttpTool loadOneFeedParameterDic:@{@"fid":@(fid)} success:^(id JSON) {
        NSDictionary *Feeddic = [NSDictionary dictionaryWithDictionary:JSON];
        WLStatusM *statusM = [WLStatusM objectWithKeyValues:Feeddic];
        WLStatusFrame *sf = [[WLStatusFrame alloc] init];
        sf.status = statusM;
        CommentInfoController *commentVC = [[CommentInfoController alloc] init];
        [commentVC setStatusFrame:sf];
        [self.navigationController pushViewController:commentVC animated:YES];
    } fail:^(NSError *error) {
        
    }];
    

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
