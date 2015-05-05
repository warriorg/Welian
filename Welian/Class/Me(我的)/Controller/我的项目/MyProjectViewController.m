//
//  MyProjectViewController.m
//  Welian
//
//  Created by dong on 15/1/30.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "MyProjectViewController.h"
#import "HMSegmentedControl.h"
#import "CreateProjectController.h"
#import "ProjectViewCell.h"
#import "ProjectDetailsViewController.h"
#import "MJRefresh.h"
#import "NotstringView.h"

#define kSegementHeight 50.f

@interface MyProjectViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _pageIndex;
    NSMutableDictionary *_getProjectDic;
    NSNumber *_uid;
}
@property (nonatomic, strong) NSMutableArray *collectDataArray;
@property (nonatomic, strong) NSMutableArray *createDataArray;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NotstringView *notstrView;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation MyProjectViewController

- (void)dealloc
{
    [KNSNotification removeObserver:self];
}

- (NotstringView *)notstrView
{
    if (!_notstrView) {
        _notstrView = [[NotstringView alloc] initWithFrame:self.tableView.frame withTitleStr:@"暂无项目"];
        [self.tableView addSubview:_notstrView];
        [_notstrView setHidden:YES];
    }
    return _notstrView;
}


- (HMSegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, ViewCtrlTopBarHeight, SuperSize.width, kSegementHeight)];
        _segmentedControl.sectionTitles = @[@"我收藏的", @"我创建的"];
        _segmentedControl.selectedTextColor = KBasesColor;
        [_segmentedControl setTextColor:kTitleNormalTextColor];
        _segmentedControl.selectionIndicatorColor = KBasesColor;
        _segmentedControl.selectionIndicatorHeight = 2;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        UIView *lieView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SuperSize.width, 0.5)];
        [lieView setBackgroundColor:[UIColor lightGrayColor]];
        [_segmentedControl addSubview:lieView];
    }
    return _segmentedControl;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGFloat Xh = kSegementHeight + ViewCtrlTopBarHeight;
        if (_uid) {
            Xh = 0;
        }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Xh, SuperSize.width, SuperSize.height-Xh)];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(refreshdata) forControlEvents:UIControlEventValueChanged];
        [_tableView addSubview:_refreshControl];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshdata];
}

- (instancetype)initWithUid:(NSNumber *)uid
{
   self = [super init];
    if (self) {
        _uid = uid;
        if (uid) {
            [self.segmentedControl setSelectedSegmentIndex:1];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //监听项目刷新
    [KNSNotification addObserver:self selector:@selector(refreshdata) name:KRefreshMyProjectNotif object:nil];
    
    _getProjectDic = [NSMutableDictionary dictionary];
    _selectIndex = 1;
    _pageIndex = 1;
    if (!_uid) {
        _selectIndex = 0;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建项目" style:UIBarButtonItemStyleBordered target:self action:@selector(createNewProject)];
        [self.view addSubview:self.segmentedControl];
        __weak MyProjectViewController *weakVC = self;
        [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
            [weakVC.tableView reloadData];
            [weakVC refreshdata];
            weakVC.selectIndex = index;
            if (index == 0) {
                [weakVC.notstrView setHidden:[ProjectInfo allMyProjectInfoWithType:@(1)].count];
                [weakVC.tableView reloadData];
            }else if (index == 1){
                [weakVC.notstrView setHidden:[ProjectInfo allMyProjectInfoWithType:@(2)].count];
            }
        }];
    }
    
    [self.view addSubview:self.tableView];
   
    //上提加载更多
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(laodMoreData)];
    // 隐藏当前的上拉刷新控件
    self.tableView.footer.hidden = YES;
}

