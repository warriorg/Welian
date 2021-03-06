//
//  CreateProjectController.m
//  Welian
//
//  Created by dong on 15/1/30.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "CreateProjectController.h"
#import "MemberProjectController.h"
#import "TextFieldCell.h"
#import "CreateProjectFootView.h"
#import "InvestCollectionVC.h"
#import "JKImagePickerController.h"
#import "NavViewController.h"
#import "PictureCell.h"
#import "CTAssetsPageViewController.h"
#import "CollectionViewController.h"
#import "MJExtension.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "CreateHeaderView.h"
#import "MJExtension.h"
#import "WLPhotographyHelper.h"

#import "IPhotoUp.h"

@interface CreateProjectController () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate,JKImagePickerControllerDelegate>
{
    BOOL _isEdit;
    ALAssetsLibrary *_alassets;
    IProjectDetailInfo *_projectModel;
    MJPhotoBrowser *_browser;
    NSInteger seleSection;
    NSInteger _row;
}
// 图片数组
@property (nonatomic, strong) NSMutableArray   *assetsArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CreateProjectFootView *footView;
@property (nonatomic, strong) IProjectDetailInfo *projectM;
@property (nonatomic, strong) WLPhotographyHelper *photographyHelper;
@end

static NSString *projectcellid = @"projectcellid";
@implementation CreateProjectController

- (WLPhotographyHelper *)photographyHelper {
    if (!_photographyHelper) {
        _photographyHelper = [[WLPhotographyHelper alloc] init];
    }
    return _photographyHelper;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setSectionHeaderHeight:0.1];
        [_tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        [_tableView setDelegate:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}

- (CreateProjectFootView *)footView
{
    if (_footView == nil) {
        _footView = [[CreateProjectFootView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, 280)];
        [_footView.titLabel setText:@"项目描述"];
        [_footView.textView setDelegate:self];
        [_footView.photBut addTarget:self action:@selector(selectPhotosBut) forControlEvents:UIControlEventTouchUpInside];
        
        // 注册cell
        [_footView.collectionView registerClass:[PictureCell class] forCellWithReuseIdentifier:projectcellid];
        _footView.collectionView.delegate = self;
        _footView.collectionView.dataSource = self;
    }
    NSInteger rowCount = 0;
    
    NSInteger count = _projectModel.photos.count;
    rowCount += (count + 3 - 1) / 3;
    count = self.assetsArray.count;
    rowCount += (count + 3 - 1) / 3;
    [_footView.collectionView setFrame:CGRectMake(0, CGRectGetMaxY(_footView.textView.frame), SuperSize.width, rowCount*(10+(SuperSize.width-50)/3)+20)];
    
    [_footView.photBut setFrame:CGRectMake(15, CGRectGetMaxY(_footView.collectionView.frame)+20, 35, 35)];
    CGRect footFrame = _footView.frame;
    if (_projectModel.photos.count+self.assetsArray.count) {
        footFrame.size.height = CGRectGetMaxY(_footView.photBut.frame)+20;
    }else{
        footFrame.size.height = 280;
    }
    [_footView setFrame:footFrame];
    return _footView;
}

#pragma mark - textView代理
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [_projectModel setDes:textView.text];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self.footView.lentLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)textView.text.length]];
    if (textView.text.length<=200) {
        [self.footView.lentLabel setTextColor:WLRGB(125, 125, 125)];
    }else{
        [self.footView.lentLabel setTextColor:WLRGB(208, 2, 27)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
}

- (instancetype)initIsEdit:(BOOL)isEdit withData:(IProjectDetailInfo *)projectModel
{
    self = [super init];
    if (self) {
        _isEdit = isEdit;
        _projectModel = [[IProjectDetailInfo alloc] init];
        self.projectM = [[IProjectDetailInfo alloc] init];
        if (isEdit) {
            [_projectModel setPid:projectModel.pid];
            [_projectModel setName:projectModel.name];
            [_projectModel setIntro:projectModel.intro];
            [_projectModel setDes:projectModel.des];
            [_projectModel setWebsite:projectModel.website];
            [_projectModel setIndustrys:projectModel.industrys];
            [_projectModel setPhotos:projectModel.photos];
            self.projectM = projectModel;
        }
        [self.view addSubview:self.tableView];
        [self.tableView setTableFooterView:self.footView];
        
        if (isEdit) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(addMemberProject)];
        }else{
            CreateHeaderView *headerV = [[[NSBundle mainBundle]loadNibNamed:@"CreateHeaderView" owner:nil options:nil] firstObject];
            [headerV setFrame:CGRectMake(0, 0, SuperSize.width, 70)];
            [self.tableView setTableHeaderView:headerV];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(addMemberProject)];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"项目简介"];
    self.assetsArray = [NSMutableArray array];
    _alassets = [[ALAssetsLibrary alloc] init];
    if (_projectModel.des.length) {
        [self.footView.textView setPlaceholder:nil];
        [self.footView.textView setText:_projectModel.des];
    }else{
        [self.footView.textView setPlaceholder:@"200字之内"];
    }
    
}


