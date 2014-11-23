//
//  CommentInfoController.m
//  weLian
//
//  Created by dong on 14-10-12.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "CommentInfoController.h"
#import "WLStatusFrame.h"
#import "WLStatusM.h"
#import "CommentCell.h"
#import "MJRefresh.h"
#import "MessageKeyboardView.h"
#import "ZBMessageManagerFaceView.h"
#import "NoCommentCell.h"
#import "FeedAndZanModel.h"
#import "MJExtension.h"
#import "FeedAndZanFrameM.h"
#import "FeedAndZanCell.h"

@interface CommentInfoController () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    NSMutableArray *_dataArrayM;
    CommentCellFrame *_selecCommFrame;
    NSMutableArray *_feedArrayM;
    NSMutableArray *_zanArrayM;
    
    FeedAndZanFrameM *_feedAndZanFM;
}
@property (nonatomic, strong) WLStatusCell *statusCell;
@property (nonatomic, strong) NSMutableDictionary *reqestDic;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) MessageKeyboardView *messageView;


@end

static NSString *noCommentCell = @"NoCommentCell";

@implementation CommentInfoController


- (WLStatusCell*)statusCell
{
    if (_statusCell == nil) {
        _statusCell = [WLStatusCell cellWithTableView:nil];
        
//        [_statusCell.dock.attitudeBtn addTarget:self action:@selector(attitudeBtnClick:) forControlEvents:UIControlEventTouchDown];
//        [_statusCell.dock.commentBtn addTarget:self action:@selector(becomComment) forControlEvents:UIControlEventTouchUpInside];
        [_statusCell setHomeVC:self];
//        UIView *lveView = [[UIView alloc] initWithFrame:CGRectMake(0, self.statusFrame.contentFrame.dockY+7, self.view.bounds.size.width, 10)];
//        [lveView setBackgroundColor:WLLineColor];
//        [_statusCell addSubview:lveView];
        UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
        if ([self.statusFrame.status.user.uid integerValue] == [mode.uid integerValue]) {
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_more"] style:UIBarButtonItemStyleBordered target:self action:@selector(moreButClick:)];
        }
    }
    [_statusCell setStatusFrame:self.statusFrame];
    [_statusCell.moreBut setHidden:YES];
    
    return _statusCell;
}

// 加载赞和转发数据
- (void)loadnewFeedZanAndForward
{
    [WLHttpTool loadFeedZanAndForwardParameterDic:@{@"fid":@(self.statusFrame.status.fid)} success:^(id JSON) {
        if (_feedAndZanFM) return;
        
        NSArray *feedarray = [JSON objectForKey:@"forwards"];
        NSArray *zanarray = [JSON objectForKey:@"zans"];
        
        if (feedarray.count) {
            for (NSDictionary *feeddic in feedarray) {
                FeedAndZanModel *mode = [FeedAndZanModel objectWithKeyValues:feeddic];
                [_feedArrayM addObject:mode];
            }
        }
        if (zanarray.count) {
            for (NSDictionary *zandic in zanarray) {
                FeedAndZanModel *mode = [FeedAndZanModel objectWithKeyValues:zandic];
                [_zanArrayM addObject:mode];
            }
        }
        if (zanarray.count || feedarray.count) {
            
            _feedAndZanFM = [[FeedAndZanFrameM alloc] initWithWidth:[UIScreen mainScreen].bounds.size.width];
            [_feedAndZanFM setFeedAndzanDic:@{@"zans":_zanArrayM,@"forwards":_feedArrayM}];
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)becomComment
{
    [self.messageView.commentTextView becomeFirstResponder];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-50) style:UITableViewStyleGrouped];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, IWIconWHSmall+2*IWCellBorderWidth, 0, 0)];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView registerNib:[UINib nibWithNibName:@"NoCommentCell" bundle:nil] forCellReuseIdentifier:noCommentCell];
    }
    return _tableView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"详情"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forwardCommtion) name:KPublishOK object:nil];
    [self.view setBackgroundColor:WLLineColor];
    _feedArrayM = [NSMutableArray array];
    _zanArrayM = [NSMutableArray array];
    self.reqestDic = [NSMutableDictionary dictionary];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadnewcommentAndFeedZanAndForward) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self.refreshControl beginRefreshing];
    [self loadnewcommentAndFeedZanAndForward];
    
    [self.view addSubview:self.tableView];
    
    self.messageView = [[MessageKeyboardView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height, self.view.frame.size.width, 50) andSuperView:self.view withMessageBlock:^(NSString *comment) {

        NSMutableDictionary *reqstDicM = [NSMutableDictionary dictionary];
        [reqstDicM setObject:@(self.statusFrame.status.fid) forKey:@"fid"];
        [reqstDicM setObject:comment forKey:@"comment"];
        
        if (_selecCommFrame) {
            [reqstDicM setObject:_selecCommFrame.commentM.user.uid forKey:@"touid"];
        }
        
        [WLHttpTool addFeedCommentParameterDic:reqstDicM success:^(id JSON) {

            self.statusFrame.status.commentcount++;
            [self loadNewCommentListData];
            [self backDataStatusFrame:NO];
        } fail:^(NSError *error) {
            
        }];
        
    }];
    
    [self.view addSubview:self.messageView];
    if (_beginEdit) {
        
        [self.messageView.commentTextView becomeFirstResponder];
    }

    [self.tableView addFooterWithTarget:self action:@selector(loadMoreCommentData)];
}


