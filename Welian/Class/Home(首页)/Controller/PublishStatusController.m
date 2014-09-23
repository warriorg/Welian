//
//  PublishStatusController.m
//  Welian
//
//  Created by dong on 14-9-12.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "PublishStatusController.h"
#import "CTAssetsPageViewController.h"
#import "CTAssetsPickerController.h"
#import "PictureCell.h"
#import "MyLocationController.h"
#import "FriendsController.h"
#import "PublishModel.h"

static NSString *picCellid = @"PicCellID";

@interface PublishStatusController () <UITextViewDelegate,CTAssetsPickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UIView *inputttView;
@property (nonatomic, copy) NSArray *assets;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UICollectionView *collectionView;


@property (nonatomic, strong) NSArray *friendArray;
@property (nonatomic, strong) PublishModel *publishM;

@end

@implementation PublishStatusController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.publishM = [[PublishModel alloc] init];
    [self setUiItems];
    [self addUIView];
}

- (void)setUiItems
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem setTitle:@"发布动态"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleBordered target:self action:@selector(confirmPublish)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPublish)];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    //    self.backGScroll = [[UIScrollView alloc] initWithFrame:self.view.frame];
    //    [self.view addSubview:self.backGScroll];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillShowKeyboard:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillHideKeyboard:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}


