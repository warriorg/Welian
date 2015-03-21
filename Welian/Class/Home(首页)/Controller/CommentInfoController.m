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
#import "MJExtension.h"
#import "FeedAndZanFrameM.h"
#import "FeedAndZanCell.h"
#import "CommentHeadView.h"
#import "ShareEngine.h"
#import "UIImageView+WebCache.h"
#import "ListItem.h"
#import "WLActivityView.h"
#import "ShareFriendsController.h"
#import "NavViewController.h"
#import "PublishStatusController.h"
#import "CardAlertView.h"

@interface CommentInfoController () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
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
        _commentHFrame = [[CommentHeadFrame alloc] initWithWidth:[UIScreen mainScreen].bounds.size.width-8];
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
    }
    [_commentHeadView setCommHeadFrame:self.commentHFrame];
    __weak CommentInfoController *commin = self;

    _commentHeadView.feezanBlock = ^(WLStatusM *statusM){
        
        [commin backDataStatusFrame:NO];
        [commin refreshDataChangde:statusM isYES:YES];
    };
    _commentHeadView.feedTuiBlock = ^(WLStatusM *statusM){
        if (commin.feedTuiBlock) {
            commin.feedTuiBlock (statusM);
        }
        [commin refreshDataChangde:statusM isYES:YES];
    };
    return _commentHeadView;
}

- (void)loadloadOneFeed2
{
    int fid = self.statusM.topid;
    if (fid==0) {
        fid = self.statusM.fid;
    }
    [WLHttpTool loadOneFeedParameterDic:@{@"fid":@(fid)} success:^(id JSON) {
        NSDictionary *statusDic = JSON;
        [[WLDataDBTool sharedService] putObject:statusDic withId:[NSString stringWithFormat:@"%@",[statusDic objectForKey:@"fid"]] intoTable:KWLStutarDataTableName];

        WLStatusM *loadstatusM = [WLStatusM objectWithKeyValues:statusDic];
        [self.statusM setContent:loadstatusM.content];
        [self.statusM setCommentcount:loadstatusM.commentcount];
        [self.statusM setCreated:statusDic[@"created"]];
        [self.statusM setFid:loadstatusM.fid];
        [self.statusM setForwardcount:loadstatusM.forwardcount];
        [self.statusM setIszan:[statusDic[@"iszan"] intValue]];
        [self.statusM setIsforward:[statusDic[@"isforward"] intValue]];
        [self.statusM setShareurl:loadstatusM.shareurl];
        [self.statusM setType:loadstatusM.type];
        [self.statusM setUser:loadstatusM.user];
        [self.statusM setZan:loadstatusM.zan];
        [self.statusM setPhotos:loadstatusM.photos];
        self.commentHeadView;
        [self refreshDataChangde:self.statusM isYES:NO];
    } fail:^(NSError *error) {
        
    }];
}


