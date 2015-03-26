//
//  WLCustomSegmentedControl.m
//  Welian
//
//  Created by weLian on 15/3/24.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "WLCustomSegmentedControl.h"



#define kBadgeHeight 17.f
#define kBadge2Width 24.f

#define kTagOfTitle 800
#define kTagOfDetailTitle 810
#define kTagOfLine 820
#define kTagOfBadge 830

@interface WLScrollView : UIScrollView
@end

@implementation WLScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.dragging) {
        [self.nextResponder touchesMoved:touches withEvent:event];
    } else{
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) {
        [self.nextResponder touchesEnded:touches withEvent:event];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

@end

@interface WLCustomSegmentedControl ()

@property (nonatomic, readwrite) CGFloat segmentWidth;
@property (nonatomic, readwrite) NSArray *segmentWidthsArray;
@property (nonatomic, strong) WLScrollView *scrollView;

@property (nonatomic, assign) UIView *bottomLineView;

@end

@implementation WLCustomSegmentedControl

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithSectionTitles:(NSArray *)sectiontitles {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        [self setup];
        self.sectionTitles = sectiontitles;
    }
    return self;
}

- (void)setup
{
    self.scrollView = [[WLScrollView alloc] init];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.font = [UIFont systemFontOfSize:16.f];//[UIFont fontWithName:@"STHeitiSC-Light" size:16.0f];
    self.detailLabelFont = [UIFont systemFontOfSize:16.f];
    self.textColor = [UIColor blackColor];
    self.detailTextColor = KBlueTextColor;
    self.selectedTextColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.opaque = NO;
    self.selectionIndicatorColor = [UIColor colorWithRed:52.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    
//    self.selectedSegmentIndex = 0;
    self.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.selectionIndicatorHeight = 5.0f;
    self.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.userDraggable = YES;
    self.touchEnabled = YES;
    self.verticalDividerEnabled = NO;
    
    self.shouldAnimateUserSelection = YES;
    
    self.contentMode = UIViewContentModeRedraw;
    
    //下方的线
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = WLLineColor;
    [self.scrollView addSubview:bottomLineView];
    self.bottomLineView = bottomLineView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateSegmentsRects];
    
    _bottomLineView.backgroundColor = _selectionIndicatorColor;
    
    //标题
    [_sectionTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //消息
        UILabel *titleLabel = (UILabel *)[_scrollView viewWithTag:kTagOfTitle + idx];
        if (!titleLabel) {
            //标题
            titleLabel = [[UILabel alloc] init];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = _font;
            titleLabel.textColor = _textColor;
            titleLabel.tag = kTagOfTitle + idx;
            [_scrollView addSubview:titleLabel];
        }
        titleLabel.text = obj;
        [titleLabel sizeToFit];
        titleLabel.centerX = (_segmentWidth / 2.f) + _segmentWidth * idx;
        titleLabel.centerY = (self.height - _selectionIndicatorHeight) / 2.f;
        
        if (_sectionDetailTitles) {
            UILabel *detailLabel = (UILabel *)[_scrollView viewWithTag:kTagOfDetailTitle + idx];
            if (!detailLabel) {
                //详情
                detailLabel = [[UILabel alloc] init];
                detailLabel.backgroundColor = [UIColor clearColor];
                detailLabel.font = _detailLabelFont;
                detailLabel.textColor = _detailTextColor;
                detailLabel.tag = kTagOfDetailTitle + idx;
                [_scrollView addSubview:detailLabel];
            }
            detailLabel.text = [_sectionDetailTitles objectAtIndex:idx];
            [detailLabel sizeToFit];
            //纵向排列
            if (_isShowVertical) {
                titleLabel.centerX = (_segmentWidth / 2.f) + _segmentWidth * idx;
                titleLabel.top = (self.height - _selectionIndicatorHeight) / 2.f;
                detailLabel.bottom = titleLabel.top;
                detailLabel.centerX = titleLabel.centerX;
            }else{
                titleLabel.left = (_segmentWidth - titleLabel.width - detailLabel.width - 3.f) / 2.f + _segmentWidth * idx;
                titleLabel.centerY = (self.height - _selectionIndicatorHeight) / 2.f;
                detailLabel.left = titleLabel.right + 3.f;
                detailLabel.centerY = titleLabel.centerY;
            }
        }
        
        //分割线
        if (_showLine && idx > 0) {
            UIView *lineView = (UIView *)[_scrollView viewWithTag:kTagOfLine + idx];
            if (!lineView) {
                //分割线
                lineView = [[UIView alloc] init];
                lineView.backgroundColor = WLLineColor;
                lineView.tag = kTagOfLine + idx;
                [_scrollView addSubview:lineView];
            }
            lineView.backgroundColor = WLLineColor;
            lineView.size = CGSizeMake(0.8f, self.height - _selectionIndicatorHeight - 15.f);
            lineView.left = _segmentWidth * idx;
            lineView.centerY = (self.height - _selectionIndicatorHeight) / 2.f;
        }
        
        //显示下划线
        if(_showBottomLine && (idx == _selectedSegmentIndex)){
            _bottomLineView.size = CGSizeMake(_segmentWidth, _selectionIndicatorHeight);
            _bottomLineView.left = _segmentWidth * idx;
            _bottomLineView.bottom = self.height;
        }
        
        //添加角标
        if (_sectionBadges) {
            NSNumber *badge = [_sectionBadges objectAtIndex:idx];
            
            UIButton *numBtn = (UIButton *)[_scrollView viewWithTag:kTagOfBadge + idx];
            if (!numBtn) {
                //角标
                numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                numBtn.backgroundColor = [UIColor clearColor];
                numBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
                [numBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [numBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                numBtn.tag = kTagOfBadge + idx;
                [_scrollView addSubview:numBtn];
            }
            if (badge.integerValue < 100) {
                [numBtn setTitle:[NSString stringWithFormat:@"%@",badge] forState:UIControlStateNormal];
                [numBtn setTitle:[NSString stringWithFormat:@"%@",badge] forState:UIControlStateSelected];
                [numBtn setBackgroundImage:[UIImage imageNamed:@"notification_badge1"] forState:UIControlStateNormal];
                [numBtn setBackgroundImage:[UIImage imageNamed:@"notification_badge1"] forState:UIControlStateSelected];
            }else{
                [numBtn setTitle:@"99+" forState:UIControlStateNormal];
                [numBtn setTitle:@"99+" forState:UIControlStateSelected];
                [numBtn setBackgroundImage:[UIImage imageNamed:@"notification_badge2"] forState:UIControlStateNormal];
                [numBtn setBackgroundImage:[UIImage imageNamed:@"notification_badge2"] forState:UIControlStateSelected];
            }
            numBtn.size = CGSizeMake(badge.integerValue < 100 ? kBadgeHeight : kBadge2Width, kBadgeHeight);
            numBtn.left = titleLabel.right - 5.f;
            numBtn.bottom = titleLabel.top + 8.f;
            numBtn.hidden = badge.integerValue > 0 ? NO : YES;
        }
        
    }];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self updateSegmentsRects];
}

