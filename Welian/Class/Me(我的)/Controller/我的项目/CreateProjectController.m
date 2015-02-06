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
#import "JKPhotoBrowser.h"
#import "CTAssetsPickerController.h"
#import "CollectionViewController.h"

@interface CreateProjectController () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CTAssetsPickerControllerDelegate,UITextViewDelegate>
{
    ALAssetsLibrary *_alassets;
}
// 图片数组
@property (nonatomic, strong) NSMutableArray   *assetsArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CreateProjectFootView *footView;

@end

static NSString *projectcellid = @"projectcellid";
@implementation CreateProjectController

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setSectionHeaderHeight:0.1];
        [_tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        [_tableView setDelegate:self];
    }
    return _tableView;
}

- (CreateProjectFootView *)footView
{
    if (_footView == nil) {
        _footView = [[CreateProjectFootView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, 250)];
        [_footView.titLabel setText:@"项目描述"];
        [_footView.textView setPlaceholder:@"200字之内(选填)"];
        [_footView.textView setDelegate:self];
        [_footView.photBut addTarget:self action:@selector(selectPhotosBut) forControlEvents:UIControlEventTouchUpInside];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setSectionInset:UIEdgeInsetsMake(10, 10, 20, 10)];
        _footView.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_footView.textView.frame), SuperSize.width, self.assetsArray.count*50) collectionViewLayout:layout];
        // 注册cell
        [_footView.collectionView registerClass:[PictureCell class] forCellWithReuseIdentifier:projectcellid];
        
        _footView.collectionView.delegate = self;
        _footView.collectionView.dataSource = self;
        _footView.collectionView.backgroundColor = [UIColor whiteColor];
        [_footView addSubview:_footView.collectionView];
    }
    
    CGRect collfrme = _footView.collectionView.frame;
    collfrme.size.height = self.assetsArray.count*50;
    [_footView.collectionView setFrame:collfrme];
    
    CGRect footFrame = _footView.frame;
    if (self.assetsArray.count) {
        footFrame.size.height = CGRectGetMaxY(_footView.collectionView.frame);
    }else{
        footFrame.size.height = 250;
    }
    [_footView setFrame:footFrame];
    return _footView;
}

#pragma mark - textView代理
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.projectModel setDes:textView.text];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
}

- (instancetype)initIsEdit:(BOOL)isEdit
{
    self = [super init];
    if (self) {
        [self.view addSubview:self.tableView];
        [self.tableView setTableFooterView:self.footView];
//        if (!isEdit) {
//            [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, 90)]];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(addMemberProject)];
//        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"项目简介"];
    [self.footView.textView setText:self.projectModel.des];
    if (!self.projectModel) {
        self.projectModel = [[CreateProjectModel alloc] init];
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
    }
    if (indexPath.section==1&&indexPath.row==1) {
        [cell.textLabel setText:@"项目领域"];
        [cell.textField setPlaceholder:@"请选择（必填）"];
        [cell.textField setText:[self.projectModel.industryName componentsJoinedByString:@","]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        __weak TextFieldCell *weakcell = cell;
        [cell.textField setBk_shouldBeginEditingBlock:^BOOL(UITextField *textField) {
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
            [flowLayout setMinimumLineSpacing:1];
            [flowLayout setMinimumInteritemSpacing:0.5];
            [flowLayout setItemSize:CGSizeMake([MainScreen bounds].size.width/2-0.5, 50)];
            CollectionViewController *invesVC = [[CollectionViewController alloc] initWithCollectionViewLayout:flowLayout withType:1 withData:self.projectModel];
            invesVC.investBlock = ^(NSDictionary *investDic){
                [weakSelf.projectModel setIndustry:[investDic objectForKey:@"id"]];
                [weakSelf.projectModel setIndustryName:[investDic objectForKey:@"name"]];
                [weakcell.textField setText:[weakSelf.projectModel.industryName componentsJoinedByString:@","]];
            };
            [weakSelf.navigationController pushViewController:invesVC animated:YES];
            return NO;
        }];
    }else{
        [cell.textField setBk_shouldBeginEditingBlock:nil];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        if (indexPath.section==0&&indexPath.row==0) {
            [cell.textLabel setText:@"项目名称"];
            [cell.textField setPlaceholder:@"10字之内（必填）"];
            [cell.textField setText:self.projectModel.name];
            [cell.textField setBk_didEndEditingBlock:^(UITextField *textField) {
                [weakSelf.projectModel setName:textField.text];
            }];
        }else if (indexPath.section ==0&&indexPath.row==1){
            [cell.textLabel setText:@"一句话介绍"];
            [cell.textField setPlaceholder:@"50字之内（必填）"];
            [cell.textField setText:self.projectModel.intro];
            [cell.textField setBk_didEndEditingBlock:^(UITextField *textField) {
                [weakSelf.projectModel setIntro:textField.text];
            }];
        }else if (indexPath.section==1&&indexPath.row==0){
            [cell.textLabel setText:@"项目网址"];
            [cell.textField setPlaceholder:@"255字之内（选填）"];
            [cell.textField setText:self.projectModel.website];
            [cell.textField setBk_didEndEditingBlock:^(UITextField *textField) {
                [weakSelf.projectModel setWebsite:textField.text];
            }];
        }
    }
    
    return cell;
}

- (void)selectPhotosBut
{
    UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [sheet bk_addButtonWithTitle:@"拍照" handler:^{
        // 判断相机可以使用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:imagePicker animated:YES completion:^{
            }];
        }else {
            [[[UIAlertView alloc] initWithTitle:nil message:@"摄像头不可用！！！" delegate:self cancelButtonTitle:@"知道了！" otherButtonTitles:nil, nil] show];
            return;
        }
    }];
    [sheet bk_addButtonWithTitle:@"从相册选择" handler:^{
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.assetsFilter         = [ALAssetsFilter allAssets];
        [picker setAssetsLibrary:_alassets];
        picker.delegate             = self;
        picker.selectedAssets       = [NSMutableArray arrayWithArray:self.assetsArray];
        
        [self presentViewController:picker animated:YES completion:nil];
    }];
    [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];

    [sheet showInView:self.view];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSDictionary *metaDic = [info objectForKey:UIImagePickerControllerMediaMetadata];
    
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {

        // 保存图片到相册，调用的相关方法，查看是否保存成功
        [_alassets writeImageToSavedPhotosAlbum:image.CGImage metadata:metaDic completionBlock:^(NSURL *assetURL, NSError *error) {
            [_alassets assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                [self.assetsArray addObject:asset];
                [self.footView.collectionView reloadData];
                [picker dismissViewControllerAnimated:YES completion:^{
                    
                }];
            } failureBlock:^(NSError *error) {
                
            }];
            
        }];
    }
}


