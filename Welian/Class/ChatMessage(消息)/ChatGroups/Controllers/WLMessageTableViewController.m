//
//  WLMessageTableViewController.m
//  Welian
//
//  Created by weLian on 14/12/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLMessageTableViewController.h"
//#import "MyFriendUser.h"
//#import "ChatMessage.h"

@interface WLMessageTableViewController ()

//判断是否用户手指滚动
@property (nonatomic, assign) BOOL isUserScrolling;
//记录旧的textView contentSize Heigth
@property (nonatomic, assign) CGFloat previousTextViewContentHeight;
//记录键盘的高度，为了适配iPad和iPhone
@property (nonatomic, assign) CGFloat keyboardViewHeight;

@property (nonatomic, assign) WLInputViewType textViewInputViewType;
@property (nonatomic, weak, readwrite) WLMessageTableView *messageTableView;
@property (nonatomic, weak, readwrite) WLMessageInputView *messageInputView;

@property (nonatomic, strong) UIView *headerContainerView;
@property (nonatomic, strong) UIActivityIndicatorView *loadMoreActivityIndicatorView;

//判断是不是超出了录音最大时长
@property (nonatomic) BOOL isMaxTimeStop;

#pragma mark - Init
//配置默认参数
- (void)setup;
//初始化显示控件
- (void)initUI;

#pragma mark - DataSource Change
/**
 *  改变数据源需要的子线程
 *
 *  @param queue 子线程执行完成的回调block
 */
- (void)exChangeMessageDataSourceQueue:(void (^)())queue;

/**
 *  执行块代码在主线程
 *
 *  @param queue 主线程执行完成回调block
 */
- (void)exMainQueue:(void (^)())queue;


@end

@implementation WLMessageTableViewController

#pragma mark - DataSource Change
- (void)exChangeMessageDataSourceQueue:(void (^)())queue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), queue);
}

- (void)exMainQueue:(void (^)())queue {
    dispatch_async(dispatch_get_main_queue(), queue);
}

- (void)addMessage:(WLMessage *)addedMessage {
    WEAKSELF
    [self exChangeMessageDataSourceQueue:^{
        NSMutableArray *messages = [NSMutableArray arrayWithArray:weakSelf.messages];
        [messages addObject:addedMessage];
        
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:1];
        [indexPaths addObject:[NSIndexPath indexPathForRow:messages.count - 1 inSection:0]];
        
        [weakSelf exMainQueue:^{
            weakSelf.messages = messages;
            [weakSelf.messageTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf scrollToBottomAnimated:YES];
        }];
    }];
}

- (void)removeMessageAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.messages.count)
        return;
    [self.messages removeObjectAtIndex:indexPath.row];
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:1];
    [indexPaths addObject:indexPath];
    
    [self.messageTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
}

static CGPoint  delayOffset = {0.0};
// http://stackoverflow.com/a/11602040 Keep UITableView static when inserting rows at the top
- (void)insertOldMessages:(NSArray *)oldMessages {
    WEAKSELF
    [self exChangeMessageDataSourceQueue:^{
        NSMutableArray *messages = [NSMutableArray arrayWithArray:oldMessages];
        [messages addObjectsFromArray:weakSelf.messages];
        
        delayOffset = weakSelf.messageTableView.contentOffset;
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:oldMessages.count];
        [oldMessages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [indexPaths addObject:indexPath];
            
            delayOffset.y += [weakSelf calculateCellHeightWithMessage:[messages objectAtIndex:idx] atIndexPath:indexPath];
        }];
        
        [weakSelf exMainQueue:^{
            [UIView setAnimationsEnabled:NO];
            [weakSelf.messageTableView beginUpdates];
            weakSelf.messages = messages;
            [weakSelf.messageTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//            delayOffset.y += 30;
            [weakSelf.messageTableView setContentOffset:delayOffset animated:NO];
            [weakSelf.messageTableView endUpdates];
            [UIView setAnimationsEnabled:YES];
            
        }];
    }];
}

