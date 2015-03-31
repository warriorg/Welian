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
#import "PublishModel.h"
#import "IWTextView.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "ACEExpandableTextCell.h"
#import "WLCellCardView.h"
#import "WUDemoKeyboardBuilder.h"


static NSString *picCellid = @"PicCellID";

@interface PublishStatusController () <UITextViewDelegate,CTAssetsPickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,ACEExpandableTableViewDelegate>

{
    CGFloat _cellHeight;
    
    UIButton *_emojiBut;
    UIView *_iamgeview;
    
    PublishType _publishType;
    ALAssetsLibrary *_alassets;
    NSString *_dataStr;
    
    ACEExpandableTextCell *_textCell;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *inputttView;
@property (nonatomic, strong) __block NSMutableArray *assets;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *friendArray;
@property (nonatomic, strong) PublishModel *publishM;

@property (nonatomic, strong) WLCellCardView *forwardView;

@end

@implementation PublishStatusController

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setSectionInset:UIEdgeInsetsMake(10, 15, 10, 15)];
        [layout setMinimumLineSpacing:10.0];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        // 注册cell
        [_collectionView registerClass:[PictureCell class] forCellWithReuseIdentifier:picCellid];
        [_collectionView setScrollEnabled:NO];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    NSInteger conut = _assets.count?_assets.count+1:_assets.count;
    
    [_collectionView setFrame:CGRectMake(0, 0, 0, 20+ceilf(conut/3.0)*(self.view.bounds.size.width-60)/3+20)];
    return _collectionView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, SuperSize.height-INPUT_HEIGHT) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}

- (instancetype)initWithType:(PublishType)publishType
{
    _publishType = publishType;
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACEExpandableTextCell *cell = [tableView expandableTextCellWithId:@"cellId"];
    _textCell = cell;
    cell.text = _dataStr;
    cell.textView.font = WLFONT(15);
    cell.textView.placeholder = @"说点什么...";
    [cell.textView becomeFirstResponder];
    _textCell.maxCellHeight = SuperSize.height - 380;
    return cell;
}

#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MAX(80.0, _cellHeight);
}

- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath
{
    _cellHeight = height;
}

- (void)tableView:(UITableView *)tableView updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath
{
    _dataStr = text;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    _alassets = [[ALAssetsLibrary alloc] init];
    _assets = [NSMutableArray arrayWithArray:_assets];
    self.publishM = [[PublishModel alloc] init];
    [self setUiItems];
    [self addUIView];
}

- (void)setUiItems
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //    [self.navigationItem setTitle:@"发布动态"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleBordered target:self action:@selector(confirmPublish)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPublish)];
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

- (void)dealloc
{
    DLog(@"dsa");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}


- (void)addUIView {
    
    [self.view addSubview:self.tableView];
    
    self.inputttView = [[UIView alloc]initWithFrame:CGRectMake(0, SuperSize.height-INPUT_HEIGHT, SuperSize.width, INPUT_HEIGHT)];
    UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, 1)];
    [linView setBackgroundColor:WLLineColor];
    [self.inputttView addSubview:linView];
    [self.inputttView setBackgroundColor:[UIColor whiteColor]];
    
    _emojiBut = [[UIButton alloc] initWithFrame:CGRectMake(20, 2, 44, 44)];
    [_emojiBut setImage:[UIImage imageNamed:@"me_circle_chat_emoji"] forState:UIControlStateNormal];
    [_emojiBut setImage:[UIImage imageNamed:@"me_circle_chat_keybroad"] forState:UIControlStateSelected];
    [_emojiBut addTarget:self action:@selector(switchKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputttView addSubview:_emojiBut];
    
    if (_publishType == PublishTypeNomel) {
        
        // 选择照片
        UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(90, 0, 44, 44)];
        [but addTarget:self action:@selector(showPicVC:) forControlEvents:UIControlEventTouchUpInside];
        [but setImage:[UIImage imageNamed:@"home_new_picture"] forState:UIControlStateNormal];
        [self.inputttView addSubview:but];
        
        [self.tableView setTableFooterView:self.collectionView];
    }else if (_publishType == PublishTypeForward){
        self.forwardView = [[WLCellCardView alloc] init];
        self.forwardView.frame = CGRectMake(0, 0, SuperSize.width-30, 56);
        [self.forwardView setCardM:self.statusCard];
        [self.tableView setTableFooterView:self.forwardView];
    }
    
    [self.view addSubview:self.inputttView];
}