- (void)setSectionDetailTitles:(NSArray *)sectionDetailTitles
{
    [super willChangeValueForKey:@"sectionDetailTitles"];
    _sectionDetailTitles = sectionDetailTitles;
    [super didChangeValueForKey:@"sectionDetailTitles"];
    [self setNeedsLayout];
}

- (void)setSectionTitles:(NSArray *)sectionTitles
{
    [super willChangeValueForKey:@"sectionTitles"];
    _sectionTitles = sectionTitles;
    [super didChangeValueForKey:@"sectionTitles"];
    
    [self setNeedsLayout];
}

- (void)setSectionBadges:(NSArray *)sectionBadges
{
    [super willChangeValueForKey:@"sectionBadges"];
    _sectionBadges = sectionBadges;
    [super didChangeValueForKey:@"sectionBadges"];
    [self setNeedsLayout];
}

- (void)setShowLine:(BOOL)showLine
{
    _showLine = showLine;
    if (_showLine && [self sectionCount] > 0) {
        self.segmentWidth = (self.frame.size.width - ([self sectionCount] - 1) * 0.8) / [self sectionCount];
    }
}

- (void)updateSegmentsRects {
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.scrollView.backgroundColor = self.backgroundColor;
    
    // When `scrollEnabled` is set to YES, segment width will be automatically set to the width of the biggest segment's text or image,
    // otherwise it will be equal to the width of the control's frame divided by the number of segments.
    if ([self sectionCount] > 0) {
        self.segmentWidth = self.frame.size.width / [self sectionCount];
    }
    
    self.scrollView.scrollEnabled = self.isUserDraggable;
    self.scrollView.contentSize = CGSizeMake([self totalSegmentedControlWidth], self.frame.size.height);
}