#pragma mark - 刷新数据
- (void)refreshdata
{
    [self.refreshControl beginRefreshing];
    _pageIndex = 1;
//    [_getProjectDic removeAllObjects];
//    [_getProjectDic setObject:@(_pageIndex) forKey:@"page"];
//    [_getProjectDic setObject:@(KCellConut) forKey:@"size"];

    if (self.segmentedControl.selectedSegmentIndex==0) {
        [WeLianClient getProjectFavoriteListWithPage:@(_pageIndex)
                                                Size:@(KCellConut)
                                             Success:^(id resultInfo) {
                                                 [self.refreshControl endRefreshing];
                                                 [self.tableView.footer endRefreshing];
                                                 
                                                 if (self.segmentedControl.selectedSegmentIndex==self.selectIndex) {
                                                     NSArray *projects = resultInfo;
                                                     if (!_uid) {
                                                         [ProjectInfo deleteAllProjectInfoWithType:@(1)];
                                                         for (IProjectInfo *projectM in projects) {
                                                             [ProjectInfo createProjectInfoWith:projectM withType:@(1)];
                                                         }
                                                         [self.notstrView setHidden:[ProjectInfo allMyProjectInfoWithType:@(1)].count];
                                                     }else{
                                                         [self.notstrView setHidden:projects.count];
                                                     }
                                                     [self.collectDataArray removeAllObjects];
                                                     self.collectDataArray = nil;
                                                     self.collectDataArray = [NSMutableArray arrayWithArray:projects];
                                                     [self.tableView reloadData];
                                                     if (projects.count != KCellConut) {
                                                         self.tableView.footer.hidden = YES;
                                                     }else{
                                                         self.tableView.footer.hidden = NO;
                                                         _pageIndex++;
                                                     }
                                                 }
                                             } Failed:^(NSError *error) {
                                                 [self.refreshControl endRefreshing];
                                                 [self.tableView.footer endRefreshing];
                                             }];
        
        // -1 取自己，0 取推荐的项目，大于0取id为uid的用户
//        [WLHttpTool getFavoriteProjectsParameterDic:_getProjectDic success:^(id JSON) {
//            [self.refreshControl endRefreshing];
//            [self.tableView.footer endRefreshing];
//            if (self.segmentedControl.selectedSegmentIndex==self.selectIndex) {
//                NSArray *projects = [IProjectInfo objectsWithInfo:JSON];
//                if (!_uid) {
//                    [ProjectInfo deleteAllProjectInfoWithType:@(1)];
//                    for (IProjectInfo *projectM in projects) {
//                        [ProjectInfo createProjectInfoWith:projectM withType:@(1)];
//                    }
//                    [self.notstrView setHidden:[ProjectInfo allMyProjectInfoWithType:@(1)].count];
//                }else{
//                    [self.notstrView setHidden:projects.count];
//                }
//                [self.collectDataArray removeAllObjects];
//                self.collectDataArray = nil;
//                self.collectDataArray = [NSMutableArray arrayWithArray:projects];
//                [self.tableView reloadData];
//                if (projects.count != KCellConut) {
//                    self.tableView.footer.hidden = YES;
//                }else{
//                    self.tableView.footer.hidden = NO;
//                    _pageIndex++;
//                }
//            }
//
//        } fail:^(NSError *error) {
//            [self.refreshControl endRefreshing];
//            [self.tableView.footer endRefreshing];
//        }];
    }else if (self.segmentedControl.selectedSegmentIndex ==1){
        if (_uid) {
            [_getProjectDic setObject:_uid forKey:@"uid"];
        }else{
           [_getProjectDic setObject:@(-1) forKey:@"uid"];
        }
        
        //大于零取某个用户的，-1取自己的，不传或者0取全部推荐的项目
        [WeLianClient getProjectListWithUid:_uid?_uid:@(-1)
                                       Page:@(_pageIndex)
                                       Size:@(KCellConut)
                                    Success:^(id resultInfo) {
                                        [self.refreshControl endRefreshing];
                                        [self.tableView.footer endRefreshing];
                                        if (self.segmentedControl.selectedSegmentIndex==self.selectIndex) {
                                            NSArray *projects = resultInfo;
                                            if (!_uid) {
                                                [ProjectInfo deleteAllProjectInfoWithType:@(2)];
                                                for (IProjectInfo *projectM in projects) {
                                                    [ProjectInfo createProjectInfoWith:projectM withType:@(2)];
                                                }
                                                [self.notstrView setHidden:[ProjectInfo allMyProjectInfoWithType:@(2)].count];
                                            }else {
                                                [self.notstrView setHidden:projects.count];
                                            }
                                            [self.createDataArray removeAllObjects];
                                            self.createDataArray = nil;
                                            self.createDataArray = [NSMutableArray arrayWithArray:projects];
                                            [self.tableView reloadData];
                                            if (projects.count != KCellConut) {
                                                self.tableView.footer.hidden = YES;
                                            }else{
                                                self.tableView.footer.hidden = NO;
                                                _pageIndex++;
                                            }
                                        }
                                    } Failed:^(NSError *error) {
                                        [self.tableView.header endRefreshing];
                                        [self.tableView.footer endRefreshing];
                                        
                                    }];
       
        // -1 取自己，0 取推荐的项目，大于0取id为uid的用户
//        [WLHttpTool getProjectsParameterDic:_getProjectDic success:^(id JSON) {
//            [self.refreshControl endRefreshing];
//            [self.tableView.footer endRefreshing];
//            if (self.segmentedControl.selectedSegmentIndex==self.selectIndex) {
//                NSArray *projects = [IProjectInfo objectsWithInfo:JSON];
//                if (!_uid) {
//                    [ProjectInfo deleteAllProjectInfoWithType:@(2)];
//                    for (IProjectInfo *projectM in projects) {
//                        [ProjectInfo createProjectInfoWith:projectM withType:@(2)];
//                    }
//                    [self.notstrView setHidden:[ProjectInfo allMyProjectInfoWithType:@(2)].count];
//                }else {
//                    [self.notstrView setHidden:projects.count];
//                }
//                [self.createDataArray removeAllObjects];
//                self.createDataArray = nil;
//                self.createDataArray = [NSMutableArray arrayWithArray:projects];
//                [self.tableView reloadData];
//                if (projects.count != KCellConut) {
//                    self.tableView.footer.hidden = YES;
//                }else{
//                    self.tableView.footer.hidden = NO;
//                    _pageIndex++;
//                }
//            }
//        } fail:^(NSError *error) {
//            [self.refreshControl endRefreshing];
//            [self.tableView.footer endRefreshing];
//        }];
    }
    
    
}