// 加载赞和转发数据
- (void)loadnewFeedZanAndForward
{
    int fid = self.statusM.topid;
    if (fid==0) {
        fid = self.statusM.fid;
    }
    [WLHttpTool loadFeedZanAndForwardParameterDic:@{@"fid":@(fid)} success:^(id JSON) {
        
        NSArray *feedarray = [JSON objectForKey:@"forwards"];
        NSArray *zanarray = [JSON objectForKey:@"zans"];

        [_feedArrayM removeAllObjects];
        [_zanArrayM removeAllObjects];
        if (feedarray.count) {
            for (NSDictionary *feeddic in feedarray) {
                UserInfoModel *mode = [UserInfoModel objectWithKeyValues:feeddic];
                [_feedArrayM addObject:mode];
            }
        }
        
        if (zanarray.count) {
            for (NSDictionary *zandic in zanarray) {
                UserInfoModel *mode = [UserInfoModel objectWithKeyValues:zandic];
                [_zanArrayM addObject:mode];
            }
        }
        [self refreshDataChangde:self.statusM isYES:NO];
        
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"详情"];
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

        [reqstDicM setObject:@(self.statusM.topid) forKey:@"fid"];
        if (self.statusM.topid==0) {
        [reqstDicM setObject:@(self.statusM.fid) forKey:@"fid"];
        }
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
    WLStatusM *statusM = self.statusM;
    NSString *name = [NSString stringWithFormat:@"%@在微链上说",statusM.user.name];
    __block UIImage *iconImage = self.commentHeadView.cellHeadView.iconImageView.image;
    
    [self.commentHeadView.cellHeadView.iconImageView sd_setImageWithURL:[NSURL URLWithString:statusM.user.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        iconImage = image;
    }];
    NSString *contStr = statusM.content;
    
    //3 活动，10项目，11 网页
    if (statusM.type==3||statusM.type==10||statusM.type==11) {
        if (statusM.content.length) {
            contStr = [NSString stringWithFormat:@"%@ | %@，%@",statusM.content,statusM.card.title,statusM.card.intro];
        }else{
            contStr = [NSString stringWithFormat:@"%@，%@",statusM.card.title,statusM.card.intro];
        }
    }
    
    NSArray *twoArray = @[@(ShareTypeReport)];
    LogInUser *mode = [LogInUser getCurrentLoginUser];
    if ([self.statusM.user.uid integerValue]==[mode.uid integerValue]) {
        twoArray = @[@(ShareTypeReport),@(ShareTypeDelete)];
    }

    WEAKSELF
    WLActivityView *wlActivity = [[WLActivityView alloc] initWithOneSectionArray:twoArray andTwoArray:@[@(ShareTypeWeixinFriend),@(ShareTypeWeixinCircle)]];
    wlActivity.wlShareBlock = ^(ShareType type){
        switch (type) {
            case ShareTypeWLFriend:
            {
                ShareFriendsController *shareFVC = [[ShareFriendsController alloc] init];
                NavViewController *navShareFVC = [[NavViewController alloc] initWithRootViewController:shareFVC];
                [weakSelf presentViewController:navShareFVC animated:YES completion:^{
                    
                }];
            }
                break;
            case ShareTypeWLCircle:
            {
                PublishStatusController *publishShareVC = [[PublishStatusController alloc] initWithType:PublishTypeForward];
                NavViewController *navShareFVC = [[NavViewController alloc] initWithRootViewController:publishShareVC];
                [weakSelf presentViewController:navShareFVC animated:YES completion:^{
                    
                }];

            }
                break;
            case ShareTypeWeixinFriend:
            {
                [[ShareEngine sharedShareEngine] sendWeChatMessage:name andDescription:contStr WithUrl:statusM.shareurl andImage:iconImage WithScene:weChat];
            }
                break;
            case ShareTypeWeixinCircle:
            {
                [[ShareEngine sharedShareEngine] sendWeChatMessage:contStr andDescription:contStr WithUrl:statusM.shareurl andImage:iconImage WithScene:weChatFriend];
            }
                break;
            case ShareTypeReport:
            {
                [WLHttpTool complainParameterDic:@{@"fid":@(self.statusM.fid)} success:^(id JSON) {
                    [WLHUDView showSuccessHUD:@"举报成功！稍后我们会核查信息"];
                } fail:^(NSError *error) {
                    
                }];
            }
                break;
            case ShareTypeDelete:
            {
                [WLHttpTool deleteFeedParameterDic:@{@"fid":@(self.statusM.fid)} success:^(id JSON) {
                    [WLHUDView showSuccessHUD:@"删除动态成功！"];
                    [weakSelf backDataStatusFrame:YES];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } fail:^(NSError *error) {
                    
                }];
            }
                break;
                
            default:
                break;
        }
        
    };
    [wlActivity show];
}


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

- (void)loadnewcommentAndFeedZanAndForward
{
    [self loadloadOneFeed2];
    [self loadnewFeedZanAndForward];
    [self loadNewCommentListData];
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
        if (!_dataArrayM.count) return;
        NSMutableArray *commentArray = [NSMutableArray array];
        for (CommentCellFrame *cellF in _dataArrayM) {
            
            [commentArray addObject:cellF.commentM];
        }
        [self.statusM setCommentsArray:commentArray];
        [self updataCommentBlock];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [self.refreshControl endRefreshing];
    }];
}

- (void)updataCommentBlock
{
        __weak CommentInfoController *weakSelf = self;
    if (weakSelf.commentBlock) {
        weakSelf.commentBlock(weakSelf.statusM);
    }
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
    [self.messageView startCompile:nil];
    _selecCommFrame = nil;
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
        return a+1;
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
    
    LogInUser *mode = [LogInUser getCurrentLoginUser];
    UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    if ([_selecCommFrame.commentM.user.uid integerValue]==[mode.uid integerValue]) {
        [sheet bk_setDestructiveButtonWithTitle:@"删除" handler:^{
            [WLHttpTool deleteFeedCommentParameterDic:@{@"fcid":_selecCommFrame.commentM.fcid} success:^(id JSON) {
                [_dataArrayM removeObject:_selecCommFrame];
                NSMutableArray *commentAM = [NSMutableArray arrayWithCapacity:_dataArrayM.count];
                for (CommentCellFrame *comCellF in _dataArrayM) {
                    [commentAM addObject:comCellF.commentM];
                }
                [self.statusM setCommentsArray:commentAM];
                self.statusM.commentcount--;
                [self updataCommentBlock];
                _selecCommFrame = nil;
                [self.tableView reloadData];
                
                self.commentHeadView;
                
            } fail:^(NSError *error) {
                
            }];

        }];
        [sheet showInView:self.view];
    }else{
        [sheet bk_addButtonWithTitle:@"回复" handler:^{
            [self.messageView startCompile:_selecCommFrame.commentM.user];
        }];

        [sheet showInView:self.view];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)refreshDataChangde:(WLStatusM *)status isYES:(BOOL)isYes
{
    if (isYes) {
        _zanArrayM = [NSMutableArray arrayWithArray:status.zansArray];
        _feedArrayM = [NSMutableArray arrayWithArray:status.forwardsArray];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

@end
