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
#import "WLMessageInputView.h"

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

- (BOOL)allowsPanToDismissKeyboard
{
    return YES;
}

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
    WEAKSELF
    _commentHeadView.feezanBlock = ^(WLStatusM *statusM){
        [weakSelf.statusM setZans:statusM.zans];
        [weakSelf backDataStatusFrame:NO];
    };
    _commentHeadView.feedTuiBlock = ^(WLStatusM *statusM){
        [weakSelf.statusM setForwards:statusM.forwards];
        [weakSelf backDataStatusFrame:NO];

    };
    return _commentHeadView;
}

- (void)loadloadOneFeed2
{
    NSNumber *fid = self.statusM.topid;
    if (fid==nil || fid.integerValue ==0) {
        fid = self.statusM.fid;
    }
    [WeLianClient getFeedDetailInfoWithID:fid Success:^(id resultInfo) {
        DLog(@"%@",resultInfo);
        NSNumber *commentCount = self.statusM.commentcount;
        NSArray *commentArray = self.statusM.comments;
        
        self.statusM = [WLStatusM objectWithDict:resultInfo];
        self.statusM.comments = commentArray;
        self.statusM.commentcount = commentCount;
        _zanArrayM = [NSMutableArray arrayWithArray:self.statusM.zans];
        _feedArrayM = [NSMutableArray arrayWithArray:self.statusM.forwards];
        [_feedAndZanFM setFeedAndzanDic:@{@"zans":_zanArrayM,@"forwards":_feedArrayM}];
        [self updataCommentBlock];
        [self.tableView reloadData];
    } Failed:^(NSError *error) {
        
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
    
    _feedArrayM = [NSMutableArray arrayWithArray:self.statusM.forwards];
    _zanArrayM = [NSMutableArray arrayWithArray:self.statusM.zans];
    _feedAndZanFM = [[FeedAndZanFrameM alloc] init];
    [_feedAndZanFM setCellWidth:SuperSize.width];
    [_feedAndZanFM setFeedAndzanDic:@{@"zans":_zanArrayM,@"forwards":_feedArrayM}];
    
    _dataArrayM = [self commentFrameArrayModel:self.statusM.comments];
    self.reqestDic = [NSMutableDictionary dictionary];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadnewcommentAndFeedZanAndForward) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self.refreshControl beginRefreshing];
    [self loadnewcommentAndFeedZanAndForward];
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    self.messageView = [[MessageKeyboardView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height, self.view.frame.size.width, 50) andSuperView:self.view withMessageBlock:^(NSString *comment) {
        
        NSMutableDictionary *reqstDicM = [NSMutableDictionary dictionary];
//        [reqstDicM setObject:weakSelf.statusM.topid forKey:@"fid"];
//        if (weakSelf.statusM.topid==0) {
        [reqstDicM setObject:weakSelf.statusM.fid forKey:@"fid"];
//        }
        [reqstDicM setObject:comment forKey:@"comment"];
        
        if (_selecCommFrame) {
            [reqstDicM setObject:_selecCommFrame.commentM.user.uid forKey:@"touid"];
        }
        [WeLianClient commentFeedWithParams:reqstDicM Success:^(id resultInfo) {
            weakSelf.statusM.commentcount = @(weakSelf.statusM.commentcount.integerValue +1);
            [weakSelf loadNewCommentListData];
        } Failed:^(NSError *error) {
            
        }];
    }];
    self.messageView.textHighBlock = ^(CGFloat textHeigh){
        [weakSelf.tableView setFrame:CGRectMake(0, 0, SuperSize.width, SuperSize.height-textHeigh)];
    };
    
    [self.view addSubview:self.messageView];
    if (_beginEdit) {
        
        [self.messageView.commentTextView becomeFirstResponder];
    }
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreCommentData)];
}


