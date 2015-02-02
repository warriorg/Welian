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

@interface CreateProjectController () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CTAssetsPickerControllerDelegate>
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
        [_footView.textView setPlaceholder:@"200字之内"];
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
            [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, 90)]];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(addMemberProject)];
//        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"项目简介"];
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
    if (cell==nil) {
        cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell.textField setDelegate:self];
    }
    if (indexPath.section==0&&indexPath.row==0) {
        [cell.textLabel setText:@"项目名称"];
        [cell.textField setPlaceholder:@"10字之内（必填）"];
        
    }else if (indexPath.section ==0&&indexPath.row==1){
        [cell.textLabel setText:@"一句话介绍"];
        [cell.textField setPlaceholder:@"50字之内（必填）"];
    }else if (indexPath.section==1&&indexPath.row==0){
        [cell.textLabel setText:@"项目网址"];
        [cell.textField setPlaceholder:@"255字之内（选填）"];
    }else if (indexPath.section ==1&&indexPath.row==1){
        [cell.textLabel setText:@"项目领域"];
        [cell.textField setPlaceholder:@"请选择（必填）"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.textField setBk_shouldBeginEditingBlock:^BOOL(UITextField *textField) {
            InvestCollectionVC *invesVC = [[InvestCollectionVC alloc] initWithType:1];
            [self.navigationController pushViewController:invesVC animated:YES];
            return NO;
        }];
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



//#pragma mark - 选择图片
//- (void)selectPhotosBut
//{
//    imagePickerController = [[JKImagePickerController alloc] init];
//    imagePickerController.filterType = JKImagePickerControllerFilterTypePhotos;
//    imagePickerController.delegate = self;
//    imagePickerController.showsCancelButton = YES;
//    imagePickerController.allowsMultipleSelection = YES;
//    imagePickerController.minimumNumberOfSelection = 1;
//    imagePickerController.maximumNumberOfSelection = 9;
//    imagePickerController.selectedAssetArray = self.assetsArray;
//    NavViewController *navigationController = [[NavViewController alloc] initWithRootViewController:imagePickerController];
//    [self presentViewController:navigationController animated:YES completion:nil];
//}
//
//#pragma mark - JKImagePickerControllerDelegate
//- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
//{
//    [imagePicker dismissViewControllerAnimated:YES completion:^{
//        
//    }];
//}
//
//- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
//{
//    self.assetsArray = [NSMutableArray arrayWithArray:assets];
//    
//    [imagePicker dismissViewControllerAnimated:YES completion:^{
//        DLog(@"%@",self.assetsArray);
//        [self.footView.collectionView reloadData];
//        [self.tableView setTableFooterView:self.footView];
//
//    }];
//}
//
//- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
//{
//    [imagePicker dismissViewControllerAnimated:YES completion:^{
//        
//    }];
//}


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


#pragma mark - 下一步团队成员
- (void)addMemberProject
{
    MemberProjectController *memberVC = [[MemberProjectController alloc] initIsEdit:NO];
    [self.navigationController pushViewController:memberVC animated:YES];
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
