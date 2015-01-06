//
//  ChatViewController.m
//  Welian
//
//  Created by weLian on 14/12/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) MyFriendUser *friendUser;

@end

@implementation ChatViewController

- (WLMessage *)getTextMessageWithBubbleMessageType:(WLBubbleMessageType)bubbleMessageType {
    WLMessage *textMessage = [[WLMessage alloc] initWithText:@"Call Me 15915895880. 这是华捷微信，为什么模仿这个页面效果呢？希望微信团队能看到我们在努力，请微信团队给个机会，让我好好的努力靠近大神，希望自己也能发亮，好像有点过分的希望了，如果大家喜欢这个开源库，请大家帮帮忙支持这个开源库吧！我是Jack，叫华仔也行，曾宪华就是我啦！" sender:[LogInUser getNowLogInUser].name timestamp:[NSDate distantPast]];
    textMessage.avator = [UIImage imageNamed:@"avator"];
    textMessage.sended = YES;
    textMessage.avatorUrl = [LogInUser getNowLogInUser].avatar;// @"http://www.pailixiu.com/jack/meIcon@2x.png";
    textMessage.bubbleMessageType = bubbleMessageType;
    
    return textMessage;
}

- (NSMutableArray *)getTestMessages {
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 10; i ++) {
//        [messages addObject:[self getPhotoMessageWithBubbleMessageType:(i % 5) ? WLBubbleMessageTypeSending : WLBubbleMessageTypeReceiving]];
        
//        [messages addObject:[self getVideoMessageWithBubbleMessageType:(i % 6) ? XHBubbleMessageTypeSending : XHBubbleMessageTypeReceiving]];
//        
//        [messages addObject:[self getVoiceMessageWithBubbleMessageType:(i % 4) ? XHBubbleMessageTypeSending : XHBubbleMessageTypeReceiving]];
//        
//        [messages addObject:[self getEmotionMessageWithBubbleMessageType:(i % 2) ? XHBubbleMessageTypeSending : XHBubbleMessageTypeReceiving]];
//        
//        [messages addObject:[self getGeolocationsMessageWithBubbleMessageType:(i % 7) ? XHBubbleMessageTypeSending : XHBubbleMessageTypeReceiving]];
//        
        [messages addObject:[self getTextMessageWithBubbleMessageType:(i % 2) ? WLBubbleMessageTypeSending : WLBubbleMessageTypeReceiving]];
    }
    return messages;
}

- (void)loadDemoDataSource {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *messages = [weakSelf getTestMessages];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.messages = messages;
            [weakSelf.messageTableView reloadData];
            
            [weakSelf scrollToBottomAnimated:NO];
        });
    });
}

- (id)initWithUser:(MyFriendUser *)friendUser
{
    self = [super init];
    if (self) {
        // 配置输入框UI的样式
        self.allowsSendVoice = NO;
        self.allowsSendFace = NO;
        self.allowsSendMultiMedia = NO;
        
        self.friendUser = friendUser;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //自定义返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"消息" style:UIBarButtonItemStyleBordered target:self action:@selector(backItemClicked:)];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //只有在二级页面生效
        if ([self.navigationController.viewControllers count] > 1) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //代理置空，否则会闪退
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)backItemClicked:(UIBarButtonItem *)item
{
    DLog(@"backItemClicked ");
    if(_isFromUserInfo){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _friendUser.name;
    
    // 设置整体背景颜色
    [self setBackgroundColor:RGB(236.f, 238.f, 241.f)];
    
    //加载初始化数据
    [self loadDemoDataSource];
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //开启滑动手势
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

//发送消息
- (void)sendMessage:(WLMessage *)message
{
    NSDictionary *param = @{@"type":@(WLBubbleMessageMediaTypeText),@"msg":message.text,@"touser":@(10019)};
    [WLHttpTool sendMessageParameterDic:param
                                success:^(id JSON) {
                                    
                                } fail:^(NSError *error) {
                                    
                                }];
}

/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    WLMessage *textMessage = [[WLMessage alloc] initWithText:text sender:sender timestamp:date];
    textMessage.avator = [UIImage imageNamed:@"avator"];
    textMessage.avatorUrl = [LogInUser getNowLogInUser].avatar;//@"http://www.pailixiu.com/jack/meIcon@2x.png";
    textMessage.sender = [LogInUser getNowLogInUser].name;
    //是否读取
    textMessage.isRead = YES;
    textMessage.sended = NO;
    
    //更新聊天好友
    [_friendUser updateIsChatStatus:YES];
    
    [self addMessage:textMessage];
    [self sendMessage:textMessage];
    [self finishSendMessageWithBubbleMessageType:WLBubbleMessageMediaTypeText];
}

/**
 *  是否显示时间轴Label的回调方法
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 5 == 0)
        return YES;
    else
        return NO;
}


/**
 *  配置Cell的样式或者字体
 *
 *  @param cell      目标Cell
 *  @param indexPath 目标Cell所在位置IndexPath
 */
- (void)configureCell:(WLMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}

/**
 *  协议回掉是否支持用户手动滚动
 *
 *  @return 返回YES or NO
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

@end