#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    WEAKSELF
    if (cell==nil) {
        cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textField setDelegate:self];
        [cell.textLabel setFont:WLFONT(15)];
    }
    if (indexPath.section==1&&indexPath.row==1) {
        [cell.textLabel setText:@"项目领域"];
        [cell.textField setPlaceholder:@"请选择"];
        [cell.textField setText:[[_projectModel getindustrysName] componentsJoinedByString:@","]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        __weak TextFieldCell *weakcell = cell;
        [cell.textField setBk_shouldBeginEditingBlock:^BOOL(UITextField *textField) {
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
            [flowLayout setMinimumLineSpacing:1];
            [flowLayout setMinimumInteritemSpacing:0.5];
            [flowLayout setItemSize:CGSizeMake([MainScreen bounds].size.width/2-0.5, 50)];
            CollectionViewController *invesVC = [[CollectionViewController alloc] initWithCollectionViewLayout:flowLayout withType:1 withData:_projectModel];
            invesVC.investBlock = ^(NSArray *investDic){
                [_projectModel setIndustrys:investDic];
                [weakcell.textField setText:[[_projectModel getindustrysName] componentsJoinedByString:@","]];
            };
            [weakSelf.navigationController pushViewController:invesVC animated:YES];
            return NO;
        }];
    }else{
        [cell.textField setBk_shouldBeginEditingBlock:nil];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        if (indexPath.section==0&&indexPath.row==0) {
            [cell.textLabel setText:@"项目名称"];
            [cell.textField setPlaceholder:@"10字之内"];
            [cell.textField setText:_projectModel.name];
            [cell.textField setBk_didEndEditingBlock:^(UITextField *textField) {
                [_projectModel setName:textField.text];
            }];
        }else if (indexPath.section ==0&&indexPath.row==1){
            [cell.textLabel setText:@"一句话介绍"];
            [cell.textField setPlaceholder:@"50字之内"];
            [cell.textField setText:_projectModel.intro];
            [cell.textField setBk_didEndEditingBlock:^(UITextField *textField) {
                [_projectModel setIntro:textField.text];
            }];
        }else if (indexPath.section==1&&indexPath.row==0){
            [cell.textLabel setText:@"项目网址"];
            [cell.textField setPlaceholder:nil];
            [cell.textField setText:_projectModel.website];
            [cell.textField setBk_didEndEditingBlock:^(UITextField *textField) {
                [_projectModel setWebsite:textField.text];
            }];
        }
    }
    return cell;
}

- (void)selectPhotosBut
{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.filterType = JKImagePickerControllerFilterTypePhotos;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.selectedAssetArray = self.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    self.assetsArray = [NSMutableArray arrayWithArray:assets];
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        self.assetsArray = [NSMutableArray arrayWithArray:assets];
        [self.footView.collectionView reloadData];
        [self.tableView setTableFooterView:self.footView];
    }];
}