#pragma mark - View Rotation
- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark - Messages View Controller
- (void)finishSendMessageWithBubbleMessageType:(WLBubbleMessageMediaType)mediaType {
    switch (mediaType) {
        case WLBubbleMessageMediaTypeActivity://活动
        case WLBubbleMessageMediaTypeText: {
            [self.messageInputView.inputTextView setText:nil];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                self.messageInputView.inputTextView.enablesReturnKeyAutomatically = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.messageInputView.inputTextView.enablesReturnKeyAutomatically = YES;
                    [self.messageInputView.inputTextView reloadInputViews];
                });
            }
            break;
        }
        case WLBubbleMessageMediaTypePhoto: {
            break;
        }
        case WLBubbleMessageMediaTypeVideo: {
            break;
        }
        case WLBubbleMessageMediaTypeVoice: {
            break;
        }
        case WLBubbleMessageMediaTypeEmotion: {
            break;
        }
        case WLBubbleMessageMediaTypeLocalPosition: {
            break;
        }
        default:
            break;
    }
}

- (void)setBackgroundColor:(UIColor *)color {
    self.view.backgroundColor = color;
    _messageTableView.backgroundColor = color;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    self.messageTableView.backgroundView = nil;
    self.messageTableView.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    if (![self shouldAllowScroll])
        return;
    
    NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
    
    if (rows > 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                     atScrollPosition:UITableViewScrollPositionBottom
                                             animated:animated];
    }
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
              atScrollPosition:(UITableViewScrollPosition)position
                      animated:(BOOL)animated {
    if (![self shouldAllowScroll])
        return;
    
    [self.messageTableView scrollToRowAtIndexPath:indexPath
                                 atScrollPosition:position
                                         animated:animated];
}

