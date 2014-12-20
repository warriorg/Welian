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
#import "PublishModel.h"
#import "IWTextView.h"
#import "ZBMessageManagerFaceView.h"
#import "ForwardPublishView.h"
#import "WLStatusM.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

static NSString *picCellid = @"PicCellID";

@interface PublishStatusController () <UITextViewDelegate,CTAssetsPickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ZBMessageManagerFaceViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    UIButton *_emojiBut;
//    UITextField  *_commentTextView;
    UIView *_iamgeview;
    
    BOOL keyboardIsShow;//键盘是否显示
    
    PublishType _publishType;
    ALAssetsLibrary *_alassets;
}

@property (nonatomic,strong) ZBMessageManagerFaceView *faceView;

@property (nonatomic, strong) UIView *inputttView;
@property (nonatomic, copy)   NSMutableArray *assets;
@property (nonatomic, strong) IWTextView *textView;
@property (nonatomic, strong) UICollectionView *collectionView;


@property (nonatomic, strong) NSArray *friendArray;
@property (nonatomic, strong) PublishModel *publishM;

@property (nonatomic, strong) ForwardPublishView *forwardView;

@end

@implementation PublishStatusController


- (instancetype)initWithType:(PublishType)publishType
{
    _publishType = publishType;
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _alassets = [[ALAssetsLibrary alloc] init];
    _assets = [NSMutableArray arrayWithArray:_assets];
    keyboardIsShow=NO;
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
//    [self.navigationItem.rightBarButtonItem setEnabled:NO];
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

- (void)dealloc
{
    DLog(@"dsa");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}


- (void)addUIView {

//    CGFloat high = SuperSize.height-INPUT_HEIGHT;
    CGFloat high = iPhone5?180:140;
    self.textView = [[IWTextView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, high)];
    [self.textView setPlaceholder:@"说点什么..."];
//    [self.textView setBackgroundColor:[UIColor orangeColor]];
    [self.textView setBaseWritingDirection:UITextWritingDirectionLeftToRight forRange:nil];
    [self.textView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.textView setFont:[UIFont systemFontOfSize:17]];
    [self.textView setDelegate:self];
    [self.textView becomeFirstResponder];
    [self.textView setReturnKeyType:UIReturnKeyDone];
    [self.view addSubview:self.textView];
    
    
    self.inputttView = [[UIView alloc]initWithFrame:CGRectMake(0, SuperSize.height-INPUT_HEIGHT, SuperSize.width, INPUT_HEIGHT)];
    UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, 1)];
    [linView setBackgroundColor:WLLineColor];
    [self.inputttView addSubview:linView];
    [self.inputttView setBackgroundColor:[UIColor whiteColor]];
    
    _emojiBut = [[UIButton alloc] initWithFrame:CGRectMake(20, 2, 44, 44)];
    [_emojiBut setImage:[UIImage imageNamed:@"me_circle_chat_emoji"] forState:UIControlStateNormal];
    [_emojiBut setImage:[UIImage imageNamed:@"me_circle_chat_keybroad"] forState:UIControlStateSelected];
    [_emojiBut addTarget:self action:@selector(showEmojiView:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputttView addSubview:_emojiBut];
    
    if (_publishType == PublishTypeNomel) {
        
        // 选择照片
        UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(90, 0, 44, 44)];
        [but addTarget:self action:@selector(showPicVC:) forControlEvents:UIControlEventTouchUpInside];
        [but setImage:[UIImage imageNamed:@"home_new_picture"] forState:UIControlStateNormal];
        [self.inputttView addSubview:but];
        
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
    }else if (_publishType == PublishTypeForward){
        self.forwardView = [[ForwardPublishView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textView.frame)+10, [[UIScreen mainScreen] bounds].size.width, 60)];
        [self.forwardView setStatus:self.status];
        [self.view addSubview:self.forwardView];
    }

    
    self.faceView = [[ZBMessageManagerFaceView alloc]initWithFrame:CGRectMake(0, SuperSize.height, self.view.frame.size.width, keyboardHeight)];//216-->196
    [self.faceView.sendBut setHidden:YES];
    self.faceView.delegate = self;
    [self.view addSubview:self.faceView];

    
//    // 我的位置
//    UIButton *addLocation = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
//    [addLocation setTitle:@"添加位置" forState:UIControlStateNormal];
////    [addLocation setBackgroundColor:[UIColor blueColor]];
//    [addLocation.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    [addLocation addTarget:self action:@selector(addUserLocation:) forControlEvents:UIControlEventTouchUpInside];
//    [addLocation setImage:[UIImage imageNamed:@"me_mywriten_location"] forState:UIControlStateNormal];
//    [self.inputttView addSubview:addLocation];
    
    
    // 和谁在一起
//    UIButton *together = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 100, 30)];
//    [together setTitle:@"" forState:UIControlStateNormal];
//    [together setBackgroundColor:[UIColor blueColor]];
//    [together.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    [together addTarget:self action:@selector(getTogether:) forControlEvents:UIControlEventTouchUpInside];
//    [self.inputttView addSubview:together];
    
//    [self.inputttView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:self.inputttView];
}