- (void)imagePickerControllerJKDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - CollectionView代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.assetsArray.count&&_projectModel.photos.count) {
        return 2;
    }else if (self.assetsArray.count||_projectModel.photos.count){
        return 1;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0) {
        if (_projectModel.photos.count) {
            return _projectModel.photos.count;
        }else{
            return self.assetsArray.count;
        }
    }else if(section==1){
        return self.assetsArray.count;
    }
    return 0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SuperSize.width-50)/3, (SuperSize.width-50)/3);
}


- (PictureCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:projectcellid forIndexPath:indexPath];;
    if (indexPath.section==0) {
        if (_projectModel.photos.count) {
            IPhotoInfo *photoUrl = _projectModel.photos[indexPath.row];
            [cell.picImageV sd_setImageWithURL:[NSURL URLWithString:photoUrl.photo] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageLowPriority];
        }else{
            JKAssets *jkAssets = [self.assetsArray objectAtIndex:indexPath.row];
            cell.picImageV.image = jkAssets.fullImage;
        }
    }else if(indexPath.section==1){
        JKAssets *jkAssets = [self.assetsArray objectAtIndex:indexPath.row];
        cell.picImageV.image = jkAssets.fullImage;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 2.显示相册
    MJPhoto *photo = [[MJPhoto alloc] init];
//    WEAKSELF
    if (indexPath.section==0) {
        if (_projectModel.photos.count) {
            seleSection = 0;
            IPhotoInfo *photoI = _projectModel.photos[indexPath.row];
            [photo setUrl:[NSURL URLWithString:photoI.photo]];
        }else{
            seleSection = 1;
            JKAssets *jkAssets = [self.assetsArray objectAtIndex:indexPath.row];
            photo.image = jkAssets.fullImage;
        }
    }else if(indexPath.section==1){
        seleSection = 1;
        JKAssets *jkAssets = [self.assetsArray objectAtIndex:indexPath.row];
        photo.image = jkAssets.fullImage;
    }
    _row = indexPath.row;
    [self showPhotoBrowser:photo];
    
}

- (void)showPhotoBrowser:(MJPhoto *)photo
{
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    [browser setIsDelete:YES];
    browser.photos = @[photo]; // 设置所有的图片
    [browser show];
    [browser.toolbar.saveImageBtn addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchUpInside];
    _browser= browser;
}

#pragma mark - 删除图片
- (void)deletePhoto
{
    UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"确定删除？"];
    [alert bk_addButtonWithTitle:@"取消" handler:nil];
    [alert bk_addButtonWithTitle:@"确定" handler:^{
        if (seleSection) {  // 删除本地
            [self.assetsArray removeObjectAtIndex:_row];
            [_browser handleSingleTap];
            [self.tableView setTableFooterView:self.footView];
            [self.footView.collectionView reloadData];

        }else{    // 删除网络
            IPhotoInfo *photoI = _projectModel.photos[_row];
            [WeLianClient deleteProjectPhotoWithPhotoid:photoI.photoid Success:^(id resultInfo) {
                NSMutableArray *photosM = [[NSMutableArray alloc] initWithArray:_projectModel.photos];
                [photosM removeObjectAtIndex:_row];
                [_projectModel setPhotos:photosM];
                [self.projectM setPhotos:photosM];
                // 修改数据库数据
                ProjectDetailInfo *projectMR = [ProjectDetailInfo createWithIProjectDetailInfo:self.projectM];
                [_browser handleSingleTap];
                if (self.projectDataBlock) {
                    self.projectDataBlock(projectMR);
                }
                [self.tableView setTableFooterView:self.footView];
                [self.footView.collectionView reloadData];
            } Failed:^(NSError *error) {
            
            }];
        }
    }];
    [alert show];
}