- (void)switchKeyboard:(UIButton *)sender {
    [_emojiBut setSelected:!_emojiBut.selected];
    if (_textCell.textView.isFirstResponder) {
        if (_textCell.textView.emoticonsKeyboard)
        {
            [_textCell.textView switchToDefaultKeyboard];
        }
        else{
            WUEmoticonsKeyboard *adf = [WUDemoKeyboardBuilder sharedEmoticonsKeyboard];
            [adf setHideSendBut:YES];
            [_textCell.textView switchToEmoticonsKeyboard:adf];
        }
    }else{
        WUEmoticonsKeyboard *adf = [WUDemoKeyboardBuilder sharedEmoticonsKeyboard];
        [adf setHideSendBut:YES];
        [_textCell.textView switchToEmoticonsKeyboard:adf];
//        [_textCell.textView switchToEmoticonsKeyboard:[WUDemoKeyboardBuilder sharedEmoticonsKeyboard]];
        [_textCell.textView becomeFirstResponder];
    }
}



//#pragma mark 隐藏键盘
-(void)dismissKeyBoard{
    //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
    [UIView animateWithDuration:Time animations:^{
        self.inputttView.frame = CGRectMake(0, SuperSize.height-INPUT_HEIGHT,  SuperSize.width,INPUT_HEIGHT);
    }];
    
    [_emojiBut setSelected:NO];
    [_textCell.textView resignFirstResponder];
    [_textCell.textView switchToDefaultKeyboard];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self dismissKeyBoard];
}



#pragma mark - CollectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.assets.count>0&&self.assets.count<9) {
        return self.assets.count+1;
    }
    return self.assets.count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((self.view.bounds.size.width-60)/3 , (self.view.bounds.size.width-60)/3);
    return size;
}


- (PictureCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:picCellid forIndexPath:indexPath];;
    
    if (self.assets.count>0) {
        if (indexPath.row==self.assets.count) {
            
            [cell.picImageV setImage:[UIImage imageNamed:@"home_new_upload_picture_add"]];
        }else{
            ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
            [cell.picImageV setImage:[UIImage imageWithCGImage:asset.thumbnail]];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.assets.count) {
        [self showPicVC:nil];
    }else{
        CTAssetsPageViewController *vc = [[CTAssetsPageViewController alloc] initWithAssets:self.assets picDatablock:^(NSMutableArray *picArray) {
            if (picArray.count || _textCell.textView.text.length) {
                [self.navigationItem.rightBarButtonItem setEnabled:YES];
            }
            self.assets = picArray;
            [self.collectionView reloadData];
            [self.tableView setTableFooterView:self.collectionView];
        }];
        vc.pageIndex = indexPath.row;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}


- (void)showPicVC:(UIButton*)but
{
    
    [self dismissKeyBoard];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择",nil];
    [sheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {  // 拍照
        // 判断相机可以使用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            //            [imagePicker setAllowsEditing:YES];
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:imagePicker animated:YES completion:^{
                
            }];
        }else {
            [[[UIAlertView alloc] initWithTitle:nil message:@"摄像头不可用！！！" delegate:self cancelButtonTitle:@"知道了！" otherButtonTitles:nil, nil] show];
            return;
        }
        
    }else if (buttonIndex ==1){ // 从相册选择
        
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.assetsFilter         = [ALAssetsFilter allAssets];
        [picker setAssetsLibrary:_alassets];
        //    picker.showsCancelButton    = NO;
        picker.delegate             = self;
        picker.selectedAssets       = [NSMutableArray arrayWithArray:self.assets];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
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
                [self.assets addObject:asset];
                [self.navigationItem.rightBarButtonItem setEnabled:YES];
                [self.collectionView reloadData];
                [self.tableView setTableFooterView:self.collectionView];
                [picker dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
            } failureBlock:^(NSError *error) {
                
            }];
            
            //            [_alassets saveImage:[info objectForKey:UIImagePickerControllerOriginalImage] toAlbum:@"weLian" withCompletionBlock:^(NSError *error) {
            //
            //
            //            } withSaveAlasset:^(ALAsset *asset) {
            //                if (asset) {  // 保存成功
            //
            //                    [self.assets addObject:asset];
            //                    [self.collectionView reloadData];
            //
            //
            //                }else{
            //
            //                }
            //            }];
            
        }];
    }
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
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

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSMutableArray *)assets
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    if (assets.count || _textCell.textView.text.length) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    self.assets = assets;
    //    [self reloadCollectionView];
    [self.collectionView reloadData];
    [self.tableView setTableFooterView:self.collectionView];
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

