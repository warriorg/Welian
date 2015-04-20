//
//  WLNoteInfoView.m
//  Welian
//
//  Created by weLian on 15/3/27.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "WLNoteInfoView.h"

@interface WLNoteInfoView ()

@property (assign,nonatomic) UIActivityIndicatorView *activityView;//加载
@property (assign,nonatomic) UILabel *noteLabel;
@property (assign,nonatomic) UIButton *reloadBtn;

@end

@implementation WLNoteInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setLoadFailed:(BOOL)loadFailed
{
    [super willChangeValueForKey:@"loadFailed"];
    _loadFailed = loadFailed;
    [super didChangeValueForKey:@"loadFailed"];
    _reloadBtn.hidden = !_loadFailed;
    _noteLabel.hidden = _loadFailed;
    _activityView.hidden = _loadFailed;
}

- (void)setIsLoaded:(BOOL)isLoaded
{
    [super willChangeValueForKey:@"isLoaded"];
    _isLoaded = isLoaded;
    [super didChangeValueForKey:@"isLoaded"];
//    _activityView.hidden = _isLoaded;
    _reloadBtn.hidden = YES;
    _noteLabel.hidden = NO;
    if (_isLoaded) {
        [_activityView stopAnimating];
    }else{
        [_activityView startAnimating];
    }
}

- (void)setNoteInfo:(NSString *)noteInfo
{
    [super willChangeValueForKey:@"noteInfo"];
    _noteInfo = noteInfo;
    [super didChangeValueForKey:@"noteInfo"];
    _reloadBtn.hidden = YES;
    _noteLabel.hidden = NO;
    _noteLabel.text = _noteInfo;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [_noteLabel sizeToFit];
    _noteLabel.centerY = self.height / 2.f;
    _noteLabel.centerX = self.width / 2.f;
    
    [_activityView sizeToFit];
    _activityView.centerY = self.height / 2.f;
    if (_activityView.hidden) {
        _noteLabel.centerX = self.width / 2.f;
    }else{
        _noteLabel.left = _noteLabel.left + 7;
    }
    _activityView.right = _noteLabel.left - 15.f;
    
    _reloadBtn.size = CGSizeMake(self.width - 40.f, 40.f);
    _reloadBtn.centerX = self.width / 2.f;
    _reloadBtn.centerY = self.height / 2.f;
}

#pragma mark - Private
- (void)setup
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.hidesWhenStopped = YES;
    [self addSubview:activityView];
    self.activityView = activityView;
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.backgroundColor = [UIColor clearColor];
    noteLabel.textColor = [UIColor grayColor];
    noteLabel.font = kNormal14Font;
    [self addSubview:noteLabel];
    self.noteLabel = noteLabel;
    
    UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadBtn.backgroundColor = [UIColor clearColor];
    reloadBtn.titleLabel.font = kNormal16Font;
    [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    [reloadBtn setTitleColor:kTitleTextColor forState:UIControlStateNormal];
    [reloadBtn addTarget:self action:@selector(reloadBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    reloadBtn.hidden = YES;
    reloadBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    reloadBtn.layer.borderWidth = 0.8f;
    reloadBtn.layer.cornerRadius = 5.f;
    reloadBtn.layer.masksToBounds = YES;
    [self addSubview:reloadBtn];
    self.reloadBtn = reloadBtn;
}

- (void)reloadBtnClicked:(UIButton *)sender
{
    if (_reloadBlock && _loadFailed) {
        _reloadBlock();
    }
}

@end