- (void)moreButClick:(UIBarButtonItem*)item
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除该条动态" otherButtonTitles:nil,nil];
    [sheet setTag:800];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==800) {
        if (buttonIndex==0) {
            __weak CommentInfoController *commVC = self;
            [WLHttpTool deleteFeedParameterDic:@{@"fid":@(self.statusFrame.status.fid)} success:^(id JSON) {
                
                [WLHUDView showSuccessHUD:@"删除动态成功！"];
                [commVC backDataStatusFrame:YES];
                 [self.navigationController popViewControllerAnimated:YES];
            } fail:^(NSError *error) {
                
            }];
        }
        
    }
}

- (void)backDataStatusFrame:(BOOL)isdelete
{
    if ([_delegate respondsToSelector:@selector(commentInfoController:isDelete:withStatusFrame:)]) {
        [_delegate commentInfoController:self isDelete:isdelete withStatusFrame:_statusFrame];
    }
}


- (void)forwardCommtion
{
    self.statusFrame.status.forwardcount++;
    self.statusCell;
   UserInfoModel *usermode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    
    FeedAndZanModel *fzmodel = [[FeedAndZanModel alloc] init];
    [fzmodel setUser:usermode];
    [_feedArrayM insertObject:fzmodel atIndex:0];
    [self refreshDataChangde];
}

- (void)loadnewcommentAndFeedZanAndForward
{
    [self loadNewCommentListData];
    [self loadnewFeedZanAndForward];
}


- (void)loadNewCommentListData
{
    [self.tableView setFooterHidden:YES];
    [self.reqestDic setObject:@(self.statusFrame.status.fid) forKey:@"fid"];
    [self.reqestDic setObject:@(KCellConut) forKey:@"size"];
    [self.reqestDic setObject:@(1) forKey:@"page"];
    [WLHttpTool loadFeedCommentParameterDic:self.reqestDic success:^(id JSON) {

        _dataArrayM = JSON;
        [self hiddenRefresh];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [self.refreshControl endRefreshing];
    }];
}

- (void)loadMoreCommentData
{
    if (_dataArrayM.count<=0)    return;
    
    [WLHttpTool loadFeedCommentParameterDic:self.reqestDic success:^(id JSON) {
        NSArray *dataarr = JSON;
        [_dataArrayM addObjectsFromArray:dataarr];
        
        [self hiddenRefresh];
        if (dataarr.count<KCellConut) {
            self.tableView.footerHidden = YES;
        }
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        
    }];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.messageView dismissKeyBoard];
}