- (void)addUIView {
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, 250)];
    [self.textView setBaseWritingDirection:UITextWritingDirectionLeftToRight forRange:nil];
    [self.textView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.textView setFont:[UIFont systemFontOfSize:23]];
    [self.textView setDelegate:self];
    //    [self.textView setInputAccessoryView:self.inputttView];
    //    [self.textView setBackgroundColor:[UIColor orangeColor]];
    [self.textView setReturnKeyType:UIReturnKeyDone];
    [self.view addSubview:self.textView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setSectionInset:UIEdgeInsetsMake(10, 15, 10, 15)];
    [layout setMinimumLineSpacing:10.0];
    //    [layout setHeaderReferenceSize:CGSizeMake(self.view.bounds.size.width, 34)];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textView.frame)+10, self.view.bounds.size.width, self.view.bounds.size.height-CGRectGetMaxY(self.textView.frame)-INPUT_HEIGHT-10) collectionViewLayout:layout];
    //    [self.collectionView setContentInset:UIEdgeInsetsMake(120, 0, 0, 0)];
    // 注册cell
    [self.collectionView registerClass:[PictureCell class] forCellWithReuseIdentifier:picCellid];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    
    
    self.inputttView = [[UIView alloc]initWithFrame:CGRectMake(0, SuperSize.height-INPUT_HEIGHT, SuperSize.width, INPUT_HEIGHT)];
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 40, 40)];
    [but setBackgroundColor:[UIColor redColor]];
    [but addTarget:self action:@selector(showPicVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputttView addSubview:but];
    UIButton *addLocation = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    [addLocation setTitle:@"添加位置" forState:UIControlStateNormal];
    [addLocation setBackgroundColor:[UIColor blueColor]];
    [addLocation.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [addLocation addTarget:self action:@selector(addUserLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputttView addSubview:addLocation];
    
    UIButton *together = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 100, 30)];
    [together setTitle:@"" forState:UIControlStateNormal];
    [together setBackgroundColor:[UIColor blueColor]];
    [together.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [together addTarget:self action:@selector(getTogether:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputttView addSubview:together];
    
    [self.inputttView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:self.inputttView];
}


#pragma mark - CollectionView代理

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.assets.count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((self.view.bounds.size.width-60)/4 , (self.view.bounds.size.width-60)/4);
    return size;
}


- (PictureCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:picCellid forIndexPath:indexPath];;
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    //    cell.textLabel.text = [self.dateFormatter stringFromDate:[asset valueForProperty:ALAssetPropertyDate]];
    //    cell.detailTextLabel.text = [asset valueForProperty:ALAssetPropertyType];
    
    //    cell.picImageV.image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage
    //                                               scale:1.0
    //                                         orientation:UIImageOrientationUp];
    //    [cell.picImageV setContentMode:UIViewContentModeScaleToFill];
    [cell.picImageV setImage:[UIImage imageWithCGImage:asset.thumbnail]];
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CTAssetsPageViewController *vc = [[CTAssetsPageViewController alloc] initWithAssets:self.assets picDatablock:^(NSArray *picArray) {
        if (picArray.count || self.textView.text.length) {
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
        }
        self.assets = picArray;
        [self.collectionView reloadData];
    }];
    vc.pageIndex = indexPath.row;
    
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)showPicVC:(UIButton*)but
{
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.assetsFilter         = [ALAssetsFilter allAssets];
    //    picker.showsCancelButton    = NO;
    picker.delegate             = self;
    picker.selectedAssets       = [NSMutableArray arrayWithArray:self.assets];
    
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length || self.assets.count) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {//按下return键
        //这里隐藏键盘，不做任何处理
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
        
        CGRect inputViewFrame = self.inputttView.frame;
        CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
        
        // for ipad modal form presentations
        CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
        if(inputViewFrameY > messageViewFrameBottom)
            inputViewFrameY = messageViewFrameBottom;
        
        self.inputttView.frame = CGRectMake(inputViewFrame.origin.x,
                                            inputViewFrameY,
                                            inputViewFrame.size.width,
                                            inputViewFrame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Assets Picker Delegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    if (assets.count || self.textView.text.length) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    self.assets = assets;
    //    [self reloadCollectionView];
    [self.collectionView reloadData];
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

#pragma mark - 添加位置
- (void)addUserLocation:(UIButton*)but
{
    MyLocationController *myLocationVC = [[MyLocationController alloc] initWithLocationBlock:^(BMKPoiInfo *infoPoi) {
        [but setTitle:infoPoi.name forState:UIControlStateNormal];
        [but sizeToFit];
        
        [self.publishM setAddress:infoPoi.name];
        [self.publishM setX:[NSString stringWithFormat:@"%f",infoPoi.pt.latitude]];
        [self.publishM setY:[NSString stringWithFormat:@"%f",infoPoi.pt.longitude]];
        
    }];
    [self.navigationController pushViewController:myLocationVC animated:YES];
}

#pragma mark - 和谁在一起
- (void)getTogether:(UIButton *)button
{
    FriendsController *frienVC = [[FriendsController alloc] initWithFrienBlock:^(NSMutableArray *frienArray) {
        DLog(@"%@",frienArray);
        self.friendArray = frienArray;
    }];
    [self.navigationController pushViewController:frienVC animated:YES];
}


#pragma mark - 确认发布
- (void)confirmPublish
{
    [self.publishM setContent:self.textView.text];
    self.publishM.with = [NSMutableArray array];
    self.publishM.photos = [NSMutableArray array];
    NSMutableDictionary *reqDataDic = [NSMutableDictionary dictionary];
    if (self.publishM.content) {
        [reqDataDic setObject:self.publishM.content forKey:@"content"];
    }
    if (self.publishM.address) {
        [reqDataDic setObject:self.publishM.address forKey:@"address"];
        [reqDataDic setObject:self.publishM.x forKey:@"x"];
        [reqDataDic setObject:self.publishM.y forKey:@"y"];
    }
    
    if (self.assets.count) {
        for (ALAsset *asset in self.assets) {
            UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage
                                                 scale:0.5
                                           orientation:UIImageOrientationUp];
            NSData *imagedata = UIImageJPEGRepresentation(image, 0.5);
            NSString *imageStr = [imagedata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSDictionary *imageDic = @{@"photo":imageStr,@"title":@"jpg"};
            [self.publishM.photos addObject:imageDic];
        }
        [reqDataDic setObject:self.publishM.photos forKey:@"photos"];
    }
    if (self.friendArray.count) {
        for (PeopleAddressBook *peleBook in self.friendArray) {
            if (peleBook.Aphone) {
                NSDictionary *peleDic = @{@"name":peleBook.name,@"phone":peleBook.Aphone};
                [self.publishM.with addObject:peleDic];
            }
        }
        [reqDataDic setObject:self.publishM.with forKey:@"with"];
    }
    
    [WLHttpTool addFeedParameterDic:reqDataDic success:^(id JSON) {
        
    } fail:^(NSError *error) {
        
    }];
    
    
}



#pragma mark - 取消
- (void)cancelPublish
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