#pragma mark - Propertys
- (NSMutableArray *)messages {
    if (!_messages) {
        _messages = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _messages;
}

- (UIView *)headerContainerView {
    if (!_headerContainerView) {
        _headerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
        _headerContainerView.backgroundColor = self.messageTableView.backgroundColor;
        [_headerContainerView addSubview:self.loadMoreActivityIndicatorView];
    }
    return _headerContainerView;
}
- (UIActivityIndicatorView *)loadMoreActivityIndicatorView {
    if (!_loadMoreActivityIndicatorView) {
        _loadMoreActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadMoreActivityIndicatorView.center = CGPointMake(CGRectGetWidth(_headerContainerView.bounds) / 2.0, CGRectGetHeight(_headerContainerView.bounds) / 2.0);
    }
    return _loadMoreActivityIndicatorView;
}
- (void)setLoadingMoreMessage:(BOOL)loadingMoreMessage {
    _loadingMoreMessage = loadingMoreMessage;
    if (loadingMoreMessage) {
        [self.loadMoreActivityIndicatorView startAnimating];
    } else {
        [self.loadMoreActivityIndicatorView stopAnimating];
    }
}

//- (XHShareMenuView *)shareMenuView {
//    if (!_shareMenuView) {
//        XHShareMenuView *shareMenuView = [[XHShareMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), self.keyboardViewHeight)];
//        shareMenuView.delegate = self;
//        shareMenuView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
//        shareMenuView.alpha = 0.0;
//        shareMenuView.shareMenuItems = self.shareMenuItems;
//        [self.view addSubview:shareMenuView];
//        _shareMenuView = shareMenuView;
//    }
//    [self.view bringSubviewToFront:_shareMenuView];
//    return _shareMenuView;
//}
//
//- (XHEmotionManagerView *)emotionManagerView {
//    if (!_emotionManagerView) {
//        XHEmotionManagerView *emotionManagerView = [[XHEmotionManagerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), self.keyboardViewHeight)];
//        emotionManagerView.delegate = self;
//        emotionManagerView.dataSource = self;
//        emotionManagerView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
//        emotionManagerView.alpha = 0.0;
//        [self.view addSubview:emotionManagerView];
//        _emotionManagerView = emotionManagerView;
//    }
//    [self.view bringSubviewToFront:_emotionManagerView];
//    return _emotionManagerView;
//}
//
//- (XHVoiceRecordHUD *)voiceRecordHUD {
//    if (!_voiceRecordHUD) {
//        _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
//    }
//    return _voiceRecordHUD;
//}
//
//- (XHPhotographyHelper *)photographyHelper {
//    if (!_photographyHelper) {
//        _photographyHelper = [[XHPhotographyHelper alloc] init];
//    }
//    return _photographyHelper;
//}
//
//- (XHLocationHelper *)locationHelper {
//    if (!_locationHelper) {
//        _locationHelper = [[XHLocationHelper alloc] init];
//    }
//    return _locationHelper;
//}
//
//- (XHVoiceRecordHelper *)voiceRecordHelper {
//    if (!_voiceRecordHelper) {
//        _isMaxTimeStop = NO;
//        
//        WEAKSELF
//        _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
//        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
//            DLog(@"已经达到最大限制时间了，进入下一步的提示");
//            
//            // Unselect and unhilight the hold down button, and set isMaxTimeStop to YES.
//            UIButton *holdDown = weakSelf.messageInputView.holdDownButton;
//            holdDown.selected = NO;
//            holdDown.highlighted = NO;
//            weakSelf.isMaxTimeStop = YES;
//            
//            [weakSelf finishRecorded];
//        };
//        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
//            weakSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
//        };
//        _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
//    }
//    return _voiceRecordHelper;
//}

#pragma mark - Init
//初始化设置
- (void)setup{
    // iPhone or iPad keyboard view height set here.
    self.keyboardViewHeight = (kIsiPad ? 264 : 216);
    _allowsPanToDismissKeyboard = NO;
    _allowsSendVoice = YES;
    _allowsSendMultiMedia = YES;
    _allowsSendFace = YES;
    _inputViewStyle = WLMessageInputViewStyleFlat;
    
    self.delegate = self;
    self.dataSource = self;
    
    // 默认设置用户滚动为NO
    _isUserScrolling = NO;
}

- (id)init{
    self = [super init];
    if (self) {
        //初始化设置信息
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    //初始化设置信息
    [self setup];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化消息页面布局
    [self initUI];
    //设置字体大小
    [[WLMessageBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    [[WLMessageSpecialView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置键盘通知或者手势控制键盘消失
    [self.messageTableView setupPanGestureControlKeyboardHide:self.allowsPanToDismissKeyboard];
    
    // KVO 检查contentSize
    [self.messageInputView.inputTextView addObserver:self
                                          forKeyPath:@"contentSize"
                                             options:NSKeyValueObservingOptionNew
                                             context:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 取消输入框
    [self.messageInputView.inputTextView resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    // remove键盘通知或者手势
    [self.messageTableView disSetupPanGestureControlKeyboardHide:self.allowsPanToDismissKeyboard];
    
    // remove KVO
    [self.messageInputView.inputTextView removeObserver:self forKeyPath:@"contentSize"];
}

//初始化消息页面布局
- (void)initUI{
    //tableview头部距离问题
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //初始化TableView
    WLMessageTableView *messageTableView = [[WLMessageTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //设置宽高自适应
    messageTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //设置代理
    messageTableView.delegate = self;
    messageTableView.dataSource = self;
    //隐藏每个cell间的分割线
    messageTableView.separatorColor = [UIColor clearColor];
    messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    BOOL shouldLoadMoreMessagesScrollToTop = YES;
    if ([self.delegate respondsToSelector:@selector(shouldLoadMoreMessagesScrollToTop)]) {
        shouldLoadMoreMessagesScrollToTop = [self.delegate shouldLoadMoreMessagesScrollToTop];
    }
    if (shouldLoadMoreMessagesScrollToTop) {
        messageTableView.tableHeaderView = self.headerContainerView;
    }
    
    [self.view addSubview:messageTableView];
    [self.view sendSubviewToBack:messageTableView];
    _messageTableView = messageTableView;

    // 设置Message TableView 的bottom edg
    CGFloat inputViewHeight = (self.inputViewStyle == WLMessageInputViewStyleFlat) ? 45.0f : 40.0f;
    [self setTableViewInsetsWithBottomValue:inputViewHeight];
    
    // 设置整体背景颜色
    [self setBackgroundColor:[UIColor whiteColor]];
    
    // 输入工具条的frame
    CGRect inputFrame = CGRectMake(0.0f,
                                   self.view.frame.size.height - inputViewHeight,
                                   self.view.frame.size.width,
                                   inputViewHeight);
    
    WEAKSELF
    if (self.allowsPanToDismissKeyboard) {
        // 控制输入工具条的位置块
        void (^AnimationForMessageInputViewAtPoint)(CGPoint point) = ^(CGPoint point) {
            CGRect inputViewFrame = weakSelf.messageInputView.frame;
            CGPoint keyboardOrigin = [weakSelf.view convertPoint:point fromView:nil];
            inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
            weakSelf.messageInputView.frame = inputViewFrame;
        };
        
        self.messageTableView.keyboardDidScrollToPoint = ^(CGPoint point) {
            if (weakSelf.textViewInputViewType == WLInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        self.messageTableView.keyboardWillSnapBackToPoint = ^(CGPoint point) {
            if (weakSelf.textViewInputViewType == WLInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        self.messageTableView.keyboardWillBeDismissed = ^() {
            CGRect inputViewFrame = weakSelf.messageInputView.frame;
            inputViewFrame.origin.y = weakSelf.view.bounds.size.height - inputViewFrame.size.height;
            weakSelf.messageInputView.frame = inputViewFrame;
        };
    }
    
    // block回调键盘通知
    self.messageTableView.keyboardWillChange = ^(CGRect keyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyborad) {
        if (weakSelf.textViewInputViewType == WLInputViewTypeText) {
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options:options
                             animations:^{
                                 CGFloat keyboardY = [weakSelf.view convertRect:keyboardRect fromView:nil].origin.y;
                                 
                                 CGRect inputViewFrame = weakSelf.messageInputView.frame;
                                 CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                                 
                                 // for ipad modal form presentations
                                 CGFloat messageViewFrameBottom = weakSelf.view.frame.size.height - inputViewFrame.size.height;
                                 if (inputViewFrameY > messageViewFrameBottom)
                                     inputViewFrameY = messageViewFrameBottom;
                                 
                                 weakSelf.messageInputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                              inputViewFrameY,
                                                                              inputViewFrame.size.width,
                                                                              inputViewFrame.size.height);
                                 
                                 [weakSelf setTableViewInsetsWithBottomValue:weakSelf.view.frame.size.height
                                  - weakSelf.messageInputView.frame.origin.y];
                                 if (showKeyborad)
                                     [weakSelf scrollToBottomAnimated:NO];
                             }
                             completion:nil];
        }
    };
    
    self.messageTableView.keyboardDidChange = ^(BOOL didShowed) {
        if ([weakSelf.messageInputView.inputTextView isFirstResponder]) {
            if (didShowed) {
                if (weakSelf.textViewInputViewType == WLInputViewTypeText) {
//                    weakSelf.shareMenuView.alpha = 0.0;
//                    weakSelf.emotionManagerView.alpha = 0.0;
                }
            }
        }
    };
    
    self.messageTableView.keyboardDidHide = ^() {
        [weakSelf.messageInputView.inputTextView resignFirstResponder];
    };
    
    // 初始化输入工具条
    WLMessageInputView *inputView = [[WLMessageInputView alloc] initWithFrame:inputFrame];
    inputView.allowsSendFace = self.allowsSendFace;
    inputView.allowsSendVoice = self.allowsSendVoice;
    inputView.allowsSendMultiMedia = self.allowsSendMultiMedia;
    inputView.delegate = self;
    [self.view addSubview:inputView];
    [self.view bringSubviewToFront:inputView];
    
    _messageInputView = inputView;
    
    
    // 设置手势滑动，默认添加一个bar的高度值
    self.messageTableView.messageInputBarHeight = CGRectGetHeight(_messageInputView.bounds);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    _messages = nil;
//    _friendUser = nil;
    _delegate = nil;
    _dataSource = nil;
    _messageTableView.delegate = nil;
    _messageTableView.dataSource = nil;
    _messageTableView = nil;
    _messageInputView = nil;
    
//    _photographyHelper = nil;
//    _locationHelper = nil;
}

#pragma mark - RecorderPath Helper Method

//- (NSString *)getRecorderPath {
//    NSString *recorderPath = nil;
//    NSDate *now = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yy-MMMM-dd";
//    recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
//    //    dateFormatter.dateFormat = @"hh-mm-ss";
//    dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
//    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.caf", [dateFormatter stringFromDate:now]];
//    return recorderPath;
//}

#pragma mark - Voice Recording Helper Method
//- (void)prepareRecordWithCompletion:(XHPrepareRecorderCompletion)completion {
//    [self.voiceRecordHelper prepareRecordingWithPath:[self getRecorderPath] prepareRecorderCompletion:completion];
//}
//
//- (void)startRecord {
//    [self.voiceRecordHUD startRecordingHUDAtView:self.view];
//    [self.voiceRecordHelper startRecordingWithStartRecorderCompletion:^{
//    }];
//}
//
//- (void)finishRecorded {
//    WEAKSELF
//    [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
//        weakSelf.voiceRecordHUD = nil;
//    }];
//    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
//        [weakSelf didSendMessageWithVoice:weakSelf.voiceRecordHelper.recordPath voiceDuration:weakSelf.voiceRecordHelper.recordDuration];
//    }];
//}
//
//- (void)pauseRecord {
//    [self.voiceRecordHUD pauseRecord];
//}
//
//- (void)resumeRecord {
//    [self.voiceRecordHUD resaueRecord];
//}
//
//- (void)cancelRecord {
//    WEAKSELF
//    [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
//        weakSelf.voiceRecordHUD = nil;
//    }];
//    [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
//        
//    }];
//}

#pragma mark - XHMessageInputView Delegate
- (void)inputTextViewWillBeginEditing:(WLMessageTextView *)messageInputTextView {
    self.textViewInputViewType = WLInputViewTypeText;
}

- (void)inputTextViewDidBeginEditing:(WLMessageTextView *)messageInputTextView {
    if (!self.previousTextViewContentHeight)
        self.previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)didChangeSendVoiceAction:(BOOL)changed {
    if (changed) {
        if (self.textViewInputViewType == WLInputViewTypeText)
            return;
        // 在这之前，textViewInputViewType已经不是XHTextViewTextInputType
        [self layoutOtherMenuViewHiden:YES];
    }
}

- (void)didSendTextAction:(NSString *)text {
    DLog(@"text : %@", text);
    if ([self.delegate respondsToSelector:@selector(didSendText:fromSender:onDate:)]) {
        [self.delegate didSendText:text fromSender:self.messageSender onDate:[NSDate date]];
    }
}

- (void)didSelectedMultipleMediaAction {
    DLog(@"didSelectedMultipleMediaAction");
    self.textViewInputViewType = WLInputViewTypeShareMenu;
    [self layoutOtherMenuViewHiden:NO];
}

- (void)didSendFaceAction:(BOOL)sendFace {
    if (sendFace) {
        self.textViewInputViewType = WLInputViewTypeEmotion;
        [self layoutOtherMenuViewHiden:NO];
    } else {
        [self.messageInputView.inputTextView becomeFirstResponder];
    }
}

- (void)prepareRecordingVoiceActionWithCompletion:(BOOL (^)(void))completion {
    DLog(@"prepareRecordingWithCompletion");
//    [self prepareRecordWithCompletion:completion];
}

- (void)didStartRecordingVoiceAction {
    DLog(@"didStartRecordingVoice");
//    [self startRecord];
}

- (void)didCancelRecordingVoiceAction {
    DLog(@"didCancelRecordingVoice");
//    [self cancelRecord];
}

- (void)didFinishRecoingVoiceAction {
    DLog(@"didFinishRecoingVoice");
    if (self.isMaxTimeStop == NO) {
//        [self finishRecorded];
    } else {
        self.isMaxTimeStop = NO;
    }
}

- (void)didDragOutsideAction {
    DLog(@"didDragOutsideAction");
//    [self resumeRecord];
}

- (void)didDragInsideAction {
    DLog(@"didDragInsideAction");
//    [self pauseRecord];
}

#pragma mark - XHMessageTableViewController DataSource
- (id <WLMessageModel>)messageForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.messages[indexPath.row];
}

#pragma mark - TableView DataSource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id <WLMessageModel> message = [self.dataSource messageForRowAtIndexPath:indexPath];
    
    BOOL displayTimestamp = YES;
    if ([self.delegate respondsToSelector:@selector(shouldDisplayTimestampForRowAtIndexPath:)]) {
        displayTimestamp = [self.delegate shouldDisplayTimestampForRowAtIndexPath:indexPath];
    }
    
    static NSString *cellIdentifier = @"WLMessageTableViewCell";
    
    WLMessageTableViewCell *messageTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!messageTableViewCell) {
        messageTableViewCell = [[WLMessageTableViewCell alloc] initWithMessage:message displaysTimestamp:displayTimestamp reuseIdentifier:cellIdentifier];
        messageTableViewCell.delegate = self;
    }
    
    messageTableViewCell.indexPath = indexPath;
    messageTableViewCell.displayTimestamp = displayTimestamp;
    messageTableViewCell.message = message;
//    [messageTableViewCell configureCellWithMessage:message displaysTimestamp:displayTimestamp];
    [messageTableViewCell setBackgroundColor:tableView.backgroundColor];
    
    if ([self.delegate respondsToSelector:@selector(configureCell:atIndexPath:)]) {
        [self.delegate configureCell:messageTableViewCell atIndexPath:indexPath];
    }
//    [messageTableViewCell setDebug:YES];
    return messageTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"-------didSelectRowAtIndexPath >>>>>>");
}

#pragma mark - Table View Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id <WLMessageModel> message = [self.dataSource messageForRowAtIndexPath:indexPath];
    return [self calculateCellHeightWithMessage:message atIndexPath:indexPath];
}

#pragma mark - Message Calculate Cell Height
- (CGFloat)calculateCellHeightWithMessage:(id <WLMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 0;
    
    BOOL displayTimestamp = YES;
    if ([self.delegate respondsToSelector:@selector(shouldDisplayTimestampForRowAtIndexPath:)]) {
        displayTimestamp = [self.delegate shouldDisplayTimestampForRowAtIndexPath:indexPath];
    }
    
    cellHeight = [WLMessageTableViewCell calculateCellHeightWithMessage:message displaysTimestamp:displayTimestamp];
    
    return cellHeight;
}

#pragma mark - Previte Method
- (BOOL)shouldAllowScroll {
    if (self.isUserScrolling) {
        if ([self.delegate respondsToSelector:@selector(shouldPreventScrollToBottomWhileUserScrolling)]
            && [self.delegate shouldPreventScrollToBottomWhileUserScrolling]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Scroll Message TableView Helper Method
- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.messageTableView.contentInset = insets;
    self.messageTableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        insets.top = 44;
//        insets.top = 20;
    }
    
    insets.bottom = bottom;
    
    return insets;
}


#pragma mark - UITextView Helper Method
- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - Layout Message Input View Helper Method
- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
    CGFloat maxHeight = [WLMessageInputView maxHeight];
    
    CGFloat contentH = [self getTextViewContentH:textView];
    
    BOOL isShrinking = contentH < self.previousTextViewContentHeight;
    CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
    
    if (!isShrinking && (self.previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self setTableViewInsetsWithBottomValue:self.messageTableView.contentInset.bottom + changeInHeight];
                             
                             [self scrollToBottomAnimated:NO];
                             
                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.messageInputView.frame;
                             self.messageInputView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             if (!isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        self.previousTextViewContentHeight = MIN(contentH, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

#pragma mark - Message Send helper Method

- (void)didSendMessageWithText:(NSString *)text {
    DLog(@"send text : %@", text);
    if ([self.delegate respondsToSelector:@selector(didSendText:fromSender:onDate:)]) {
        [self.delegate didSendText:text fromSender:self.messageSender onDate:[NSDate date]];
    }
}

//- (void)didSendMessageWithPhoto:(UIImage *)photo {
//    DLog(@"send photo : %@", photo);
//    if ([self.delegate respondsToSelector:@selector(didSendPhoto:fromSender:onDate:)]) {
//        [self.delegate didSendPhoto:photo fromSender:self.messageSender onDate:[NSDate date]];
//    }
//}
//
//- (void)didSendMessageWithVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath  {
//    DLog(@"send videoPath : %@  videoConverPhoto : %@", videoPath, videoConverPhoto);
//    if ([self.delegate respondsToSelector:@selector(didSendVideoConverPhoto:videoPath:fromSender:onDate:)]) {
//        [self.delegate didSendVideoConverPhoto:videoConverPhoto videoPath:videoPath fromSender:self.messageSender onDate:[NSDate date]];
//    }
//}
//
//- (void)didSendMessageWithVoice:(NSString *)voicePath voiceDuration:(NSString*)voiceDuration {
//    DLog(@"send voicePath : %@", voicePath);
//    if ([self.delegate respondsToSelector:@selector(didSendVoice:voiceDuration:fromSender:onDate:)]) {
//        [self.delegate didSendVoice:voicePath voiceDuration:voiceDuration fromSender:self.messageSender onDate:[NSDate date]];
//    }
//}
//
//- (void)didSendEmotionMessageWithEmotionPath:(NSString *)emotionPath {
//    DLog(@"send emotionPath : %@", emotionPath);
//    if ([self.delegate respondsToSelector:@selector(didSendEmotion:fromSender:onDate:)]) {
//        [self.delegate didSendEmotion:emotionPath fromSender:self.messageSender onDate:[NSDate date]];
//    }
//}
//
//- (void)didSendGeolocationsMessageWithGeolocaltions:(NSString *)geolcations location:(CLLocation *)location {
//    DLog(@"send geolcations : %@", geolcations);
//    if ([self.delegate respondsToSelector:@selector(didSendGeoLocationsPhoto:geolocations:location:fromSender:onDate:)]) {
//        [self.delegate didSendGeoLocationsPhoto:[UIImage imageNamed:@"Fav_Cell_Loc"] geolocations:geolcations location:location fromSender:self.messageSender onDate:[NSDate date]];
//    }
//}

#pragma mark - XHShareMenuView Delegate
//
//- (void)didSelecteShareMenuItem:(XHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index {
//    DLog(@"title : %@   index:%ld", shareMenuItem.title, (long)index);
//    
//    WEAKSELF
//    void (^PickerMediaBlock)(UIImage *image, NSDictionary *editingInfo) = ^(UIImage *image, NSDictionary *editingInfo) {
//        if (image) {
//            [weakSelf didSendMessageWithPhoto:image];
//        } else {
//            if (!editingInfo)
//                return ;
//            NSString *mediaType = [editingInfo objectForKey: UIImagePickerControllerMediaType];
//            NSString *videoPath;
//            NSURL *videoUrl;
//            if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
//                videoUrl = (NSURL*)[editingInfo objectForKey:UIImagePickerControllerMediaURL];
//                videoPath = [videoUrl path];
//                
//                UIImage *thumbnailImage = [XHMessageVideoConverPhotoFactory videoConverPhotoWithVideoPath:videoPath];
//                
//                [weakSelf didSendMessageWithVideoConverPhoto:thumbnailImage videoPath:videoPath];
//            } else {
//                [weakSelf didSendMessageWithPhoto:[editingInfo valueForKey:UIImagePickerControllerOriginalImage]];
//            }
//        }
//    };
//    switch (index) {
//        case 0: {
//            [self.photographyHelper showOnPickerViewControllerSourceType:UIImagePickerControllerSourceTypePhotoLibrary onViewController:self compled:PickerMediaBlock];
//            break;
//        }
//        case 1: {
//            [self.photographyHelper showOnPickerViewControllerSourceType:UIImagePickerControllerSourceTypeCamera onViewController:self compled:PickerMediaBlock];
//            break;
//        }
//        case 2: {
//            WEAKSELF
//            [self.locationHelper getCurrentGeolocationsCompled:^(NSArray *placemarks) {
//                CLPlacemark *placemark = [placemarks lastObject];
//                if (placemark) {
//                    NSDictionary *addressDictionary = placemark.addressDictionary;
//                    NSArray *formattedAddressLines = [addressDictionary valueForKey:@"FormattedAddressLines"];
//                    NSString *geoLocations = [formattedAddressLines lastObject];
//                    if (geoLocations) {
//                        [weakSelf didSendGeolocationsMessageWithGeolocaltions:geoLocations location:placemark.location];
//                    }
//                }
//            }];
//            break;
//        }
//        default:
//            break;
//    }
//}

#pragma mark - XHEmotionManagerView Delegate
//- (void)didSelecteEmotion:(XHEmotion *)emotion atIndexPath:(NSIndexPath *)indexPath {
//    if (emotion.emotionPath) {
//        [self didSendEmotionMessageWithEmotionPath:emotion.emotionPath];
//    }
//}
//
//#pragma mark - XHEmotionManagerView DataSource
//
//- (NSInteger)numberOfEmotionManagers {
//    return 0;
//}
//
//- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column {
//    return nil;
//}
//
//- (NSArray *)emotionManagersAtManager {
//    return nil;
//}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(shouldLoadMoreMessagesScrollToTop)]) {
        BOOL shouldLoadMoreMessages = [self.delegate shouldLoadMoreMessagesScrollToTop];
        if (shouldLoadMoreMessages) {
            if (scrollView.contentOffset.y >=0 && scrollView.contentOffset.y <= 44) {
                if (!self.loadingMoreMessage) {
                    if ([self.delegate respondsToSelector:@selector(loadMoreMessagesScrollTotop)]) {
                        [self.delegate loadMoreMessagesScrollTotop];
                    }
                }
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isUserScrolling = YES;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
    
    if (self.textViewInputViewType != WLInputViewTypeNormal) {
        [self layoutOtherMenuViewHiden:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.isUserScrolling = NO;
}

#pragma mark - XHMessageTableViewController Delegate
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

#pragma mark - Key-value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.messageInputView.inputTextView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
}

#pragma mark - Other Menu View Frame Helper Mehtod

- (void)layoutOtherMenuViewHiden:(BOOL)hide {
    [self.messageInputView.inputTextView resignFirstResponder];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        __block CGRect inputViewFrame = self.messageInputView.frame;
        __block CGRect otherMenuViewFrame;
        
        void (^InputViewAnimation)(BOOL hide) = ^(BOOL hide) {
            inputViewFrame.origin.y = (hide ? (CGRectGetHeight(self.view.bounds) - CGRectGetHeight(inputViewFrame)) : (CGRectGetMinY(otherMenuViewFrame) - CGRectGetHeight(inputViewFrame)));
            self.messageInputView.frame = inputViewFrame;
        };
        
        void (^EmotionManagerViewAnimation)(BOOL hide) = ^(BOOL hide) {
//            otherMenuViewFrame = self.emotionManagerView.frame;
//            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
//            self.emotionManagerView.alpha = !hide;
//            self.emotionManagerView.frame = otherMenuViewFrame;
        };
        
        void (^ShareMenuViewAnimation)(BOOL hide) = ^(BOOL hide) {
//            otherMenuViewFrame = self.shareMenuView.frame;
//            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
//            self.shareMenuView.alpha = !hide;
//            self.shareMenuView.frame = otherMenuViewFrame;
        };
        
        if (hide) {
            switch (self.textViewInputViewType) {
                case WLInputViewTypeEmotion: {
                    EmotionManagerViewAnimation(hide);
                    break;
                }
                case WLInputViewTypeShareMenu: {
                    ShareMenuViewAnimation(hide);
                    break;
                }
                default:
                    break;
            }
        } else {
            
            // 这里需要注意block的执行顺序，因为otherMenuViewFrame是公用的对象，所以对于被隐藏的Menu的frame的origin的y会是最大值
            switch (self.textViewInputViewType) {
                case WLInputViewTypeEmotion: {
                    // 1、先隐藏和自己无关的View
                    ShareMenuViewAnimation(!hide);
                    // 2、再显示和自己相关的View
                    EmotionManagerViewAnimation(hide);
                    break;
                }
                case WLInputViewTypeShareMenu: {
                    // 1、先隐藏和自己无关的View
                    EmotionManagerViewAnimation(!hide);
                    // 2、再显示和自己相关的View
                    ShareMenuViewAnimation(hide);
                    break;
                }
                default:
                    break;
            }
        }
        
        InputViewAnimation(hide);
        
        [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
         - self.messageInputView.frame.origin.y];
        
        [self scrollToBottomAnimated:NO];
    } completion:^(BOOL finished) {
        
    }];
}

@end
