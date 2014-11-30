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
#import "CommentHeadView.h"
#import "LXActivity.h"
#import "ShareEngine.h"

@interface CommentInfoController () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,LXActivityDelegate>
{
    NSMutableArray *_dataArrayM;
    CommentCellFrame *_selecCommFrame;
   __block NSMutableArray *_feedArrayM;
    __block NSMutableArray *_zanArrayM;
    
    FeedAndZanFrameM *_feedAndZanFM;
}

@property (nonatomic, strong) CommentHeadView *commentHeadView;
@property (nonatomic, strong) CommentHeadFrame *commentHFrame;
@property (nonatomic, strong) NSMutableDictionary *reqestDic;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) MessageKeyboardView *messageView;

@end

static NSString *noCommentCell = @"NoCommentCell";

@implementation CommentInfoController

- (CommentHeadFrame*)commentHFrame
{
    if (_commentHFrame == nil) {
        _commentHFrame = [[CommentHeadFrame alloc] initWithWidth:[UIScreen mainScreen].bounds.size.width];
        if (!_feedAndZanFM) {
            _feedAndZanFM = [[FeedAndZanFrameM alloc] initWithWidth:[UIScreen mainScreen].bounds.size.width];
        }
    }
    [_feedAndZanFM setCellWidth:[UIScreen mainScreen].bounds.size.width];
    [_commentHFrame setStatus:self.statusM];
    return _commentHFrame;
}

- (CommentHeadView *)commentHeadView
{
    if (_commentHeadView == nil) {
        _commentHeadView = [[CommentHeadView alloc] init];
        [_commentHeadView setHomeVC:self];
//            UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
//        if ([self.statusM.user.uid integerValue]==[mode.uid integerValue]) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_more"] style:UIBarButtonItemStyleBordered target:self action:@selector(moreButClick:)];
//        }
    }
    [_commentHeadView setCommHeadFrame:self.commentHFrame];
    __weak CommentInfoController *commin = self;
    _commentHeadView.feezanBlock = ^(WLStatusM *statusM){
        
        [commin backDataStatusFrame:NO];
        [commin refreshDataChangde:statusM];
    };
    return _commentHeadView;
}

