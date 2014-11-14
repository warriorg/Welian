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

@interface MessageController ()
{
    NSMutableArray *_messageDataArray;
}

@end

@implementation MessageController

- (instancetype)initWithStyle:(UITableViewStyle)style isAllMessage:(BOOL)isAllMessage
{
    self = [super initWithStyle:style];
    if (self) {
        [UserDefaults removeObjectForKey:KMessagebadge];
        _messageDataArray = [NSMutableArray array];
        [self.tableView setSectionHeaderHeight:0.1];
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
       NSArray *dataA = [[WLDataDBTool sharedService] getAllItemsFromTable:KMessageHomeTableName];
        NSSortDescriptor *bookNameDes=[NSSortDescriptor sortDescriptorWithKey:@"createdTime" ascending:NO];
        dataA = [dataA sortedArrayUsingDescriptors:@[bookNameDes]];
        
        if (isAllMessage) {
            for (YTKKeyValueItem *mesitme in dataA) {
                MessageHomeModel *messageM = [MessageHomeModel objectWithKeyValues:mesitme.itemObject];
                MessageFrameModel *messageFrameM = [[MessageFrameModel alloc] init];
                [messageFrameM setMessageDataM:messageM];
                [_messageDataArray addObject:messageFrameM];
            }
            [self.tableView reloadData];
            
        }else{
            for (YTKKeyValueItem *mesitme in dataA) {
                
                NSMutableDictionary *mesDic = [NSMutableDictionary dictionaryWithDictionary:mesitme.itemObject];
                MessageHomeModel *messageM = [MessageHomeModel objectWithKeyValues:mesDic];
                if (![messageM.isLook isEqualToString:@"1"]) {
                    
                    MessageFrameModel *messageFrameM = [[MessageFrameModel alloc] init];
                    [messageFrameM setMessageDataM:messageM];
                    [_messageDataArray addObject:messageFrameM];
                    [mesDic setObject:@"1" forKey:@"isLook"];
                }
                
                [[WLDataDBTool sharedService] putObject:mesDic withId:[mesDic objectForKey:@"comentid"] intoTable:KMessageHomeTableName];
            }
            [self.tableView reloadData];
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
