//
//  WLDisplayMediaViewController.m
//  Welian
//
//  Created by weLian on 15/1/22.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "WLDisplayMediaViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+XHRemoteImage.h"

@interface WLDisplayMediaViewController ()

@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;
@property (nonatomic, weak) UIImageView *photoImageView;

@end

@implementation WLDisplayMediaViewController

- (MPMoviePlayerController *)moviePlayerController {
    if (!_moviePlayerController) {
        _moviePlayerController = [[MPMoviePlayerController alloc] init];
        _moviePlayerController.repeatMode = MPMovieRepeatModeOne;
        _moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
        _moviePlayerController.view.frame = self.view.frame;
        [self.view addSubview:_moviePlayerController.view];
    }
    return _moviePlayerController;
}

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:photoImageView];
        _photoImageView = photoImageView;
    }
    return _photoImageView;
}

- (void)setMessage:(id<WLMessageModel>)message {
    _message = message;
    if ([message messageMediaType] == WLBubbleMessageMediaTypeVideo) {
        self.title = NSLocalizedStringFromTable(@"Video", @"MessageDisplayKitString", @"详细视频");
        self.moviePlayerController.contentURL = [NSURL fileURLWithPath:[message videoPath]];
        [self.moviePlayerController play];
    } else if ([message messageMediaType] ==WLBubbleMessageMediaTypePhoto) {
        self.title = NSLocalizedStringFromTable(@"Photo", @"MessageDisplayKitString", @"详细照片");
        self.photoImageView.image = message.photo;
        self.photoImageView.size = [self fitsize:message.photo.size];
        self.photoImageView.centerX = self.view.width / 2.f;
        self.photoImageView.centerY = (self.view.height + ViewCtrlTopBarHeight) / 2.f;
        if (message.thumbnailUrl) {
            [self.photoImageView setImageWithURL:[NSURL URLWithString:[message thumbnailUrl]] placeholer:[UIImage imageNamed:@"placeholderImage"]];
        }
    }
}

- (CGSize)fitsize:(CGSize)thisSize
{
    if(thisSize.width == 0 && thisSize.height ==0)
        return CGSizeMake(0, 0);
    CGFloat wscale = thisSize.width/[UIScreen mainScreen].bounds.size.width;
    CGFloat hscale = thisSize.height/[UIScreen mainScreen].bounds.size.height;
    CGFloat scale = (wscale>hscale) ? wscale:hscale;
    CGSize newSize = CGSizeMake(thisSize.width/scale, thisSize.height/scale);
    return newSize;
}

#pragma mark - Life cycle

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.message messageMediaType] == WLBubbleMessageMediaTypeVideo) {
        [self.moviePlayerController stop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_moviePlayerController stop];
    _moviePlayerController = nil;
    
    _photoImageView = nil;
}

@end