#pragma mark - Assets Picker Delegate
- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    self.assetsArray = [NSMutableArray arrayWithArray:assets];
    [self.footView.collectionView reloadData];
    [self.tableView setTableFooterView:self.footView];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldEnableAsset:(ALAsset *)asset
{
    // Enable video clips if they are at least 5s
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
    {
        NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
        return lround(duration) >= 5;
    }
    else
    {
        return YES;
    }
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    if (picker.selectedAssets.count >= 9)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"你最多只能选9张照片"
                                   message:nil
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"我知道了", nil];
        
        [alertView show];
    }
    
    if (!asset.defaultRepresentation)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"Attention"
                                   message:@"Your asset has not yet been downloaded to your device"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
    
    return (picker.selectedAssets.count < 9 && asset.defaultRepresentation != nil);
}


#pragma mark - CollectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.assetsArray.count>0&&self.assetsArray.count<9) {
        return self.assetsArray.count+1;
    }
    return self.assetsArray.count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake((SuperSize.width-50)/3, (SuperSize.width-50)/3);
}


- (PictureCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:projectcellid forIndexPath:indexPath];;
    if (indexPath.row==0) {
        [cell.picImageV setImage:[UIImage imageNamed:@"home_new_upload_picture_add"]];
    }else{
        ALAsset *asset = [self.assetsArray objectAtIndex:indexPath.row-1];
        [cell.picImageV setImage:[UIImage imageWithCGImage:asset.thumbnail]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [self selectPhotosBut];
    }else{
        CTAssetsPageViewController *vc = [[CTAssetsPageViewController alloc] initWithAssets:self.assetsArray picDatablock:^(NSMutableArray *picArray) {
            self.assetsArray = picArray;
            [self.tableView setTableFooterView:self.footView];
            [self.footView.collectionView reloadData];
        }];
        vc.pageIndex = indexPath.row-1;
        
        [self.navigationController pushViewController:vc animated:YES];

    }
}


#pragma mark - 创建项目并 下一步团队成员
- (void)addMemberProject
{
    MemberProjectController *memberVC = [[MemberProjectController alloc] initIsEdit:NO withData:self.projectModel];
    [self.navigationController pushViewController:memberVC animated:YES];
    return;
    [self.view.findFirstResponder resignFirstResponder];
    if (!self.projectModel.name.length) {
        [WLHUDView showErrorHUD:@"请填写项目名称"];
        return;
    }
    if (self.projectModel.name.length>10) {
        [WLHUDView showErrorHUD:@"项目名称最长允许10个字"];
        return;
    }
    if (!self.projectModel.intro.length) {
        [WLHUDView showErrorHUD:@"请填写一句话介绍"];
        return;
    }
    if (self.projectModel.intro.length>50) {
        [WLHUDView showErrorHUD:@"一句话介绍最长允许50个字"];
        return;
    }
    if (!self.projectModel.industry.count) {
        [WLHUDView showErrorHUD:@"请设置项目领域"];
        return;
    }
    if (self.projectModel.website&&self.projectModel.website.length>255) {
        [WLHUDView showErrorHUD:@""];
        return;
    }
    if (self.projectModel.des.length>200) {
        [WLHUDView showErrorHUD:@""];
        return;
    }
    NSMutableDictionary *saveProjectDic = [NSMutableDictionary dictionary];
    if (self.projectModel.pid) {
        [saveProjectDic setObject:self.projectModel.pid forKey:@"pid"];
    }else{
        [saveProjectDic setObject:@(0) forKey:@"pid"];
    }
    [saveProjectDic setObject:self.projectModel.name forKey:@"name"];
    [saveProjectDic setObject:self.projectModel.intro forKey:@"intro"];
    [saveProjectDic setObject:self.projectModel.industry forKey:@"industry"];
    if (self.projectModel.des.length) {
        [saveProjectDic setObject:self.projectModel.des forKey:@"description"];
    }
    if (self.projectModel.website.length) {
        [saveProjectDic setObject:self.projectModel.website forKey:@"website"];
    }
    if (self.projectModel.photos.count) {
        [saveProjectDic setObject:self.projectModel.photos forKey:@"photos"];
    }
    [WLHttpTool createProjectParameterDic:saveProjectDic success:^(id JSON) {
        DLog(@"%@",JSON);
        if (JSON) {
            [self.projectModel setPid:[JSON objectForKey:@"pid"]];
            
        }
    } fail:^(NSError *error) {
        
    }];

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
