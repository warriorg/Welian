//
//  WLSegmentedControl.m
//  Welian
//
//  Created by weLian on 15/1/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "WLSegmentedControl.h"

#define kMarginTop 15.f
#define kMarginBottom 12.f
#define Min_Button_Width 80.0

#define Define_View_Tag 1000
#define Define_Label_Tag 1100
#define Define_Image_Tag 1200
#define Define_Btn_Tag 1300
#define Define_LineView_Tag 1400
#define Define_Bridge_Tag 1500
#define Define_SmallImage_Tag 1600

#define kBadgeHeight 17.f
#define kBadge2Width 24.f

#define UIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface WLSegmentedControl ()

//@property (strong, nonatomic) UIScrollView *scrollView;
//@property (strong, nonatomic) UIView *bottomLineView;

@property (strong, nonatomic) NSMutableArray *array4Btn;
@property (strong, nonatomic) NSArray *images;
@property (assign, nonatomic) BOOL isHorizontal;//横向排列
//@property (assign, nonatomic) UIButton *selectBtn;


@end

@implementation WLSegmentedControl

- (void)dealloc
{
//    _scrollView = nil;
    _array4Btn = nil;
    _titles = nil;
    _images = nil;
    _bridges = nil;
}

- (id)initWithFrame:(CGRect)frame Titles:(NSArray *)titles Images:(NSArray *)images Bridges:(NSArray *)bridges isHorizontal:(BOOL)isHorizontal
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //初始化数据
        self.titles = titles;
        self.images = images;
        self.bridges = bridges;
        self.isHorizontal = isHorizontal;
        
        [self setup];
    }
    return self;
}

- (void)setBridges:(NSArray *)bridges
{
    [super willChangeValueForKey:@"bridges"];
    _bridges = bridges;
    [super didChangeValueForKey:@"bridges"];
    
    for (int i = 0; i<[_bridges count]; i++) {
        UIButton *numBtn = (UIButton *)[self viewWithTag:Define_Bridge_Tag + i];
        numBtn.hidden = [_bridges[i] intValue] > 0 ? NO : YES;
        [numBtn setTitle:[_bridges[i] intValue] > 99 ? @"99+" : _bridges[i] forState:UIControlStateNormal];
        [numBtn setBackgroundImage:[UIImage imageNamed:[_bridges[i] intValue] > 99 ? @"notification_badge2" : @"notification_badge1"] forState:UIControlStateNormal];
    }
}

- (void)setTitles:(NSArray *)titles
{
    [super willChangeValueForKey:@"titles"];
    _titles = titles;
    [super didChangeValueForKey:@"titles"];
    for (int i = 0; i<[_titles count]; i++) {
        UILabel *titleLabel = (UILabel *)[self viewWithTag:Define_Label_Tag + i];
        titleLabel.text = _titles[i];
    }
}

- (void)setShowSmallImage:(BOOL)showSmallImage
{
    _showSmallImage = showSmallImage;
}

- (void)setLineHeightAll:(BOOL)lineHeightAll
{
    _lineHeightAll = lineHeightAll;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width4btn = self.width /[_titles count];
    if (width4btn < Min_Button_Width) {
        width4btn = Min_Button_Width;
    }
    CGFloat viewHeight = self.height;
    
//    _scrollView.frame = CGRectMake(0, 0, self.width, viewHeight);
//    _scrollView.contentSize = CGSizeMake([_titles count] * width4btn, _scrollView.height);
    
    for (int i = 0; i < [_titles count]; i++) {
        UIView *view = [self viewWithTag:Define_View_Tag + i];
        view.frame = CGRectMake(i*width4btn, .0f, width4btn, viewHeight);
        
        //添加内容
        UILabel *titleLabel = (UILabel *)[view viewWithTag:Define_Label_Tag + i];
        [titleLabel sizeToFit];
        
        //添加图片
        if (_images) {
            UIImageView *iconImage = (UIImageView *)[view viewWithTag:Define_Image_Tag + i];
            [iconImage sizeToFit];
            if (_isHorizontal) {
                iconImage.left = (view.width - titleLabel.width - iconImage.width - kMarginBottom) / 2.f; //20.f;
                iconImage.centerY = view.height / 2.f;
            }else{
                iconImage.centerX = view.width / 2.f;
                iconImage.top = kMarginBottom;
            }
            
            if (_isHorizontal) {
                titleLabel.left = iconImage.right + kMarginBottom;
                titleLabel.centerY = view.height / 2.f;
            }else{
                titleLabel.centerX = view.width / 2.f;
                titleLabel.top = iconImage.bottom + kMarginBottom;
            }
        }else{
            titleLabel.width = view.width;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.centerX = view.width / 2.f;
            titleLabel.centerY = view.height / 2.f;
        }
        
        //右下角图标
        UIImageView *smallImage = (UIImageView *)[view viewWithTag:Define_SmallImage_Tag + i];
        [smallImage sizeToFit];
        smallImage.right = view.width - 3.f;
        smallImage.bottom = view.height - 3.f;
        smallImage.hidden = !_showSmallImage;
        
        //角标按钮
        UIButton *numBtn = (UIButton *)[view viewWithTag:Define_Bridge_Tag + i];
        numBtn.size = CGSizeMake(([_bridges[i] intValue] > 99) ? kBadge2Width : kBadgeHeight, kBadgeHeight);
        numBtn.top = 5;
        numBtn.right = view.width - 5;
        
        //添加点击按钮
        UIButton *btn = (UIButton *)[view viewWithTag:Define_Btn_Tag + i];
        btn.frame = view.bounds;
    }
    
    //分割线
    for (int i = 1; i< [_titles count]; i++) {
        UIView *lineView = [self viewWithTag:Define_LineView_Tag + i];
        lineView.frame = CGRectMake(i * width4btn - 1.f,_lineHeightAll ? 0 : 5.f, 1.f, _lineHeightAll ? viewHeight : viewHeight - 10);
    }
    
//    UIView *view = [self viewWithTag:_selectBtn.tag];
//    _bottomLineView.frame = CGRectMake(1.0f, self.height-2, width4btn-2.0f, 2.0f);
}