- (void)hiddenRefresh
{
    [self.refreshControl endRefreshing];
    [self.tableView footerEndRefreshing];
    
    if (_dataArrayM.count<KCellConut) {
        [self.tableView setFooterHidden:YES];
    }else{
        NSInteger page = [[self.reqestDic objectForKey:@"page"] integerValue];
        page++;
        [self.reqestDic setObject:@(page) forKey:@"page"];
        [self.tableView setFooterHidden:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.statusFrame.contentFrame.cellHeight+20;
}
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.statusCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger a = 0;
    if (_feedAndZanFM) {
        a +=1;
    }
    if (_dataArrayM.count) {
        
        return _dataArrayM.count+a;
    }else{
        return 1+a;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArrayM.count) {
        if (_feedAndZanFM) {
            if (indexPath.row==0) {
                
                return _feedAndZanFM.cellHigh;
            }else{
                CommentCellFrame *commFrame = _dataArrayM[indexPath.row-1];
                return commFrame.cellHeight;
            }
        }else{
            CommentCellFrame *commFrame = _dataArrayM[indexPath.row];
            return commFrame.cellHeight;
        }
        
    }else{
        if (_feedAndZanFM) {
            if (indexPath.row==0) {
                return _feedAndZanFM.cellHigh;
            }else{
                return 90;
            }
        }else{
            return 90;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_feedAndZanFM) {
        if (indexPath.row==0) {
            static NSString *feedAndZancellid = @"feedAndZancellid";
            FeedAndZanCell *cell = [tableView dequeueReusableCellWithIdentifier:feedAndZancellid];
            if (cell == nil) {
                cell = [[FeedAndZanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:feedAndZancellid];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setCommentVC:self];
            }
            [cell setFeedAndZanFrame:_feedAndZanFM];
            return cell;
        }else{
            if (_dataArrayM.count) {
                CommentCell *cell = [CommentCell cellWithTableView:tableView];
                // 传递的模型：文字数据 + 子控件frame数据
                cell.commentCellFrame = _dataArrayM[indexPath.row-1];
                cell.commentVC = self;
                return cell;
                
            }else{
                NoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:noCommentCell];
                return cell;
            }
        }
    }else{
        if (_dataArrayM.count) {
            CommentCell *cell = [CommentCell cellWithTableView:tableView];
            // 传递的模型：文字数据 + 子控件frame数据
            cell.commentCellFrame = _dataArrayM[indexPath.row];
            cell.commentVC = self;
            return cell;
        }else{
            NoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:noCommentCell];
            return cell;
        }

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_feedAndZanFM) {
        if (indexPath.row==0) {
            return;
        }
        _selecCommFrame = _dataArrayM[indexPath.row-1];
    }else{
        _selecCommFrame = _dataArrayM[indexPath.row];
    }

    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    if ([_selecCommFrame.commentM.user.uid integerValue]==[mode.uid integerValue]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"回复" otherButtonTitles:@"删除", nil];
        [sheet setTag:555+0];
        [sheet showInView:self.view];
    }else{
//        [self.messageView startCompile:_selecCommFrame.commentM.user];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"回复" otherButtonTitles:nil, nil];
        [sheet setTag:555+1];
        [sheet showInView:self.view];
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==555+1) {
        if (buttonIndex==0) {
            [self.messageView startCompile:_selecCommFrame.commentM.user];
        }
        
    }else if(actionSheet.tag==555+0){
        if (buttonIndex==0) {
            [self.messageView startCompile:_selecCommFrame.commentM.user];
        }else if (buttonIndex==1){
            [WLHttpTool deleteFeedCommentParameterDic:@{@"fcid":_selecCommFrame.commentM.fcid} success:^(id JSON) {
                [_dataArrayM removeObject:_selecCommFrame];
                self.statusFrame.status.commentcount--;
                [self.tableView reloadData];
                self.statusCell;
                
                [self backDataStatusFrame:NO];
            } fail:^(NSError *error) {
                
            }];
        }
    }
}


#pragma mark - 赞
- (void)attitudeBtnClick:(UIButton*)but
{
    [but setEnabled:NO];
   UserInfoModel *usermode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    
    if (self.statusFrame.status.iszan==1) {
        FeedAndZanModel *seleMode= nil;
        for (FeedAndZanModel *mode in _zanArrayM) {
            if ([mode.user.uid integerValue] == [usermode.uid integerValue]) {
                seleMode = mode;
                break;
            }
        }
        [_zanArrayM removeObject:seleMode];
        [self refreshDataChangde];
        
        [WLHttpTool deleteFeedZanParameterDic:@{@"fid":@(self.statusFrame.status.fid)} success:^(id JSON) {
            [self.statusFrame.status setIszan:0];
            self.statusFrame.status.zan -= 1;
            self.statusCell;
            [but setEnabled:YES];
            [self backDataStatusFrame:NO];
        } fail:^(NSError *error) {
            [but setEnabled:YES];
        }];
    }else{
        FeedAndZanModel *fzmodel = [[FeedAndZanModel alloc] init];
        [fzmodel setUser:usermode];
        [_zanArrayM insertObject:fzmodel atIndex:0];
        [self refreshDataChangde];
        
        [WLHttpTool addFeedZanParameterDic:@{@"fid":@(self.statusFrame.status.fid)} success:^(id JSON) {
            [self.statusFrame.status setIszan:1];
            self.statusFrame.status.zan +=1;
            self.statusCell;
            [but setEnabled:YES];
            [self backDataStatusFrame:NO];
        } fail:^(NSError *error) {
            [but setEnabled:YES];
        }];
    }
}

- (void)refreshDataChangde
{
    if (_zanArrayM.count||_feedArrayM.count) {
        if (!_feedAndZanFM) {
            _feedAndZanFM = [[FeedAndZanFrameM alloc] init];
        }
        [_feedAndZanFM setFeedAndzanDic:@{@"zans":_zanArrayM,@"forwards":_feedArrayM}];
        
    }else{
        _feedAndZanFM = nil;
    }
    [self.tableView reloadData];

}


@end