#pragma mark - 创建项目并 下一步团队成员
- (void)addMemberProject
{
    [self.view.findFirstResponder resignFirstResponder];
    if (!_projectModel.name.length) {
        [WLHUDView showErrorHUD:@"请填写项目名称"];
        return;
    }
    if (_projectModel.name.length>10) {
        [WLHUDView showErrorHUD:@"项目名称最长允许10个字"];
        return;
    }
    if (!_projectModel.intro.length) {
        [WLHUDView showErrorHUD:@"请填写一句话介绍"];
        return;
    }
    if (_projectModel.intro.length>50) {
        [WLHUDView showErrorHUD:@"一句话介绍最长允许50个字"];
        return;
    }
    if (!_projectModel.industrys.count) {
        [WLHUDView showErrorHUD:@"请设置项目领域"];
        return;
    }
    if (_projectModel.website&&_projectModel.website.length>255) {
        [WLHUDView showErrorHUD:@"网址过长，无法录入"];
        return;
    }
    if (_projectModel.des.length>200) {
        [WLHUDView showErrorHUD:@"项目描述内容200字内"];
        return;
    }
    [WLHUDView showHUDWithStr:@"加载中..." dim:NO];
    if (_isEdit) {  // 修改项目
//        if (self.assetsArray.count) {
//            NSMutableArray *photDicArray = [self seleAssetsArray];
//            [WeLianClient saveProjectPhotoWithParameterDic:@{@"pid":_projectModel.pid,@"photos":photDicArray} Success:^(id resultInfo) {
//                NSMutableArray *photoArray = [NSMutableArray arrayWithArray:_projectModel.photos];
//                if ([resultInfo count] > 0) {
//                   [photoArray addObjectsFromArray:resultInfo];
//                   [_projectModel setPhotos:photoArray];
//                   [self.projectM setPhotos:photoArray];
//                   
//                   // 修改数据库数据
//                   [ProjectDetailInfo createWithIProjectDetailInfo:self.projectM];
//                   [self createProjectParameterDic];
//               }
//            } Failed:^(NSError *error) {
//                                                       
//            }];
//        }else{
//            
//        }
        [self createProjectParameterDic];
    }else{   // 新建项目
        // 检测项目是否有同名
        [WeLianClient checkProjectWithName:_projectModel.name Success:^(id resultInfo) {
            [self createProjectParameterDic];
        } Failed:^(NSError *error) {
            if (error) {
               [WLHUDView showErrorHUD:error.localizedDescription];
            }
        }];
        
    }
}