#pragma mark - Private
- (void)setup
{
    _array4Btn = [[NSMutableArray alloc] initWithCapacity:[_titles count]];
    
//    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
//    _scrollView.backgroundColor = self.backgroundColor;
//    _scrollView.userInteractionEnabled = YES;
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.showsVerticalScrollIndicator = NO;
    
    for (int i = 0; i<[_titles count]; i++) {
        //添加展示的View
        UIView *view = [[UIView alloc] init];
        view.tag = Define_View_Tag + i;
//        [view setDebug:YES];
        
        //添加内容
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        titleLabel.textColor = RGB(155.f, 155.f, 155.f);
        titleLabel.text = _titles[i];
        titleLabel.tag = Define_Label_Tag + i;
        [view addSubview:titleLabel];
        
        //添加图片
        if (_images) {
            UIImageView *iconImage = [[UIImageView alloc] initWithImage:_images[i]];
            iconImage.backgroundColor = [UIColor clearColor];
            iconImage.tag = Define_Image_Tag + i;
            [view addSubview:iconImage];
        }
        
        //添加右下角小图片
        UIImageView *smallImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discovery_activity_list_ choose"]];
        smallImage.backgroundColor = [UIColor clearColor];
        smallImage.tag = Define_SmallImage_Tag + i;
        smallImage.hidden = YES;
        [view addSubview:smallImage];
        
        //添加角标
        UIButton *numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        numBtn.backgroundColor = [UIColor clearColor];
        numBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        numBtn.titleEdgeInsets = UIEdgeInsetsMake(.0, 0, .0, .0);
        //    [numBtn setTitle:@"99" forState:UIControlStateNormal];
        [numBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        numBtn.tag = Define_Bridge_Tag + i;
        numBtn.hidden = [_bridges[i] intValue] > 0 ? NO : YES;
        [numBtn setTitle:[_bridges[i] intValue] > 99 ? @"99+" : _bridges[i] forState:UIControlStateNormal];
        [numBtn setBackgroundImage:[UIImage imageNamed:[_bridges[i] intValue] > 99 ? @"notification_badge2" : @"notification_badge1"] forState:UIControlStateNormal];
        [view addSubview:numBtn];
//        [numBtn setDebug:YES];
        
        //添加点击按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //btn.frame = view.bounds;//CGRectMake(i*width4btn, .0f, width4btn, self.height);
        [btn setTitleColor:UIColorFromRGBValue(0x999999) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:UIColorFromRGBValue(0x454545) forState:UIControlStateSelected];
        //            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = Define_Btn_Tag + i;
        [view addSubview:btn];
        [_array4Btn addObject:btn];
//        [_scrollView addSubview:view];
        [self addSubview:view];
        
        if (i == 0) {
            btn.selected = YES;
//            self.selectBtn = btn;
        }
    }
    
    //  lineView
    for (int i = 1; i< [_titles count]; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGB(229, 229, 229);
        lineView.tag = Define_LineView_Tag + i;
//        [_scrollView addSubview:lineView];
        [self addSubview:lineView];
    }
    

    //  bottom lineView
//    _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(1.0f, self.height-2, width4btn-2.0f, 2.0f)];
//    _bottomLineView.backgroundColor = RGB(250, 204, 62);//UIColorFromRGBValue(0x454545);
//    [_scrollView addSubview:_bottomLineView];
    
//    [self addSubview:_scrollView];
}

- (void)segmentedControlChange:(UIButton *)btn
{
    btn.selected = YES;
    for (UIButton *subBtn in self.array4Btn) {
        if (subBtn != btn) {
            subBtn.selected = NO;
        }
    }
//    self.selectBtn = btn;
    
    //重新刷新
//    [self setNeedsDisplay];
//    CGRect rect4boottomLine = _bottomLineView.frame;
//    rect4boottomLine.origin.x = _selectBtn.frame.origin.x +1;
//    
//    CGPoint pt = CGPointZero;
//    BOOL canScrolle = NO;
//    if ((btn.tag - Define_Btn_Tag) >= 2 && [_array4Btn count] > 4 && [_array4Btn count] > (btn.tag - Define_Btn_Tag + 2)) {
//        pt.x = btn.frame.origin.x - Min_Button_Width*1.5f;
//        canScrolle = YES;
//    }else if ([_array4Btn count] > 4 && (btn.tag - Define_Btn_Tag + 2) >= [_array4Btn count]){
//        pt.x = (_array4Btn.count - 4) * Min_Button_Width;
//        canScrolle = YES;
//    }else if (_array4Btn.count > 4 && (btn.tag - Define_Btn_Tag) < 2){
//        pt.x = 0;
//        canScrolle = YES;
//    }
//    
//    if (canScrolle) {
//        [UIView animateWithDuration:0.3 animations:^{
//            _scrollView.contentOffset = pt;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.2 animations:^{
//                self.bottomLineView.frame = rect4boottomLine;
//            }];
//        }];
//    }else{
//        [UIView animateWithDuration:0.2 animations:^{
//            self.bottomLineView.frame = rect4boottomLine;
//        }];
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(wlSegmentedControlSelectAtIndex:)]) {
        [self.delegate wlSegmentedControlSelectAtIndex:btn.tag - Define_Btn_Tag];
    }
}

@end