-(void)showEmojiView:(UIButton*)but{
    
    [but setSelected:!but.selected];
    
    //如果直接点击表情，通过toolbar的位置来判断
    if (self.inputttView.frame.origin.y== SuperSize.height - INPUT_HEIGHT&&self.inputttView.frame.size.height==INPUT_HEIGHT) {
        
        [UIView animateWithDuration:Time animations:^{
            self.inputttView.frame = CGRectMake(0, SuperSize.height-keyboardHeight-INPUT_HEIGHT,  SuperSize.width,INPUT_HEIGHT);
        }];
        [UIView animateWithDuration:Time animations:^{
            [self.faceView setFrame:CGRectMake(0, SuperSize.height-keyboardHeight,SuperSize.width, keyboardHeight)];
        }];
        [self.textView resignFirstResponder];
        return;
    }
    //如果键盘没有显示，点击表情了，隐藏表情，显示键盘
    if (!keyboardIsShow) {
        [UIView animateWithDuration:Time animations:^{
            [self.faceView setFrame:CGRectMake(0, SuperSize.height, SuperSize.width, keyboardHeight)];
        }];
        [self.textView becomeFirstResponder];
        
    }else{
        [self.textView resignFirstResponder];
        //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
        [UIView animateWithDuration:Time animations:^{
            self.inputttView.frame = CGRectMake(0, SuperSize.height-keyboardHeight-INPUT_HEIGHT,  SuperSize.width,INPUT_HEIGHT);
        }];
        
        [UIView animateWithDuration:Time animations:^{
            [self.faceView setFrame:CGRectMake(0, SuperSize.height-keyboardHeight,SuperSize.width, keyboardHeight)];
        }];
    }
}




//#pragma mark 隐藏键盘
-(void)dismissKeyBoard{
    //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
    [UIView animateWithDuration:Time animations:^{
        self.inputttView.frame = CGRectMake(0, SuperSize.height-INPUT_HEIGHT,  SuperSize.width,INPUT_HEIGHT);
    }];
    
    [UIView animateWithDuration:Time animations:^{
        [self.faceView setFrame:CGRectMake(0, SuperSize.height,SuperSize.width, keyboardHeight)];
    }];
    [_emojiBut setSelected:NO];
    [self.textView resignFirstResponder];
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_emojiBut setSelected:NO];
}



- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele isSend:(BOOL)send
{

    if (dele) {
        
        NSString *inputString = self.textView.text;
        
        NSString *string = nil;
        NSInteger stringLength = inputString.length;
        if (stringLength > 0) {
            if ([@"]" isEqualToString:[inputString substringFromIndex:stringLength-1]]) {
                if ([inputString rangeOfString:@"["].location == NSNotFound){
                    string = [inputString substringToIndex:stringLength - 1];
                } else {
                    string = [inputString substringToIndex:[inputString rangeOfString:@"[" options:NSBackwardsSearch].location];
                }
            } else {
                string = [inputString substringToIndex:stringLength - 1];
            }
        }
        
        self.textView.text = string;
    }else{
        
        self.textView.text = [self.textView.text stringByAppendingString:faceStr];
        [self.textView setPlaceholder:nil];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
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
    CGSize size = CGSizeMake((self.view.bounds.size.width-60)/4 , (self.view.bounds.size.width-60)/4);
    return size;
}


- (PictureCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:picCellid forIndexPath:indexPath];;

    //    cell.textLabel.text = [self.dateFormatter stringFromDate:[asset valueForProperty:ALAssetPropertyDate]];
    //    cell.detailTextLabel.text = [asset valueForProperty:ALAssetPropertyType];
    
    //    cell.picImageV.image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage
    //                                               scale:1.0
    //                                         orientation:UIImageOrientationUp];
    //    [cell.picImageV setContentMode:UIViewContentModeScaleToFill];
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
            if (picArray.count || self.textView.text.length) {
                [self.navigationItem.rightBarButtonItem setEnabled:YES];
            }
            self.assets = picArray;
            [self.collectionView reloadData];
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
        
//        if (self.assets){
//        
//            self.assets = [NSMutableArray array];
//        }
        
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





- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length || self.assets.count) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {//按下return键
        
        [self dismissKeyBoard];
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
//    [self keyboardWillShowHide:notification];
    keyboardIsShow=NO;
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
    keyboardIsShow=YES;
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
    self.assets = [NSMutableArray arrayWithArray:assets];
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
        if ([infoPoi.name isEqualToString:@"不显示"]) {
            
        }else {
            
            [self.publishM setAddress:infoPoi.name];
            [self.publishM setX:[NSString stringWithFormat:@"%f",infoPoi.pt.latitude]];
            [self.publishM setY:[NSString stringWithFormat:@"%f",infoPoi.pt.longitude]];
        }
        
    }];
    [self.navigationController pushViewController:myLocationVC animated:YES];
}

#pragma mark - 和谁在一起
- (void)getTogether:(UIButton *)button
{
    
}


#pragma mark - 确认发布
- (void)confirmPublish
{
    if (_publishType == PublishTypeForward) {
        NSNumber *fid = [NSNumber numberWithInt:self.status.fid];
        
//        if (self.status.relationfeed) {
//            fid = [NSNumber numberWithInt:self.status.relationfeed.fid];
//        }
        [WLHttpTool forwardFeedParameterDic:@{@"fid":fid,@"content":self.textView.text} success:^(id JSON) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KPublishOK object:nil];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        } fail:^(NSError *error) {
            
        }];
        
    }else if (_publishType == PublishTypeNomel)
    {
        if (!(self.textView.text.length||self.assets.count)) {
            [WLHUDView showErrorHUD:@"内容为空！"];
            return;
        }
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
            
            [reqDataDic setObject:self.publishM.with forKey:@"with"];
        }
        
        [WLHttpTool addFeedParameterDic:reqDataDic success:^(id JSON) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KPublishOK object:nil];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        } fail:^(NSError *error) {
            
        }];
    }
}


#pragma mark - 取消
- (void)cancelPublish
{
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
