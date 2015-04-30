//
//  PublishStatusController.m
//  Welian
//
//  Created by dong on 14-9-12.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "PublishStatusController.h"
#import "CTAssetsPageViewController.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PictureCell.h"
#import "PublishModel.h"
#import "IWTextView.h"
#import "ACEExpandableTextCell.h"
#import "WLCellCardView.h"
#import "WUDemoKeyboardBuilder.h"

#import "WLStatusM.h"
#import "WLPhoto.h"
#import "WLBasicTrends.h"
#import "MJExtension.h"

static NSString *picCellid = @"PicCellID";

@interface PublishStatusController () <UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,ACEExpandableTableViewDelegate,JKImagePickerControllerDelegate>

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
@property (nonatomic, strong) __block NSMutableArray *assetsArray;
@property (nonatomic, strong) UICollectionView *collectionView;

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
        layout.itemSize = CGSizeMake((SuperSize.width-60)/3 , (SuperSize.width-60)/3);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // 注册cell
        [_collectionView registerClass:[PictureCell class] forCellWithReuseIdentifier:picCellid];
        [_collectionView setScrollEnabled:NO];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    NSInteger conut = _assetsArray.count?_assetsArray.count+1:_assetsArray.count;
    [_collectionView setFrame:CGRectMake(0, 0, SuperSize.width, 20+ceilf(conut/3.0)*(self.view.bounds.size.width-60)/3+20)];
    return _collectionView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, SuperSize.height-INPUT_HEIGHT) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    _assetsArray = [NSMutableArray arrayWithArray:_assetsArray];
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
        UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 44, 44)];
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
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.assetsArray.count>0&&self.assetsArray.count<9) {
        return self.assetsArray.count+1;
    }
    return self.assetsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:picCellid forIndexPath:indexPath];
    if (self.assetsArray.count>0) {
        if (indexPath.row==self.assetsArray.count) {
            
            [cell.picImageV setImage:[UIImage imageNamed:@"home_new_upload_picture_add"]];
        }else{
            JKAssets *jkAssets = [self.assetsArray objectAtIndex:indexPath.row];
            cell.picImageV.image = jkAssets.fullImage;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.assetsArray.count) {
        [self showPicVC:nil];
    }else{
        CTAssetsPageViewController *vc = [[CTAssetsPageViewController alloc] initWithAssets:self.assetsArray picDatablock:^(NSMutableArray *picArray) {
            if (picArray.count || _textCell.textView.text.length) {
                [self.navigationItem.rightBarButtonItem setEnabled:YES];
            }
            self.assetsArray = picArray;
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
    
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.filterType = JKImagePickerControllerFilterTypePhotos;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.selectedAssetArray = [NSMutableArray arrayWithArray:self.assetsArray];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
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

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    if (assets.count || _textCell.textView.text.length) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        self.assetsArray = [NSMutableArray arrayWithArray:assets];;
        [self.collectionView reloadData];
        [self.tableView setTableFooterView:_collectionView];
    }];
}

- (void)imagePickerControllerJKDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - 确认发布
- (void)confirmPublish
{
    [self.view.findFirstResponder resignFirstResponder];
    [self dismissKeyBoard];
    WEAKSELF
    if (_publishType == PublishTypeForward) {
        if (self.statusCard) {
            NSMutableDictionary *pubCardDic = [NSMutableDictionary dictionary];
            if (_textCell.textView.text.length) {
//                if (_textCell.textView.text.length>300) {
//                    [WLHUDView showErrorHUD:@"不能超过300字"];
//                    return;
//                }
                [pubCardDic setObject:_textCell.textView.text forKey:@"content"];
            }
            [pubCardDic setObject:[self.statusCard keyValues] forKey:@"card"];
            [WLHttpTool addFeedParameterDic:pubCardDic success:^(id JSON) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KPublishOK object:nil];
                if (weakSelf.publishBlock) {
                    weakSelf.publishBlock();
                }
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
            } fail:^(NSError *error) {
                [WLHUDView showErrorHUD:@"发布失败！"];
            }];
        }else{
            [WLHUDView showErrorHUD:@"内容为空！"];
            return;
        }
    }else if (_publishType == PublishTypeNomel){
        
        if (!(_textCell.textView.text.length||self.assetsArray.count)) {
            [WLHUDView showErrorHUD:@"内容为空！"];
            return;
        }
        [self.publishM setContent:_textCell.textView.text];
        self.publishM.photos = [NSMutableArray array];
        NSMutableDictionary *reqDataDic = [NSMutableDictionary dictionary];
        if (self.publishM.content) {
//            if (_textCell.textView.text.length>300) {
//                [WLHUDView showErrorHUD:@"不能超过300字"];
//                return;
//            }
            [reqDataDic setObject:self.publishM.content forKey:@"content"];
        }
        if (self.publishM.address) {
            [reqDataDic setObject:self.publishM.address forKey:@"address"];
            [reqDataDic setObject:self.publishM.x forKey:@"x"];
            [reqDataDic setObject:self.publishM.y forKey:@"y"];
        }
        if (self.assetsArray.count) {
            for (JKAssets *jkAsset in self.assetsArray) {
                UIImage *image = jkAsset.fullImage;
                NSData *imagedata = UIImageJPEGRepresentation(image, 0.5);
                NSString *imageStr = [imagedata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                NSDictionary *imageDic = @{@"imageDataStr":imageStr};
                [self.publishM.photos addObject:imageDic];
            }
             [reqDataDic setObject:weakSelf.publishM.photos forKey:@"photos"];
        }
        
//        IBaseUserM *meBase = [IBaseUserM getLoginUserBaseInfo];
//        NSDictionary *user = [meBase keyValues];
//        [reqDataDic setObject:user forKey:@"user"];
        
        NSString *dateStr = [NSString stringWithFormat:@"%lld",[[[NSDate date] formattedDateWithFormat:@"yyyyMMddHHMMss"] longLongValue]];
        [[WLDataDBTool sharedService] putObject:reqDataDic  withId:dateStr intoTable:KSendAgainDataTableName];
        if (self.publishDicBlock) {
            self.publishDicBlock(reqDataDic, dateStr);
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}


#pragma mark - 取消
- (void)cancelPublish
{
    [self dismissKeyBoard];
    if (_textCell.textView.text.length||self.assetsArray.count||self.statusCard) {
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