#pragma mark - 上拉加载更多
- (void)laodMoreData
{
//    [_getProjectDic removeAllObjects];
//    [_getProjectDic setObject:@(_pageIndex) forKey:@"page"];
//    [_getProjectDic setObject:@(KCellConut) forKey:@"size"];
    
    if (self.segmentedControl.selectedSegmentIndex==0) {
//        if (_uid) {
//            [_getProjectDic setObject:_uid forKey:@"uid"];
//        }
        
        [WeLianClient getProjectFavoriteListWithPage:@(_pageIndex)
                                                Size:@(KCellConut)
                                             Success:^(id resultInfo) {
                                                 [self.refreshControl endRefreshing];
                                                 [self.tableView.footer endRefreshing];
                                                 if (self.segmentedControl.selectedSegmentIndex==self.selectIndex) {
                                                     if ([resultInfo count] > 0) {
                                                         NSArray *projects = resultInfo;
                                                         if (!_uid) {
                                                             for (IProjectInfo *projectM in projects) {
                                                                 [ProjectInfo createProjectInfoWith:projectM withType:@(1)];
                                                             }
                                                         }
                                                         [self.collectDataArray addObjectsFromArray:projects];
                                                         [self.tableView reloadData];
                                                         if (projects.count != KCellConut) {
                                                             self.tableView.footer.hidden = YES;
                                                         }else{
                                                             self.tableView.footer.hidden = NO;
                                                             _pageIndex++;
                                                         }
                                                     }
                                                 }
                                             } Failed:^(NSError *error) {
                                                 [self.refreshControl endRefreshing];
                                                 [self.tableView.footer endRefreshing];
                                             }];
        
//        [WLHttpTool getFavoriteProjectsParameterDic:_getProjectDic success:^(id JSON) {
//            [self.refreshControl endRefreshing];
//            [self.tableView.footer endRefreshing];
//            if (self.segmentedControl.selectedSegmentIndex==self.selectIndex) {
//                if (JSON) {
//                    NSArray *projects = [IProjectInfo objectsWithInfo:JSON];
//                    if (!_uid) {
//                        for (IProjectInfo *projectM in projects) {
//                            [ProjectInfo createProjectInfoWith:projectM withType:@(1)];
//                        }
//                    }
//                    [self.collectDataArray addObjectsFromArray:projects];
//                    [self.tableView reloadData];
//                    if (projects.count != KCellConut) {
//                        self.tableView.footer.hidden = YES;
//                    }else{
//                        self.tableView.footer.hidden = NO;
//                        _pageIndex++;
//                    }
//                }
//            }
//        } fail:^(NSError *error) {
//            [self.refreshControl endRefreshing];
//            [self.tableView.footer endRefreshing];
//        }];
    }else if (self.segmentedControl.selectedSegmentIndex ==1){
        
        //大于零取某个用户的，-1取自己的，不传或者0取全部推荐的项目
        [WeLianClient getProjectListWithUid:@(-1)
                                       Page:@(_pageIndex)
                                       Size:@(KCellConut)
                                    Success:^(id resultInfo) {
                                        [self.refreshControl endRefreshing];
                                        [self.tableView.footer endRefreshing];
                                        if (self.segmentedControl.selectedSegmentIndex==self.selectIndex) {
                                            if ([resultInfo count] > 0) {
                                                NSArray *projects = resultInfo;
                                                if (!_uid) {
                                                    for (IProjectInfo *projectM in projects) {
                                                        [ProjectInfo createProjectInfoWith:projectM withType:@(2)];
                                                    }
                                                }
                                                [self.createDataArray addObjectsFromArray:projects];
                                                [self.tableView reloadData];
                                                if (projects.count != KCellConut) {
                                                    self.tableView.footer.hidden = YES;
                                                }else{
                                                    self.tableView.footer.hidden = NO;
                                                    _pageIndex++;
                                                }
                                            }
                                        }
                                    } Failed:^(NSError *error) {
                                        [self.tableView.header endRefreshing];
                                        [self.tableView.footer endRefreshing];
                                        
                                    }];
        
//        [_getProjectDic setObject:@(-1) forKey:@"uid"];
//        // -1 取自己，0 取推荐的项目，大于0取id为uid的用户
//        [WLHttpTool getProjectsParameterDic:_getProjectDic success:^(id JSON) {
//            [self.refreshControl endRefreshing];
//            [self.tableView.footer endRefreshing];
//            if (self.segmentedControl.selectedSegmentIndex==self.selectIndex) {
//                if (JSON) {
//                    NSArray *projects = [IProjectInfo objectsWithInfo:JSON];
//                    if (!_uid) {
//                        for (IProjectInfo *projectM in projects) {
//                            [ProjectInfo createProjectInfoWith:projectM withType:@(2)];
//                        }
//                    }
//                    [self.createDataArray addObjectsFromArray:projects];
//                    [self.tableView reloadData];
//                    if (projects.count != KCellConut) {
//                        self.tableView.footer.hidden = YES;
//                    }else{
//                        self.tableView.footer.hidden = NO;
//                        _pageIndex++;
//                    }
//                }
//            }
//        } fail:^(NSError *error) {
//            [self.refreshControl endRefreshing];
//            [self.tableView.footer endRefreshing];
//        }];
    }
    
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segmentedControl.selectedSegmentIndex ==0) {
        if (_uid) {
            return self.collectDataArray.count;
        }else{
            return [[ProjectInfo allMyProjectInfoWithType:@(1)] count];
        }
    }else if (self.segmentedControl.selectedSegmentIndex==1){
        if (_uid) {
            return self.createDataArray.count;
        }else{
            return [[ProjectInfo allMyProjectInfoWithType:@(2)] count];
        }
    }
    return 0;
}