- (void)moreButClick:(UIBarButtonItem*)item
{
    [self.messageView dismissKeyBoard];
    WLStatusM *statusM = self.statusM;
    NSString *name = [NSString stringWithFormat:@"%@在微链上说",statusM.user.name];
    __block UIImage *iconImage = self.commentHeadView.cellHeadView.iconImageView.image;
    
    [self.commentHeadView.cellHeadView.iconImageView sd_setImageWithURL:[NSURL URLWithString:statusM.user.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        iconImage = image;
    }];
    NSString *contStr = statusM.content;
    
    //3 活动，10项目，11 网页
    if (statusM.type.integerValue==3||statusM.type.integerValue==10||statusM.type.integerValue==11) {
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
                [WeLianClient reportFeedWithID:self.statusM.fid Success:^(id resultInfo) {
                     [WLHUDView showSuccessHUD:@"举报成功！稍后我们会核查信息"];
                } Failed:^(NSError *error) {
                    
                }];

            }
                break;
            case ShareTypeDelete:
            {
                [WeLianClient deleteFeedWithID:self.statusM.fid Success:^(id resultInfo) {
                    [WLHUDView showSuccessHUD:@"删除动态成功！"];
                    [weakSelf backDataStatusFrame:YES];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } Failed:^(NSError *error) {
                    
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
    [_feedAndZanFM setFeedAndzanDic:@{@"zans":self.statusM.zans,@"forwards":self.statusM.forwards}];
    self.commentHeadView;
    [self.tableView reloadData];
}

- (void)loadnewcommentAndFeedZanAndForward
{
    [self loadloadOneFeed2];
//    [self loadnewFeedZanAndForward];
    [self loadNewCommentListData];
}


- (void)loadNewCommentListData
{
    [self.tableView.footer setHidden:YES];
    [self.reqestDic setObject:self.statusM.fid forKey:@"fid"];
    [self.reqestDic setObject:@(KCellConut) forKey:@"size"];
    [self.reqestDic setObject:@(1) forKey:@"page"];
    [WeLianClient getFeedCommentListWithParameterDic:self.reqestDic Success:^(id resultInfo) {
        [_dataArrayM removeAllObjects];
        NSArray *datarray = [CommentMode objectsWithInfo:resultInfo];
        [self hiddenRefresh];
        if (!datarray.count) return;
        _dataArrayM = [self commentFrameArrayModel:datarray];
        [self.statusM setComments:datarray];
        [self updataCommentBlock];
        [self.tableView reloadData];
    } Failed:^(NSError *error) {
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - 计算评论cell高度
- (NSMutableArray *)commentFrameArrayModel:(NSArray *)commentArray
{
    NSMutableArray *dataAM = [NSMutableArray arrayWithCapacity:commentArray.count];
    for (CommentMode *commentM in commentArray) {
        CommentCellFrame *commentFrame = [[CommentCellFrame alloc] init];
        [commentFrame setCommentM:commentM];
        
        [dataAM addObject:commentFrame];
    }
    return dataAM;
}


- (void)updataCommentBlock
{
    WEAKSELF
    if (weakSelf.commentBlock) {
        weakSelf.commentBlock(weakSelf.statusM);
    }
}


- (void)loadMoreCommentData
{
    if (_dataArrayM.count<=0)    return;
    [WeLianClient getFeedCommentListWithParameterDic:self.reqestDic Success:^(id resultInfo) {
        NSArray *dataarr = [CommentMode objectsWithInfo:resultInfo];
        [_dataArrayM addObjectsFromArray:[self commentFrameArrayModel:dataarr]];
        [self hiddenRefresh];
        [self.tableView reloadData];
    } Failed:^(NSError *error) {
        [self.refreshControl endRefreshing];
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
    [self.tableView.footer endRefreshing];
    
    if (_dataArrayM.count<KCellConut) {
        [self.tableView.footer setHidden:YES];
    }else{
        NSInteger page = [[self.reqestDic objectForKey:@"page"] integerValue];
        page++;
        [self.reqestDic setObject:@(page) forKey:@"page"];
        [self.tableView.footer setHidden:NO];
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
    if (self.statusM.zans.count||self.statusM.forwards.count) {
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
        if (self.statusM.zans.count||self.statusM.forwards.count) {
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
        if (self.statusM.zans.count ||self.statusM.forwards.count) {
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
    if (self.statusM.zans.count||self.statusM.forwards.count) {
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
    if (self.statusM.zans.count||self.statusM.forwards.count) {
        if (indexPath.row==0) {
            return;
        }
        _selecCommFrame = _dataArrayM[indexPath.row-1];
    }else{
        _selecCommFrame = _dataArrayM[indexPath.row];
    }
    
    LogInUser *mode = [LogInUser getCurrentLoginUser];
    
    if ([_selecCommFrame.commentM.user.uid integerValue]==[mode.uid integerValue]) {
        WEAKSELF
        UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:nil];
        [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
        [sheet bk_setDestructiveButtonWithTitle:@"删除" handler:^{
            [WeLianClient deleteFeedCommentWithID:_selecCommFrame.commentM.fcid Success:^(id resultInfo) {
                [_dataArrayM removeObject:_selecCommFrame];
                NSMutableArray *commentAM = [NSMutableArray arrayWithCapacity:_dataArrayM.count];
                for (CommentCellFrame *comCellF in _dataArrayM) {
                    [commentAM addObject:comCellF.commentM];
                }
                [weakSelf.statusM setComments:commentAM];
                weakSelf.statusM.commentcount = @(weakSelf.statusM.commentcount.integerValue-1);
                [weakSelf updataCommentBlock];
                _selecCommFrame = nil;
                [weakSelf.tableView reloadData];
                weakSelf.commentHeadView;
            } Failed:^(NSError *error) {
                
            }];
            
        }];
        [sheet showInView:self.view];
    }else{
        [self.messageView startCompile:_selecCommFrame.commentM.user];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//- (void)refreshDataChangde:(WLStatusM *)status isYES:(BOOL)isYes
//{
//    if (isYes) {
//        _zanArrayM = [NSMutableArray arrayWithArray:status.zans];
//        _feedArrayM = [NSMutableArray arrayWithArray:status.forwards];
//    }
//    if (_zanArrayM.count||_feedArrayM.count) {
//        if (!_feedAndZanFM) {
//            _feedAndZanFM = [[FeedAndZanFrameM alloc] init];
//        }
//        [_feedAndZanFM setCellWidth:[UIScreen mainScreen].bounds.size.width];
//        [_feedAndZanFM setFeedAndzanDic:@{@"zans":_zanArrayM,@"forwards":_feedArrayM}];
//        
//    }else{
//        _feedAndZanFM = nil;
//    }
//    
//    [self.statusM setZans:_zanArrayM];
//    [self.statusM setForwards:_feedArrayM];
//    
//    [self.tableView reloadData];
//    
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    _selecCommFrame = nil;
}

@end