// 加载赞和转发数据
- (void)loadnewFeedZanAndForward
{
    [WLHttpTool loadFeedZanAndForwardParameterDic:@{@"fid":@(self.statusM.fid)} success:^(id JSON) {
        
        NSArray *feedarray = [JSON objectForKey:@"forwards"];
        NSArray *zanarray = [JSON objectForKey:@"zans"];
        [_feedArrayM removeAllObjects];
        [_zanArrayM removeAllObjects];
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
        [self refreshDataChangde:nil];
        
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
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_more"] style:UIBarButtonItemStyleBordered target:self action:@selector(moreButClick:)];
    
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
        [reqstDicM setObject:@(self.statusM.fid) forKey:@"fid"];
        [reqstDicM setObject:comment forKey:@"comment"];
        
        if (_selecCommFrame) {
            [reqstDicM setObject:_selecCommFrame.commentM.user.uid forKey:@"touid"];
        } 
        
        [WLHttpTool addFeedCommentParameterDic:reqstDicM success:^(id JSON) {
            
            self.statusM.commentcount++;
            [self loadNewCommentListData];
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
    NSArray *shareButtonTitleArray = [[NSArray alloc] init];
    NSArray *shareButtonImageNameArray = [[NSArray alloc] init];
    shareButtonTitleArray = @[@"微信好友",@"微信朋友圈"];
    shareButtonImageNameArray = @[@"home_repost_wechat",@"home_repost_friendcirle"];
    
    NSArray *buttons = @[@"举报"];
    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    if ([self.statusM.user.uid integerValue]==[mode.uid integerValue]) {
        buttons = @[@"删除该动态",@"举报"];
    }
    LXActivity *lxActivity = [[LXActivity alloc] initWithDelegate:self WithTitle:@"分享到" otherButtonTitles:buttons ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    [lxActivity showInView:[UIApplication sharedApplication].keyWindow];
    
    
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除该条动态" otherButtonTitles:nil,nil];
//    [sheet setTag:800];
//    [sheet showInView:self.view];
}


#pragma mark - LXActivityDelegate
- (void)didClickOnImageIndex:(NSString *)imageIndex
{
    WLStatusM *statusM = self.statusM;
    NSString *name = [NSString stringWithFormat:@"%@在微链上说",statusM.user.name];
    UIImage *iconImage = self.commentHeadView.cellHeadView.iconImageView.image;
    
    if ([imageIndex isEqualToString:@"删除该动态"]) {
        __weak CommentInfoController *commVC = self;
            [WLHttpTool deleteFeedParameterDic:@{@"fid":@(self.statusM.fid)} success:^(id JSON) {

                [WLHUDView showSuccessHUD:@"删除动态成功！"];

                [commVC backDataStatusFrame:YES];
                [self.navigationController popViewControllerAnimated:YES];
            } fail:^(NSError *error) {
                
            }];

    }else if ([imageIndex isEqualToString:@"举报"]){
        [WLHttpTool complainParameterDic:@{@"fid":@(self.statusM.fid)} success:^(id JSON) {
            [WLHUDView showSuccessHUD:@"举报成功！稍后我们会核查信息"];
        } fail:^(NSError *error) {
            
        }];
        
    }else if ([imageIndex isEqualToString:@"微信好友"]){
        
        [[ShareEngine sharedShareEngine] sendWeChatMessage:name andDescription:statusM.content WithUrl:statusM.shareurl andImage:iconImage WithScene:weChat];
    }else if ([imageIndex isEqualToString:@"微信朋友圈"]){
        [[ShareEngine sharedShareEngine] sendWeChatMessage:name andDescription:statusM.content WithUrl:statusM.shareurl andImage:iconImage WithScene:weChatFriend];
    }
//    WLStatusM *statusM = self.statusFrame.status;
//    if (!self.statusFrame) {
//        statusM = self.commentFrame.status;
//    }
//
//    NSString *name = [NSString stringWithFormat:@"%@在微链上说",statusM.user.name];
//    if (imageIndex == 0) {  // weLian
//
//        PublishStatusController *publishVC = [[PublishStatusController alloc] initWithType:PublishTypeForward];
//        [publishVC setStatus:statusM];
//        [self.homeVC presentViewController:[[NavViewController alloc] initWithRootViewController:publishVC] animated:YES completion:^{
//
//        }];
//
//    }else if (imageIndex == 1){  // 微信好友
//        [[ShareEngine sharedShareEngine] sendWeChatMessage:name andDescription:statusM.content WithUrl:statusM.shareurl andImage:nil WithScene:weChat];
//
//    }else if (imageIndex == 2){  // 微信朋友圈
//        [[ShareEngine sharedShareEngine] sendWeChatMessage:name andDescription:statusM.content WithUrl:statusM.shareurl andImage:nil WithScene:weChatFriend];
//
//    }else if (imageIndex == 3){  // 新浪微博
//
//    }
}



//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (actionSheet.tag==800) {
//        if (buttonIndex==0) {
//            __weak CommentInfoController *commVC = self;
//            [WLHttpTool deleteFeedParameterDic:@{@"fid":@(self.statusM.fid)} success:^(id JSON) {
//                
//                [WLHUDView showSuccessHUD:@"删除动态成功！"];
//                
//                [commVC backDataStatusFrame:YES];
//                [self.navigationController popViewControllerAnimated:YES];
//            } fail:^(NSError *error) {
//                
//            }];
//        }
//        
//    }
//}

- (void)backDataStatusFrame:(BOOL)isdelete
{
    if (isdelete) {
        
        if (self.deleteStustBlock) {
            self.deleteStustBlock(self.statusM);
        }
    }else{
        if (self.feedzanBlock) {
            self.feedzanBlock(self.statusM);
        }
    }
    self.commentHeadView;
}


- (void)forwardCommtion
{
    self.statusM.forwardcount++;
    self.commentHeadView;
    UserInfoModel *usermode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    
    FeedAndZanModel *fzmodel = [[FeedAndZanModel alloc] init];
    [fzmodel setUser:usermode];
    [_feedArrayM insertObject:fzmodel atIndex:0];
    [self refreshDataChangde:nil];
}

- (void)loadnewcommentAndFeedZanAndForward
{
    [self loadNewCommentListData];
    [self loadnewFeedZanAndForward];
}


- (void)loadNewCommentListData
{
    [self.tableView setFooterHidden:YES];
    [self.reqestDic setObject:@(self.statusM.fid) forKey:@"fid"];
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
    return self.commentHFrame.cellHigh;
}
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.commentHeadView;
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
                
                return _feedAndZanFM.cellHigh+5;
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
                return _feedAndZanFM.cellHigh+5;
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
            }
            [cell setCommentVC:self];
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
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
        [sheet setTag:555+0];
        [sheet showInView:self.view];
    }else{
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"回复" otherButtonTitles:nil, nil];
        [sheet setTag:555+1];
        [sheet showInView:self.view];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==555+1) {
        if (buttonIndex==0) {
            [self.messageView startCompile:_selecCommFrame.commentM.user];
        }
        
    }else if(actionSheet.tag==555+0){
        if (buttonIndex==0) {
            [WLHttpTool deleteFeedCommentParameterDic:@{@"fcid":_selecCommFrame.commentM.fcid} success:^(id JSON) {
                [_dataArrayM removeObject:_selecCommFrame];
                self.statusM.commentcount--;
                [self.tableView reloadData];
                self.commentHeadView;
                
                [self backDataStatusFrame:NO];
            } fail:^(NSError *error) {
                
            }];
        }
    }
}


- (void)refreshDataChangde:(WLStatusM *)status
{
    if (status) {
        [_zanArrayM removeAllObjects];
        [_feedArrayM removeAllObjects];
        
        [_zanArrayM addObjectsFromArray:status.zansArray];
        [_feedArrayM addObjectsFromArray:status.forwardsArray];
    }
    if (_zanArrayM.count||_feedArrayM.count) {
        if (!_feedAndZanFM) {
            _feedAndZanFM = [[FeedAndZanFrameM alloc] init];
        }
        [_feedAndZanFM setCellWidth:[UIScreen mainScreen].bounds.size.width];
        [_feedAndZanFM setFeedAndzanDic:@{@"zans":_zanArrayM,@"forwards":_feedArrayM}];
        
    }else{
        _feedAndZanFM = nil;
    }
    
    [self.statusM setZansArray:_zanArrayM];
    [self.statusM setForwardsArray:_feedArrayM];

    [self.tableView reloadData];
    
}


@end