- (void)createProjectParameterDic
{
    NSMutableDictionary *saveProjectDic = [NSMutableDictionary dictionary];
    if (_isEdit) {
        [saveProjectDic setObject:_projectModel.pid forKey:@"pid"];
    }else{
        [saveProjectDic setObject:@(0) forKey:@"pid"];
    }
    [saveProjectDic setObject:_projectModel.name forKey:@"name"];
    [saveProjectDic setObject:_projectModel.intro forKey:@"intro"];
    NSMutableArray *industy = [NSMutableArray array];
    for (IInvestIndustryModel *indusM in _projectModel.industrys) {
        [industy addObject:@{@"industryid":indusM.industryid}];
    }
    [saveProjectDic setObject:industy forKey:@"industrys"];
    
    if (_projectModel.des.length) {
        [saveProjectDic setObject:_projectModel.des forKey:@"description"];
    }
    if (_projectModel.website.length) {
        [saveProjectDic setObject:_projectModel.website forKey:@"website"];
    }
//    if (!_isEdit) {
    if (self.assetsArray.count) {
        NSMutableArray *photArray = [NSMutableArray array];
        for (JKAssets *jkAsset in self.assetsArray) {
            UIImage *image = jkAsset.fullImage;
            NSData *imagedata = UIImageJPEGRepresentation(image, 0.5);
            [photArray addObject:imagedata];
        }
        [[WeLianClient sharedClient] uploadImageWithImageData:photArray Type:@"project" FeedID:nil Success:^(id resultInfo) {
            NSArray *photoUrls = [IPhotoUp objectsWithInfo:resultInfo];
            NSMutableArray *photoMarray = [NSMutableArray array];
            for (IPhotoUp *iphoto in photoUrls) {
                if ([iphoto.type isEqualToString:@"project"]) {
                    [photoMarray addObject:@{@"photo":iphoto.photo}];
                }
            }
            DLog(@"%@",resultInfo);
           [saveProjectDic setObject:photoMarray forKey:@"photos"];
            [self saveProject:saveProjectDic];
        } Failed:^(NSError *error) {
            [WLHUDView hiddenHud];

        }];
    }else{
        [self saveProject:saveProjectDic];
    }
//    }
    
    
    
//    [WLHttpTool createProjectParameterDic:saveProjectDic success:^(id JSON) {
//        if (JSON) {
//            [_projectModel setPid:[JSON objectForKey:@"pid"]];
//            [_projectModel setShareurl:[JSON objectForKey:@"shareurl"]];
//            
//            [self.projectM setPid:_projectModel.pid];
//            [self.projectM setName:_projectModel.name];
//            [self.projectM setIntro:_projectModel.intro];
//            [self.projectM setDes:_projectModel.des];
//            [self.projectM setWebsite:_projectModel.website];
//            [self.projectM setIndustrys:_projectModel.industrys];
//            [self.projectM setShareurl:_projectModel.shareurl];
//            
//            // 创建项目存数据库
//            IProjectInfo *iProjectinfo = [[IProjectInfo alloc] init];
//            [iProjectinfo setPid:_projectModel.pid];
//            [iProjectinfo setName:_projectModel.name];
//            [iProjectinfo setIntro:_projectModel.intro];
//            [iProjectinfo setDes:_projectModel.des];
//            [iProjectinfo setIndustrys:_projectModel.industrys];
//            [ProjectInfo createProjectInfoWith:iProjectinfo withType:@(2)];
//            
//            if (_isEdit) {
//                // 修改数据库数据
//                ProjectDetailInfo *projectMR = [ProjectDetailInfo createWithIProjectDetailInfo:self.projectM];
//                if (self.projectDataBlock) {
//                    self.projectDataBlock(projectMR);
//                }
//                [self.assetsArray removeAllObjects];
//                [self.navigationController popViewControllerAnimated:YES];
//                
//            }else{
//                
//                NSArray *creatPhots = [JSON objectForKey:@"photos"];
//                
//                if (creatPhots.count) {
//                    NSMutableArray *photoArray = [NSMutableArray array];
//                    for (NSDictionary *photoDic in creatPhots) {
//                        IPhotoInfo *photoI = [IPhotoInfo objectWithKeyValues:photoDic];
//                        [photoArray addObject:photoI];
//                    }
//                    [_projectModel setPhotos:photoArray];
//                    [self.projectM setPhotos:photoArray];
//                }
//                
//                IBaseUserM *meUserM = [[IBaseUserM alloc] init];
//                LogInUser *logUser = [LogInUser getCurrentLoginUser];
//                [meUserM setName:logUser.name];
//                [meUserM setUid:logUser.uid];
//                meUserM.friendship = logUser.friendship;
//                meUserM.avatar = logUser.avatar;
//                meUserM.company = logUser.company;
//                meUserM.position = logUser.position;
//                [_projectModel setUser:meUserM];
//                [self.projectM setUser:meUserM];
//                [ProjectDetailInfo createWithIProjectDetailInfo:self.projectM];
//                MemberProjectController *memberVC = [[MemberProjectController alloc] initIsEdit:NO withData:self.projectM];
//                [self.navigationController pushViewController:memberVC animated:YES];
//                [self.assetsArray removeAllObjects];
//                [self.tableView setTableFooterView:self.footView];
//                [self.footView.collectionView reloadData];
//            }
//            //通知刷新个人项目列表
//            [KNSNotification postNotificationName:KRefreshMyProjectNotif object:self];
//        }
//        
//    } fail:^(NSError *error) {
//        
//    }];
    
}

