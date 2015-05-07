//
//  BasicViewController.m
//  Welian
//
//  Created by dong on 15/1/4.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController () <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

//@property (assign,nonatomic) WLNavHeaderView *navHeaderView;

@end

@implementation BasicViewController

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    if (_showCustomNavHeader) {
//        //代理置空，否则会闪退 设置手势滑动返回
//        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//        }
//    }
//}

//- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
//                                  animationControllerForOperation:(UINavigationControllerOperation)operation
//                                               fromViewController:(UIViewController *)fromVC
//                                                 toViewController:(UIViewController *)toVC
//{
//    if (operation == UINavigationControllerOperationPop) {
////        if (self.popAnimator == nil) {
////            self.popAnimator = [WQPopAnimator new];
////        }
////        return self.popAnimator;
//        DLog(@"---->UINavigationControllerOperationPop");
//    }else if(operation == UINavigationControllerOperationPush){
//        DLog(@"----->UINavigationControllerOperationPush");
//    }
//    
//    return self.navigationController.presentAnimation;
//    
//    return nil;
//}

//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //开启滑动手势
//    if (_showCustomNavHeader) {
//        if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            navigationController.interactivePopGestureRecognizer.enabled = YES;
//        }else{
//            navigationController.interactivePopGestureRecognizer.enabled = NO;
//        }
//    }
//}
//
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //隐藏导航条
    if (_showCustomNavHeader) {
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
        if (self.navigationController.viewControllers.count == 1) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }else{
            if (_isJoindThisVC) {
                self.navigationController.navigationBarHidden = NO;
                self.navigationController.navigationBar.hidden = NO;
            }else{
                self.navigationController.navigationBarHidden = NO;
                self.navigationController.navigationBar.hidden = YES;
            }
        }
//        [self.navigationController.navigationBar setDebug:YES];
    }else{
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.navigationBar.hidden = NO;
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //隐藏导航条//隐藏导航条
    if (_showCustomNavHeader) {
        if (self.navigationController.viewControllers.count == 1) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }else{
            self.navigationController.navigationBarHidden = NO;
            self.navigationController.navigationBar.hidden = YES;
        }
    }else{
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.navigationBar.hidden = NO;
        //        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
//    if (_isJoindThisVC  && self.navigationController.viewControllers.count > 1) {
//        //        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        self.navigationController.navigationBarHidden = NO;
//        self.navigationController.navigationBar.hidden = YES;
////        [self.navigationController.navigationBar setDebug:YES];
//    }else{
//        self.navigationController.navigationBarHidden = NO;
//        self.navigationController.navigationBar.hidden = NO;
//        //        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
//    if (_showCustomNavHeader) {
    
        //开启iOS7的滑动返回效果
//        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            //只有在二级页面生效
//            if ([self.navigationController.viewControllers count] > 1) {
//                self.navigationController.interactivePopGestureRecognizer.delegate = self;
//            }
//        }
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    self.navigationController.delegate = self;
    if (_showCustomNavHeader) {
        WLNavHeaderView *navHeaderView = [[WLNavHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, ViewCtrlTopBarHeight)];
        navHeaderView.backgroundColor = kNavBgColor;
        navHeaderView.titleInfo = self.title;
        
        [self.view addSubview:navHeaderView];
        self.navHeaderView = navHeaderView;
        [self.view bringSubviewToFront:_navHeaderView];
//        [navHeaderView setDebug:YES];
        
        WEAKSELF
        [navHeaderView setLeftClickecBlock:^(void){
            [weakSelf leftBtnClicked:nil];
        }];
        
        [navHeaderView setRightClickecBlock:^(void){
            [weakSelf rightBtnClicked:nil];
        }];
    }
}

#pragma mark - 选取头像照片
- (void)choosePicture
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择",nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self clickSheet:buttonIndex];
}

- (void)clickSheet:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [imagePicker setAllowsEditing:YES];
    if (buttonIndex==0) { //拍照
        // 判断相机可以使用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        }else {
            [[[UIAlertView alloc] initWithTitle:nil message:@"摄像头不可用！！！" delegate:self cancelButtonTitle:@"知道了！" otherButtonTitles:nil, nil] show];
            return;
        }
        
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
        
        
    }else if(buttonIndex ==1) {  // 从相册选择
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        }else {
            [[[UIAlertView alloc] initWithTitle:nil message:@"相册不可用！！！" delegate:self cancelButtonTitle:@"知道了！" otherButtonTitles:nil, nil] show];
            return;
        }
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
        
    }
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
}

- (void)leftBtnClicked:(UIButton *)sender
{
    DLog(@"%@ ------  leftBtnClicked",[self class]);
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightBtnClicked:(UIButton *)sender
{
    DLog(@"%@ ------  rightBtnClicked",[self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // 清除内存中的图片缓存
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr cancelAll];
    [mgr.imageCache clearMemory];
    DLog(@"%@ ------  didReceiveMemoryWarning",[self class]);
}

- (void)dealloc
{
    DLog(@"%@ ------  dealloc",[self class]);
    if (!self.needlessCancel) {
        [WLHUDView hiddenHud];
//        [WLHttpTool cancelAllRequestHttpTool];
        [WeLianClient cancelAllRequestHttpTool];
        DLog(@"--------------------------------------取消请求-------取消请求");
    }
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