//#pragma mark - 添加位置
//- (void)addUserLocation:(UIButton*)but
//{
//    MyLocationController *myLocationVC = [[MyLocationController alloc] initWithLocationBlock:^(BMKPoiInfo *infoPoi) {
//
//        [but setTitle:infoPoi.name forState:UIControlStateNormal];
//        [but sizeToFit];
//        if ([infoPoi.name isEqualToString:@"不显示"]) {
//
//        }else {
//
//            [self.publishM setAddress:infoPoi.name];
//            [self.publishM setX:[NSString stringWithFormat:@"%f",infoPoi.pt.latitude]];
//            [self.publishM setY:[NSString stringWithFormat:@"%f",infoPoi.pt.longitude]];
//        }
//
//    }];
//    [self.navigationController pushViewController:myLocationVC animated:YES];
//}

#pragma mark - 和谁在一起
- (void)getTogether:(UIButton *)button
{
    
}


#pragma mark - 确认发布
- (void)confirmPublish
{
    [self.view.findFirstResponder resignFirstResponder];
    [self dismissKeyBoard];
    if (_publishType == PublishTypeForward) {
        if (self.statusCard) {
            NSMutableDictionary *pubCardDic = [NSMutableDictionary dictionary];
            if (_textCell.textView.text.length) {
                if (_textCell.textView.text.length>300) {
                    [WLHUDView showErrorHUD:@"不能超过300字"];
                    return;
                }
                [pubCardDic setObject:_textCell.textView.text forKey:@"content"];
            }
            [pubCardDic setObject:[self.statusCard keyValues] forKey:@"card"];
            [WLHttpTool addFeedParameterDic:pubCardDic success:^(id JSON) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KPublishOK object:nil];
                if (self.publishBlock) {
                    self.publishBlock();
                }
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
            } fail:^(NSError *error) {
                [WLHUDView showErrorHUD:@"发布失败！"];
            }];
        }else{
            [WLHUDView showErrorHUD:@"内容为空！"];
            return;
        }
    }else if (_publishType == PublishTypeNomel)
    {
        if (!(_textCell.textView.text.length||self.assets.count)) {
            [WLHUDView showErrorHUD:@"内容为空！"];
            return;
        }
        [self.publishM setContent:_textCell.textView.text];
        self.publishM.with = [NSMutableArray array];
        self.publishM.photos = [NSMutableArray array];
        NSMutableDictionary *reqDataDic = [NSMutableDictionary dictionary];
        if (self.publishM.content) {
            if (_textCell.textView.text.length>300) {
                [WLHUDView showErrorHUD:@"不能超过300字"];
                return;
            }
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
            
            [reqDataDic setObject:self.publishM.with forKey:@"with"];
        }
        
        [WLHttpTool addFeedParameterDic:reqDataDic success:^(id JSON) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KPublishOK object:nil];
            if (self.publishBlock) {
                self.publishBlock();
            }
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        } fail:^(NSError *error) {
            [WLHUDView showErrorHUD:@"发布失败！"];
        }];
    }
    
}


#pragma mark - 取消
- (void)cancelPublish
{
    [self dismissKeyBoard];
    if (_textCell.textView.text.length||self.assets.count||self.statusCard) {
        WEAKSELF
        [UIAlertView bk_showAlertViewWithTitle:@"退出此次编辑？" message:@"" cancelButtonTitle:@"取消" otherButtonTitles:@[@"退出"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==1) {
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                }];
            }
        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