- (void)saveProject:(NSDictionary *)saveProjectDic
{
    [WeLianClient saveProjectWithParameterDic:saveProjectDic
                                      Success:^(id resultInfo) {
                                          DLog(@"%@",resultInfo);
                                          if (resultInfo) {
                                              [_projectModel setPid:[resultInfo objectForKey:@"pid"]];
                                              [_projectModel setShareurl:[resultInfo objectForKey:@"shareurl"]];
                                              
                                              [self.projectM setPid:_projectModel.pid];
                                              [self.projectM setName:_projectModel.name];
                                              [self.projectM setIntro:_projectModel.intro];
                                              [self.projectM setDes:_projectModel.des];
                                              [self.projectM setWebsite:_projectModel.website];
                                              [self.projectM setIndustrys:_projectModel.industrys];
                                              [self.projectM setShareurl:_projectModel.shareurl];
                                              
                                              // 创建项目存数据库
                                              IProjectInfo *iProjectinfo = [[IProjectInfo alloc] init];
                                              [iProjectinfo setPid:_projectModel.pid];
                                              [iProjectinfo setName:_projectModel.name];
                                              [iProjectinfo setIntro:_projectModel.intro];
                                              [iProjectinfo setDes:_projectModel.des];
                                              [iProjectinfo setIndustrys:_projectModel.industrys];
                                              [ProjectInfo createProjectInfoWith:iProjectinfo withType:@(2)];
                                              
                                              NSArray *creatPhots = [resultInfo objectForKey:@"photos"];//[JSON ];
                                              if (creatPhots.count) {
                                                  NSMutableArray *photoArray = [NSMutableArray arrayWithArray:_projectModel.photos];
                                                  for (NSDictionary *photoDic in creatPhots) {
                                                      IPhotoInfo *photoI = [IPhotoInfo objectWithKeyValues:photoDic];
                                                      [photoArray addObject:photoI];
                                                  }
                                                  [_projectModel setPhotos:photoArray];
                                                  [self.projectM setPhotos:photoArray];
                                              }
                                              
                                              [self.assetsArray removeAllObjects];
                                              [WLHUDView hiddenHud];
                                              if (_isEdit) {
                                                  // 修改数据库数据
                                                  ProjectDetailInfo *projectMR = [ProjectDetailInfo createWithIProjectDetailInfo:self.projectM];
                                                  if (self.projectDataBlock) {
                                                      self.projectDataBlock(projectMR);
                                                  }
                                                  
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  
                                              }else{
                                                  _isEdit = NO;
                                                  
                                                  IBaseUserM *meUserM = [IBaseUserM getLoginUserBaseInfo];
                                                  [_projectModel setUser:meUserM];
                                                  [self.projectM setUser:meUserM];
                                                  [ProjectDetailInfo createWithIProjectDetailInfo:self.projectM];
                                                  
                                                  [self.footView.collectionView reloadData];
                                                  [self.tableView setTableFooterView:self.footView];
                                                  
                                                  MemberProjectController *memberVC = [[MemberProjectController alloc] initIsEdit:NO withData:self.projectM];
                                                  [self.navigationController pushViewController:memberVC animated:YES];
                                                  
                                              }
                                              //通知刷新个人项目列表
                                              [KNSNotification postNotificationName:KRefreshMyProjectNotif object:self];
                                          }
                                      } Failed:^(NSError *error) {
                                        [WLHUDView hiddenHud];
                                      }];

}

- (NSMutableArray *)seleAssetsArray
{
    NSMutableArray *photArray = [NSMutableArray array];
    for (JKAssets *jkAsset in self.assetsArray) {
        UIImage *image = jkAsset.fullImage;
        NSData *imagedata = UIImageJPEGRepresentation(image, 0.5);
//        NSString *imageStr = [imagedata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [photArray addObject:imagedata];
    }
    [[WeLianClient sharedClient] uploadImageWithImageData:photArray Type:@"project" FeedID:nil Success:^(id resultInfo) {
        
    } Failed:^(NSError *error) {
        
    }];
    return photArray;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