- (ProjectViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Project_List_Cell";
    ProjectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ProjectViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.segmentedControl.selectedSegmentIndex==0) {
        if (_uid) {
            cell.iProjectInfo = self.collectDataArray[indexPath.row];
        }else{
            cell.projectInfo = [ProjectInfo allMyProjectInfoWithType:@(1)][indexPath.row];
        }
    }else if (self.segmentedControl.selectedSegmentIndex==1){
        if (_uid) {
            cell.iProjectInfo = self.createDataArray[indexPath.row];
        }else{
            cell.projectInfo = [ProjectInfo allMyProjectInfoWithType:@(2)][indexPath.row];
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_uid) {
        IProjectInfo *projectInfo = nil;
        if (self.segmentedControl.selectedSegmentIndex==0) {
            projectInfo = self.collectDataArray[indexPath.row];
        }else if (self.segmentedControl.selectedSegmentIndex==1){
            projectInfo = self.createDataArray[indexPath.row];
        }
        if (projectInfo) {
            ProjectDetailsViewController *projectDetailVC = [[ProjectDetailsViewController alloc] initWithProjectPid:projectInfo.pid];
            [self.navigationController pushViewController:projectDetailVC animated:YES];
        }
    }else{
        
        ProjectInfo *projectInfo = nil;
        if (self.segmentedControl.selectedSegmentIndex==0) {
            projectInfo = [ProjectInfo allMyProjectInfoWithType:@(1)][indexPath.row];
        }else if (self.segmentedControl.selectedSegmentIndex==1){
            projectInfo = [ProjectInfo allMyProjectInfoWithType:@(2)][indexPath.row];
        }
        if (projectInfo) {
            ProjectDetailsViewController *projectDetailVC = [[ProjectDetailsViewController alloc] initWithProjectInfo:projectInfo];
            [self.navigationController pushViewController:projectDetailVC animated:YES];
        }
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_uid == nil && _selectIndex == 1) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIAlertView bk_showAlertViewWithTitle:@""
                                   message:@"确认删除当前项目？"
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@[@"删除"]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                       if (buttonIndex == 0) {
                                           return ;
                                       }else{
                                           //删除项目
                                           [self deleteProjectWith:indexPath];
                                       }
                                   }];