- (NSUInteger)sectionCount {
    return self.sectionTitles.count;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // Control is being removed
    if (newSuperview == nil)
        return;
    
    if (self.sectionTitles || self.sectionImages) {
        [self updateSegmentsRects];
    }
}

#pragma mark - Touch

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        NSInteger segment = 0;
//        if (self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleFixed) {
            segment = (touchLocation.x + self.scrollView.contentOffset.x) / self.segmentWidth;
//        } else if (self.segmentWidthStyle == HMSegmentedControlSegmentWidthStyleDynamic) {
//            // To know which segment the user touched, we need to loop over the widths and substract it from the x position.
//            CGFloat widthLeft = (touchLocation.x + self.scrollView.contentOffset.x);
//            for (NSNumber *width in self.segmentWidthsArray) {
//                widthLeft = widthLeft - [width floatValue];
//                
//                // When we don't have any width left to substract, we have the segment index.
//                if (widthLeft <= 0)
//                    break;
//                
//                segment++;
//            }
//        }
        
        NSUInteger sectionsCount;
        
//        if (self.type == HMSegmentedControlTypeImages) {
//            sectionsCount = [self.sectionImages count];
//        } else if (self.type == HMSegmentedControlTypeTextImages || self.type == HMSegmentedControlTypeText) {
            sectionsCount = [self.sectionTitles count];
//        }
        if(_isAllowTouchEveryTime)
        {
            if (self.isTouchEnabled)
                [self setSelectedSegmentIndex:segment animated:self.shouldAnimateUserSelection notify:YES];
        }else{
            if (segment != self.selectedSegmentIndex && segment < sectionsCount) {
                // Check if we have to do anything with the touch event
                if (self.isTouchEnabled)
                    [self setSelectedSegmentIndex:segment animated:self.shouldAnimateUserSelection notify:YES];
            }
        }
    }
}

#pragma mark - Scrolling

- (CGFloat)totalSegmentedControlWidth {
    return self.sectionTitles.count * self.segmentWidth;
}

- (void)scrollToSelectedSegmentIndex:(BOOL)animated {
    CGRect rectForSelectedIndex;
    CGFloat selectedSegmentOffset = 0;
    
    rectForSelectedIndex = CGRectMake(self.segmentWidth * self.selectedSegmentIndex,
                                      0,
                                      self.segmentWidth,
                                      self.frame.size.height);
    
    selectedSegmentOffset = (CGRectGetWidth(self.frame) / 2) - (self.segmentWidth / 2);
    
    
    CGRect rectToScrollTo = rectForSelectedIndex;
    rectToScrollTo.origin.x -= selectedSegmentOffset;
    rectToScrollTo.size.width += selectedSegmentOffset * 2;
    [self.scrollView scrollRectToVisible:rectToScrollTo animated:animated];
}

#pragma mark - Index change

- (void)setSelectedSegmentIndex:(NSInteger)index {
    [self setSelectedSegmentIndex:index animated:NO notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated {
    [self setSelectedSegmentIndex:index animated:animated notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify {
    _selectedSegmentIndex = index;
    
    //显示下划线
    if(_showBottomLine){
        _bottomLineView.size = CGSizeMake(self.segmentWidth, _selectionIndicatorHeight);
        _bottomLineView.left = self.segmentWidth * _selectedSegmentIndex;
        _bottomLineView.bottom = self.height;
    }
    
    if (notify)
        [self notifyForSegmentChangeToIndex:index];
}

- (void)notifyForSegmentChangeToIndex:(NSInteger)index {
    if (self.superview)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if (self.indexChangeBlock)
        self.indexChangeBlock(index);
}

@end