//    if (self.segmentedControl.selectedSegmentIndex==0) {
//        IProjectInfo *projectInfo = self.collectDataArray[indexPath.row];
//        [WLHttpTool deleteFavoriteProjectParameterDic:@{@"pid":projectInfo.pid} success:^(id JSON) {
//            
//        } fail:^(NSError *error) {
//            
//        }];
//    }else if (self.segmentedControl.selectedSegmentIndex==1){
//        
//    }
}

//删除项目
- (void)deleteProjectWith:(NSIndexPath *)indexPath
{
    IProjectInfo *projectInfo = _createDataArray[indexPath.row];
    [WLHUDView showHUDWithStr:@"删除中..." dim:NO];
    [WeLianClient deleteProjectWithPid:projectInfo.pid
                               Success:^(id resultInfo) {
                                   [WLHUDView hiddenHud];
                                   
                                   //删除当前项目
                                   [ProjectInfo deleteProjectInfoWithType:@(2) Pid:projectInfo.pid];
                                   [self.createDataArray removeObjectAtIndex:indexPath.row];
                                   [_tableView reloadData];
                                   //检测是否提醒
                                   [self checkHasData];
                               } Failed:^(NSError *error) {
                                   if (error) {
                                       [WLHUDView showErrorHUD:error.description];
                                   }else{
                                       [WLHUDView showErrorHUD:@"删除项目失败，请重试!"];
                                   }
                               }];
    
//    [WLHttpTool deleteProjectParameterDic:@{@"pid":projectInfo.pid}
//                                  success:^(id JSON) {
//                                      //删除当前项目
//                                      [ProjectInfo deleteProjectInfoWithType:@(2) Pid:projectInfo.pid];
//                                      [self.createDataArray removeObjectAtIndex:indexPath.row];
//                                      [_tableView reloadData];
//                                      //检测是否提醒
//                                      [self checkHasData];
//                                  } fail:^(NSError *error) {
//                                      [WLHUDView showErrorHUD:error.description];
//                                  }];
}

//检测是否显示提醒
- (void)checkHasData
{
    if (_uid == nil && _selectIndex == 1) {
         [self.notstrView setHidden:_createDataArray.count];
    }else {
        [self.notstrView setHidden:_collectDataArray.count];
    }
}

#pragma mark - 创建新项目
- (void)createNewProject
{
    CreateProjectController *createProjectVC = [[CreateProjectController alloc] initIsEdit:NO withData:nil];
    [self.navigationController pushViewController:createProjectVC animated:YES];
}

@end
