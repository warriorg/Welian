//
//  ChatViewController.m
//  Welian
//
//  Created by weLian on 14/12/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatMessage.h"
#import "UserInfoBasicVC.h"
#import "FriendsUserModel.h"
#import "TOWebViewController.h"
#import "ActivityDetailViewController.h"
#import "WLDisplayMediaViewController.h"
#import "WLPhotoView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface ChatViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

//聊天的好友
@property (nonatomic, strong) MyFriendUser *friendUser;
@property (nonatomic, strong) NSMutableArray *localMessages;//本地数据库数据
//@property (nonatomic, assign) NSInteger totalOffset;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger count;

@end

@implementation ChatViewController

- (void)dealloc
{
    _friendUser = nil;
    _localMessages = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadDemoDataSource {
    //获取数据
    NSArray *localMessages = [_friendUser getChatMessagesWithOffset:_offset count:_count];
    self.localMessages = [NSMutableArray arrayWithArray:localMessages];
    
    WEAKSELF
    [self exChangeMessageDataSourceQueue:^{
        NSMutableArray *messages = [NSMutableArray array];
        for (ChatMessage *chatMessage in localMessages) {
            WLMessage *message = nil;
            switch (chatMessage.messageType.integerValue) {
                case WLBubbleMessageSpecialTypeText:
                    //特殊文本
                    message = [[WLMessage alloc] initWithSpecialText:chatMessage.message sender:chatMessage.sender timestamp:chatMessage.timestamp];
                    message.msgId = chatMessage.msgId.stringValue;
                    message.avatorUrl = chatMessage.avatorUrl;
                    message.sended = chatMessage.sendStatus.stringValue;
                    message.bubbleMessageType = chatMessage.bubbleMessageType.integerValue;
                    message.uid = _friendUser.uid.stringValue;
                    break;
                case WLBubbleMessageMediaTypeActivity://活动
                case WLBubbleMessageMediaTypeText:
                    //普通文本
                    message = [[WLMessage alloc] initWithText:chatMessage.message sender:chatMessage.sender timestamp:chatMessage.timestamp];
                    message.msgId = chatMessage.msgId.stringValue;
                    message.avatorUrl = chatMessage.avatorUrl;
                    message.sended = chatMessage.sendStatus.stringValue;
                    message.bubbleMessageType = chatMessage.bubbleMessageType.integerValue;
                    message.uid = _friendUser.uid.stringValue;
                    break;
                case WLBubbleMessageMediaTypePhoto:
                {
                    //照片
                    message = [[WLMessage alloc] initWithPhoto:[ResManager imageWithPath:chatMessage.thumbnailUrl]
                                                  thumbnailUrl:chatMessage.thumbnailUrl
                                                originPhotoUrl:chatMessage.originPhotoUrl
                                                        sender:chatMessage.sender
                                                     timestamp:chatMessage.timestamp];
                    message.avatorUrl = chatMessage.avatorUrl;
                    message.sended = chatMessage.sendStatus.stringValue;
                    message.bubbleMessageType = chatMessage.bubbleMessageType.integerValue;
                    message.uid = _friendUser.uid.stringValue;
                    message.msgId = chatMessage.msgId.stringValue;
                }
                    break;
                default:
                    break;
            }
            //添加到数组中
            if (message) {
                [messages addObject:message];
            }
        }
        
        [weakSelf exMainQueue:^{
            weakSelf.messages = messages;
            [weakSelf.messageTableView reloadData];
            [weakSelf scrollToBottomAnimated:NO];
            
            //重新发送
            [self loadReSendMsg];
        }];
    }];
}

//重新发送所有待发送的消息
- (void)loadReSendMsg{
    for (int i = 0; i < self.messages.count;i++) {
        WLMessage *msg = self.messages[i];
        if (msg.sended.intValue == 0 && msg.bubbleMessageType == WLBubbleMessageTypeSending) {
            //重新发送消息
            [self sendMessage:msg withIndexPath:[NSMutableArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]]];
        }
    }
}

- (id)initWithUser:(MyFriendUser *)friendUser
{
    self = [super init];
    if (self) {
        // 配置输入框UI的样式
        self.allowsSendVoice = NO;
        self.allowsSendFace = NO;
        self.allowsSendMultiMedia = YES;
        
        self.friendUser = friendUser;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //取消接口调用
//    [WLHttpTool cancelAllRequestHttpTool];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _friendUser.name;
    
    // 设置整体背景颜色
    [self setBackgroundColor:RGB(236.f, 238.f, 241.f)];
    
    //设置聊天布局
    [self setNormalInfo];
    
    //更新当前未查看消息数量
    [_friendUser updateUnReadMessageNumber:@(0)];
    
    //初始化数据查询
    self.count = 15;
    if (_friendUser.rsChatMessages.count > _count) {
        self.offset = _friendUser.rsChatMessages.count - _count;
    }else{
        self.offset = 0;
        self.count = _friendUser.rsChatMessages.count;
    }
    
    //加载初始化数据
    [self loadDemoDataSource];
    
    //添加新消息监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewChatMessage:) name:[NSString stringWithFormat:@"ReceiveNewChatMessage%@",_friendUser.uid.stringValue] object:nil];
    
}

- (void)setNormalInfo
{
    // 添加第三方接入数据
    NSMutableArray *shareMenuItems = [NSMutableArray array];
    //, @"me_circle_chat_location", @"me_circle_chat_card"
    NSArray *plugIcons = @[@"me_circle_chat_picture", @"me_circle_chat_camera"];
    //, @"位置", @"名片"
    NSArray *plugTitle = @[@"照片", @"拍摄"];
//    NSArray *plugIcons = @[@"sharemore_pic", @"sharemore_video", @"sharemore_location", @"sharemore_friendcard", @"sharemore_myfav", @"sharemore_wxtalk", @"sharemore_videovoip", @"sharemore_voiceinput", @"sharemore_openapi", @"sharemore_openapi", @"avatar"];
//    NSArray *plugTitle = @[@"照片", @"拍摄", @"位置", @"名片", @"我的收藏", @"实时对讲机", @"视频聊天", @"语音输入", @"大众点评", @"应用", @"曾宪华"];
    for (NSString *plugIcon in plugIcons) {
        WLShareMenuItem *shareMenuItem = [[WLShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
        [shareMenuItems addObject:shareMenuItem];
    }
    self.shareMenuItems = shareMenuItems;
    [self.shareMenuView reloadData];
}

//刷新获取新的消息
- (void)receiveNewChatMessage:(NSNotification *)notification
{
    //更新当前未查看消息数量
    [_friendUser updateUnReadMessageNumber:@(0)];
    
    NSString *msgId = [[notification userInfo] objectForKey:@"msgId"];
    
    ChatMessage *chatMessage = [_friendUser getChatMessageWithMsgId:msgId];
    //添加数据
    [_localMessages addObject:chatMessage];
//    [chatMessage updateReSendStatus];
    
    //普通文本
    WLMessage *message = nil;
    switch (chatMessage.messageType.integerValue) {
        case WLBubbleMessageMediaTypeActivity://活动
        case WLBubbleMessageMediaTypeText:
            message = [[WLMessage alloc] initWithText:chatMessage.message sender:chatMessage.sender timestamp:chatMessage.timestamp];
            //                    message.avator = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[LogInUser getCurrentLoginUser].avatar]]];
            message.avatorUrl = chatMessage.avatorUrl;
            message.sended = chatMessage.sendStatus.stringValue;
            message.bubbleMessageType = chatMessage.bubbleMessageType.integerValue;
            message.uid = _friendUser.uid.stringValue;
            message.msgId = chatMessage.msgId.stringValue;
            break;
        case WLBubbleMessageMediaTypePhoto:
        {
            //照片
            message = [[WLMessage alloc] initWithPhoto:[ResManager imageWithPath:chatMessage.thumbnailUrl]
                                          thumbnailUrl:chatMessage.thumbnailUrl
                                        originPhotoUrl:chatMessage.originPhotoUrl
                                                sender:chatMessage.sender
                                             timestamp:chatMessage.timestamp];
            message.avatorUrl = chatMessage.avatorUrl;
            message.sended = chatMessage.sendStatus.stringValue;
            message.bubbleMessageType = chatMessage.bubbleMessageType.integerValue;
            message.uid = _friendUser.uid.stringValue;
            message.msgId = chatMessage.msgId.stringValue;
        }
            break;
        default:
            break;
    }
    //在底部添加消息
    [self addMessage:message needSend:NO];
}

//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    //开启滑动手势
//    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//}

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

- (void)addMessage:(WLMessage *)addedMessage needSend:(BOOL)needSend{
    WEAKSELF
    [self exChangeMessageDataSourceQueue:^{
        NSMutableArray *messages = [NSMutableArray arrayWithArray:self.messages];
        [messages addObject:addedMessage];
        
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:1];
        [indexPaths addObject:[NSIndexPath indexPathForRow:messages.count - 1 inSection:0]];
        
        if (needSend) {
            //发送消息
            [self sendMessage:addedMessage withIndexPath:indexPaths];
        }
        [weakSelf exMainQueue:^{
            weakSelf.messages = messages;
            [weakSelf.messageTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf scrollToBottomAnimated:YES];
        }];
    }];
}

//发送消息
- (void)sendMessage:(WLMessage *)message withIndexPath:(NSMutableArray *)indexPaths
{
    NSDictionary *param = [NSDictionary dictionary];
    switch (message.messageMediaType) {
        case WLBubbleMessageMediaTypeText:
            param = @{@"type":@(message.messageMediaType),@"msg":message.text,@"touser":message.uid};
            break;
        case WLBubbleMessageMediaTypePhoto:
        {
            NSString *avatarStr = [UIImageJPEGRepresentation(message.photo, 0.05) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            param = @{@"type":@(message.messageMediaType),@"msg":avatarStr,@"touser":message.uid,@"title":@"jpg"};
        }
            break;
        case WLBubbleMessageMediaTypeVoice:
            
            break;
        case WLBubbleMessageMediaTypeVideo:
            
            break;
        case WLBubbleMessageMediaTypeEmotion:
            
            break;
        case WLBubbleMessageMediaTypeLocalPosition:
            
            break;
        case WLBubbleMessageMediaTypeActivity:
            
            break;
        case WLBubbleMessageSpecialTypeText:
            
            break;
            
        default:
            break;
    }
    NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
    //获取数据库中发送的消息对象
    ChatMessage *chatMessage = _localMessages[indexPath.row];// [_friendUser getChatMessageWithMsgId:msg.msgId];
    
    [WLHttpTool sendMessageParameterDic:param
                                success:^(id JSON) {
                                    //返回的是字典
                                    NSString *state = JSON[@"state"];
                                    NSString *time = JSON[@"created"];
                                    if ([state intValue] == -1) {
                                        //更新数据库
                                        [chatMessage updateSendStatus:2];
                                        //更新发送时间
                                        if (time) {
                                            [chatMessage updateTimeStampFromServer:time];
                                        }
                                        
                                        WLMessage *msg = self.messages[indexPath.row];
                                        //更新发送消息状态
                                        msg.sended = @"2";
                                        
                                        //替换原有数据
                                        [self.messages replaceObjectAtIndex:indexPath.row withObject:msg];
                                        
                                        //已经不是好友关系
                                        //添加特殊消息
                                        [self addSpecelMessage];
                                        
                                        //刷新列表
                                        WEAKSELF
                                        [weakSelf exMainQueue:^{
//                                                weakSelf.messages = messages;
                                            //刷新列表
                                            [weakSelf.messageTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                                            [weakSelf scrollToBottomAnimated:YES];
                                            
                                        }];
                                    }else{
                                        //更新发送状态
                                        [chatMessage updateSendStatus:1];
                                        //更新发送时间
                                        if (time) {
                                            [chatMessage updateTimeStampFromServer:time];
                                        }
                                        
                                        WLMessage *msg = self.messages[indexPath.row];
                                        //更新发送消息状态
                                        msg.sended = @"1";
                                        
                                        //替换原有数据
                                        [self.messages replaceObjectAtIndex:indexPath.row withObject:msg];
//                                        [self.messages removeObjectAtIndex:indexPath.row];
//                                        [self.messages insertObject:msg atIndex:indexPath.row];
                                        
                                        WEAKSELF
                                        [weakSelf exMainQueue:^{
                                            //刷新列表
                                            [weakSelf.messageTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                                            [weakSelf scrollToBottomAnimated:YES];
                                        }];
                                    }
                                } fail:^(NSError *error) {
                                    //发送失败
                                    //更新数据库
                                    [chatMessage updateSendStatus:2];
                                    
                                    WLMessage *msg = self.messages[indexPath.row];
                                    //更新发送消息状态
                                    msg.sended = @"2";
                                    
                                    //替换原有数据
                                    [self.messages replaceObjectAtIndex:indexPath.row withObject:msg];
                                    
//                                    [self.messages removeObjectAtIndex:indexPath.row];
//                                    [self.messages insertObject:msg atIndex:indexPath.row];
                                    
                                    [self exMainQueue:^{
//                                        weakSelf.messages = weakSelf.messages;
                                        //刷新列表
                                        [self.messageTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                                        [self scrollToBottomAnimated:YES];
                                    }];
                                }];
}

//添加特殊类型
- (void)addSpecelMessage
{
    [self exMainQueue:^{
        //已经不是好友关系
        WLMessage *textMessage = [[WLMessage alloc] initWithSpecialText:[NSString stringWithFormat:@"你和%@已经不是好友关系，请先发送好友请求，对方通过验证后，才能聊天。&sendAddFriend",_friendUser.name] sender:@"" timestamp:[NSDate date]];
        textMessage.avatorUrl = [LogInUser getCurrentLoginUser].avatar;//@"http://www.pailixiu.com/jack/meIcon@2x.png";
        textMessage.sender = [LogInUser getCurrentLoginUser].name;
        textMessage.uid = _friendUser.uid.stringValue;
        //是否读取
        textMessage.isRead = YES;
        textMessage.sended = @"1";
        textMessage.bubbleMessageType = WLBubbleMessageTypeSpecial;
        
        //    //本地聊天数据库添加
        ChatMessage *chatMessage = [ChatMessage createSpecialMessageWithMessage:textMessage FriendUser:_friendUser];
        textMessage.msgId = chatMessage.msgId.stringValue;
        
        //添加数据
//        [self addMessage:textMessage];
        
        [_localMessages addObject:chatMessage];
        
//        NSMutableArray *messages = [NSMutableArray arrayWithArray:self.messages];
//        [messages addObject:textMessage];
//    
//        NSMutableArray *newindexPaths = [NSMutableArray arrayWithCapacity:1];
//        [newindexPaths addObject:[NSIndexPath indexPathForRow:messages.count - 1 inSection:0]];
//    
//        //刷新列表
//        [self.messageTableView reloadRowsAtIndexPaths:newindexPaths withRowAnimation:UITableViewRowAnimationNone];
//        [self scrollToBottomAnimated:YES];
        
        //添加这条数据，不需要发送
        [self addMessage:textMessage needSend:YES];
    }];
    
}

//发送消息
//- (void)sendMessage:(id<WLMessageModel>)message rowIndexPath:(NSIndexPath *)indexPath
//{
//
//    NSDictionary *param = @{@"type":@(message.messageMediaType),@"msg":message.text,@"touser":message.uid};
//    ChatMessage *chatMessage = [_friendUser getChatMessageWithMsgId:message.msgId];
//    WEAKSELF;
//    [WLHttpTool sendMessageParameterDic:param
//                                success:^(id JSON) {
//                                    WLMessage *msg = self.messages[indexPath.row];
//                                    //更新发送消息状态
//                                    msg.sended = 1;
//
//                                    [self.messages removeObjectAtIndex:indexPath.row];
//                                    [self.messages insertObject:msg atIndex:indexPath.row];
//
//                                    //更新数据库字段
//                                    [chatMessage updateSendStatus:1];
//
//                                    //刷新行
//                                    [weakSelf.messageTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                                } fail:^(NSError *error) {
//                                    WLMessage *msg = self.messages[indexPath.row];
//                                    //更新发送消息状态
//                                    msg.sended = 2;
//                                    
//                                    [self.messages removeObjectAtIndex:indexPath.row];
//                                    [self.messages insertObject:msg atIndex:indexPath.row];
//                                    //发送失败
//                                    //                                    message.sended = 2;
//                                    //更新数据库字段
//                                    [chatMessage updateSendStatus:2];
//                                    //刷新行
//                                    [weakSelf.messageTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                                }];
//}


#pragma mark - XHMessageTableViewController Delegate
- (BOOL)shouldLoadMoreMessagesScrollToTop {
    return YES;
}

- (void)loadMoreMessagesScrollTotop {
    if (!self.loadingMoreMessage) {
        self.loadingMoreMessage = YES;
        
        NSArray *getLocalMessages = nil;
        //获取新的聊天记录
        if(_offset - _count >= 0){
            _offset = _offset - _count;
            getLocalMessages = [_friendUser getChatMessagesWithOffset:_offset count:_count];
        }else if(_offset > 0 && _offset < _count){
            _count = _offset - 0;
            _offset = 0;
            getLocalMessages = [_friendUser getChatMessagesWithOffset:_offset count:_count];
        }else{
            self.loadingMoreMessage = NO;
            return;
        }
        if (getLocalMessages) {
            NSMutableArray *messages = [NSMutableArray arrayWithArray:getLocalMessages];
            [messages addObjectsFromArray:_localMessages];
            self.localMessages = messages;
            
            WEAKSELF
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *messages = [NSMutableArray array];
                
                for (ChatMessage *chatMessage in getLocalMessages) {
                    WLMessage *message = nil;
                    switch (chatMessage.messageType.integerValue) {
                        case WLBubbleMessageMediaTypeActivity://活动
                        case WLBubbleMessageMediaTypeText:
                            //普通文本
                            message = [[WLMessage alloc] initWithText:chatMessage.message sender:chatMessage.sender timestamp:chatMessage.timestamp];
                            //                    message.avator = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[LogInUser getCurrentLoginUser].avatar]]];
                            message.msgId = chatMessage.msgId.stringValue;
                            message.avatorUrl = chatMessage.avatorUrl;
                            message.sended = chatMessage.sendStatus.stringValue;
                            message.bubbleMessageType = chatMessage.bubbleMessageType.integerValue;
                            message.uid = _friendUser.uid.stringValue;
                            break;
                            
                        default:
                            break;
                    }
                    //添加到数组中
                    if (message) {
                        [messages addObject:message];
                    }
                }
                
                //            NSMutableArray *messages = [weakSelf getTestMessages];
                sleep(2);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf insertOldMessages:messages];
                    weakSelf.loadingMoreMessage = NO;
                });
            });
        }
    }
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
//    textMessage.avator = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[LogInUser getCurrentLoginUser].avatar]]];// [UIImage imageNamed:@"user_small"];
    textMessage.avatorUrl = [LogInUser getCurrentLoginUser].avatar;//@"http://www.pailixiu.com/jack/meIcon@2x.png";
    textMessage.sender = [LogInUser getCurrentLoginUser].name;
    textMessage.uid = _friendUser.uid.stringValue;
    //是否读取
    textMessage.isRead = YES;
    textMessage.sended = @"0";
    textMessage.timestamp = [NSDate date];
    
    //更新聊天好友
//    [_friendUser updateIsChatStatus:YES];
    
    //本地聊天数据库添加
    ChatMessage *chatMessage = [ChatMessage createChatMessageWithWLMessage:textMessage FriendUser:_friendUser];
    textMessage.msgId = chatMessage.msgId.stringValue;
    
    //添加数据
    [_localMessages addObject:chatMessage];
    
    [self addMessage:textMessage needSend:YES];
//    [self sendMessage:textMessage];
    [self finishSendMessageWithBubbleMessageType:WLBubbleMessageMediaTypeText];
    
    //如果是从好友列表进入聊天，首页变换
//    if(_isFromUserInfo){
//        _isFromUserInfo = NO;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTapToChatList" object:nil];
//    }
}

/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    WLMessage *photoMessage = [[WLMessage alloc] initWithPhoto:photo thumbnailUrl:nil originPhotoUrl:nil sender:sender timestamp:date];
    photoMessage.avatorUrl = loginUser.avatar;
    photoMessage.sender = loginUser.name;
    photoMessage.uid = _friendUser.uid.stringValue;
    //是否读取
    photoMessage.isRead = YES;
    photoMessage.sended = @"0";
    photoMessage.timestamp = [NSDate date];
    //本地聊天数据库添加
    ChatMessage *chatMessage = [ChatMessage createChatMessageWithWLMessage:photoMessage FriendUser:_friendUser];
    photoMessage.msgId = chatMessage.msgId.stringValue;
    photoMessage.thumbnailUrl = chatMessage.thumbnailUrl;
    //添加数据
    [_localMessages addObject:chatMessage];
    
    [self addMessage:photoMessage needSend:YES];
    [self finishSendMessageWithBubbleMessageType:WLBubbleMessageMediaTypePhoto];
}

/**
 *  发送视频消息的回调方法
 *
 *  @param videoPath 目标视频本地路径
 *  @param sender    发送者的名字
 *  @param date      发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date {
//    XHMessage *videoMessage = [[XHMessage alloc] initWithVideoConverPhoto:videoConverPhoto videoPath:videoPath videoUrl:nil sender:sender timestamp:date];
//    videoMessage.avatar = [UIImage imageNamed:@"avatar"];
//    videoMessage.avatarUrl = @"http://www.pailixiu.com/jack/meIcon@2x.png";
//    [self addMessage:videoMessage];
//    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVideo];
}

/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString*)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date {
//    XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:voicePath voiceUrl:nil voiceDuration:voiceDuration sender:sender timestamp:date];
//    voiceMessage.avatar = [UIImage imageNamed:@"avatar"];
//    voiceMessage.avatarUrl = @"http://www.pailixiu.com/jack/meIcon@2x.png";
//    [self addMessage:voiceMessage];
//    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVoice];
}

/**
 *  发送第三方表情消息的回调方法
 *
 *  @param facePath 目标第三方表情的本地路径
 *  @param sender   发送者的名字
 *  @param date     发送时间
 */
- (void)didSendEmotion:(NSString *)emotionPath fromSender:(NSString *)sender onDate:(NSDate *)date {
//    if (emotionPath) {
//        XHMessage *emotionMessage = [[XHMessage alloc] initWithEmotionPath:emotionPath sender:sender timestamp:date];
//        emotionMessage.avatar = [UIImage imageNamed:@"avatar"];
//        emotionMessage.avatarUrl = @"http://www.pailixiu.com/jack/meIcon@2x.png";
//        [self addMessage:emotionMessage];
//        [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeEmotion];
//        
//    } else {
//        [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"如果想测试，请运行MessageDisplayKitWeChatExample工程" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//    }
}

/**
 *  有些网友说需要发送地理位置，这个我暂时放一放
 */
- (void)didSendGeoLocationsPhoto:(UIImage *)geoLocationsPhoto geolocations:(NSString *)geolocations location:(CLLocation *)location fromSender:(NSString *)sender onDate:(NSDate *)date {
//    XHMessage *geoLocationsMessage = [[XHMessage alloc] initWithLocalPositionPhoto:geoLocationsPhoto geolocations:geolocations location:location sender:sender timestamp:date];
//    geoLocationsMessage.avatar = [UIImage imageNamed:@"avatar"];
//    geoLocationsMessage.avatarUrl = @"http://www.pailixiu.com/jack/meIcon@2x.png";
//    [self addMessage:geoLocationsMessage];
//    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeLocalPosition];
}

/**
 *  点击重新发送  发送失败的消息
 *
 *  @param indexPath 该目标消息在哪个IndexPath里面
 */
- (void)didReSendFailedOnMessage:(id <WLMessageModel>)message atIndexPath:(NSIndexPath *)indexPath
{
    if (IsiOS8Later) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *reSendAction = [UIAlertAction actionWithTitle:@"重新发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self reSendMsgWithMsgId:message.msgId atIndexPath:indexPath];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:reSendAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:nil];
        [sheet bk_addButtonWithTitle:@"重新发送" handler:^{
            [self reSendMsgWithMsgId:message.msgId atIndexPath:indexPath];
        }];
        [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
        [sheet showInView:self.view];
    }
}

//重新发送消息
- (void)reSendMsgWithMsgId:(NSString *)msgId atIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"重新发送消息 -----------");
    //重新设置发送时间和发送状态
    ChatMessage *chatMessage = [_friendUser getChatMessageWithMsgId:msgId];
    [chatMessage updateReSendStatus];
    
    //普通文本
    WLMessage *message = nil;
    switch (chatMessage.messageType.integerValue) {
        case WLBubbleMessageMediaTypeActivity://活动
        case WLBubbleMessageMediaTypeText:
            message = [[WLMessage alloc] initWithText:chatMessage.message sender:chatMessage.sender timestamp:chatMessage.timestamp];
            //                    message.avator = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[LogInUser getCurrentLoginUser].avatar]]];
            message.avatorUrl = chatMessage.avatorUrl;
            message.sended = chatMessage.sendStatus.stringValue;
            message.bubbleMessageType = chatMessage.bubbleMessageType.integerValue;
            message.uid = _friendUser.uid.stringValue;
            message.msgId = chatMessage.msgId.stringValue;
            message.isRead = YES;
            message.sender = chatMessage.sender;
            message.timestamp = chatMessage.timestamp;
            break;
        case WLBubbleMessageMediaTypePhoto:
        {
            //照片
            message = [[WLMessage alloc] initWithPhoto:[ResManager imageWithPath:chatMessage.thumbnailUrl]
                                          thumbnailUrl:chatMessage.thumbnailUrl
                                        originPhotoUrl:chatMessage.originPhotoUrl
                                                sender:chatMessage.sender
                                             timestamp:chatMessage.timestamp];
            message.avatorUrl = chatMessage.avatorUrl;
            message.sended = chatMessage.sendStatus.stringValue;
            message.bubbleMessageType = chatMessage.bubbleMessageType.integerValue;
            message.uid = _friendUser.uid.stringValue;
            message.msgId = chatMessage.msgId.stringValue;
        }
            break;
        default:
            break;
    }
    
    //更新聊天好友
    [_friendUser updateIsChatStatus:YES];
    
    //更新好友的聊天时间
    [_friendUser updateLastChatTime:chatMessage.timestamp];
    
//    [self.messages removeObjectAtIndex:indexPath.row];
    [self removeMessageAtIndexPath:indexPath];
//    [self.messages addObject:message];
    
    //添加数据
    [_localMessages removeObjectAtIndex:indexPath.row];
    [_localMessages addObject:chatMessage];
    
    //在底部添加消息
    [self addMessage:message needSend:YES];
    
    //聊天状态发送改变
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatUserChanged" object:nil];
}

/**
 *  是否显示时间轴Label的回调方法
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatMessage *chatMsg = [_localMessages objectAtIndex:indexPath.row];
    return chatMsg.showTimeStamp.boolValue;
}

/**
 *  点击文字内部  特殊类型回掉方法
 *
 *  @param indexPath 该目标消息在哪个IndexPath里面
 */
//- (void)didSelectedSELinkTextOnMessage:(id <WLMessageModel>)message LinkText:(NSString *)linkText type:(NSTextCheckingType)textType atIndexPath:(NSIndexPath *)indexPath
//{
//    switch (textType) {
//        case NSTextCheckingTypeLink:
//        {
//            //链接地址
//            DLog(@"点击 链接地址 >>>");
//            // 观点  虎嗅网
//            TOWebViewController *webVC = [[TOWebViewController alloc] initWithURLString:linkText];
//            webVC.navigationButtonsHidden = YES;//隐藏底部操作栏目
//            [self.navigationController pushViewController:webVC animated:YES];
//        }
//            break;
//        case NSTextCheckingTypePhoneNumber:
//        {
//            //电话号码
//            DLog(@"点击 电话号码 >>>");
//            UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:[NSString stringWithFormat:@"%@可能是一个电话号码,你可以",linkText]];
//            [sheet bk_addButtonWithTitle:@"呼叫" handler:^{
//                //拨打电话
//                [ACETelPrompt callPhoneNumber:linkText
//                                         call:^(NSTimeInterval duration) {
//                                             DLog(@"User made a call of \(%f) seconds",duration);
//                                         } cancel:^{
//                                             DLog(@"User cancelled the call");
//                                         }];
//            }];
//            [sheet bk_addButtonWithTitle:@"复制" handler:^{
//                //放入粘贴板
//                [[UIPasteboard generalPasteboard] setString:linkText];
//            }];
//            [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
//            [sheet showInView:self.view];
//        }
//            break;
//        default:
//            break;
//    }
//}

- (void)didSelectedSELinkTextOnMessage:(id <WLMessageModel>)message LinkText:(NSString *)linkText type:(MLEmojiLabelLinkType)textType atIndexPath:(NSIndexPath *)indexPath
{
    ChatMessage *chatMsg = [_localMessages objectAtIndex:indexPath.row];
    switch (textType) {
        case MLEmojiLabelLinkTypePhoneNumber:
        {
            //电话号码
            DLog(@"点击 电话号码 >>>");
            UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:[NSString stringWithFormat:@"%@可能是一个电话号码,你可以",linkText]];
            [sheet bk_addButtonWithTitle:@"呼叫" handler:^{
                //拨打电话
                [ACETelPrompt callPhoneNumber:linkText
                                         call:^(NSTimeInterval duration) {
                                             DLog(@"User made a call of \(%f) seconds",duration);
                                         } cancel:^{
                                             DLog(@"User cancelled the call");
                                         }];
            }];
            [sheet bk_addButtonWithTitle:@"复制" handler:^{
                //放入粘贴板
                [[UIPasteboard generalPasteboard] setString:linkText];
            }];
            [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
            [sheet showInView:self.view];
        }
            break;
        case MLEmojiLabelLinkTypeURL:
        {
            //链接地址
            DLog(@"点击 链接地址 >>> %@",chatMsg.messageType);
            //活动类型
            if (chatMsg.messageType.integerValue == WLBubbleMessageMediaTypeActivity) {
                NSArray *info = [linkText componentsSeparatedByString:@"#"];
                NSString *sessionId = [info lastObject];
                //活动页面，进行phoneGap页面加载
                ActivityDetailViewController *activityDetailVC = [[ActivityDetailViewController alloc] init];
                activityDetailVC.wwwFolderName = @"www";
                activityDetailVC.startPage = [NSString stringWithFormat:@"activity_detail.html?%@?t=%@",sessionId,[NSString getNowTimestamp]];
                [self.navigationController pushViewController:activityDetailVC animated:YES];
                return;
            }
            
            //普通链接
            TOWebViewController *webVC = [[TOWebViewController alloc] initWithURLString:linkText];
            webVC.navigationButtonsHidden = YES;//隐藏底部操作栏目
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        default:
            break;
    }
}

//自定义链接类型点击
- (void)didSelectedCustomLinkTextOnMessage:(id <WLMessageModel>)message type:(CustomLinkType)type atIndexPath:(NSIndexPath *)indexPath
{
    switch (type) {
        case CustomLinkTypeSendAddFriend:
        {
            DLog(@"聊天 发送好友请求 >>>");
            //发送好友请求
            LogInUser *loginUser = [LogInUser getCurrentLoginUser];
            NSString *msg = [NSString stringWithFormat:@"我是%@的%@",loginUser.company,loginUser.position];
            //    [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"我是%@的%@",mode.company,mode.position]];
            [WLHttpTool requestFriendParameterDic:@{@"fid":_friendUser.uid,@"message":msg} success:^(id JSON) {
                
            } fail:^(NSError *error) {
                
            }];
        }
            break;
            
        default:
            break;
    }
}

//- (void)didSelectedSELinkTextOnMessage:(id <WLMessageModel>)message LinkText:(NSString *)linkText atIndexPath:(NSIndexPath *)indexPath
//{
//    if ([linkText isEqualToString:@"发送好友请求"]) {
//        //发送好友请求
//        LogInUser *loginUser = [LogInUser getCurrentLoginUser];
//        NSString *msg = [NSString stringWithFormat:@"我是%@的%@",loginUser.company,loginUser.position];
//        //    [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"我是%@的%@",mode.company,mode.position]];
//        [WLHttpTool requestFriendParameterDic:@{@"fid":_friendUser.uid,@"message":msg} success:^(id JSON) {
//            
//        } fail:^(NSError *error) {
//            
//        }];
//    }
//}

/**
 *  点击多媒体消息的时候统一触发这个回调
 *
 *  @param message   被操作的目标消息Model
 *  @param indexPath 该目标消息在哪个IndexPath里面
 *  @param messageTableViewCell 目标消息在该Cell上
 */
- (void)multiMediaMessageDidSelectedOnMessage:(id <WLMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(WLMessageTableViewCell *)messageTableViewCell
{
    switch (message.messageMediaType) {
        case WLBubbleMessageMediaTypeVideo:
        case WLBubbleMessageMediaTypePhoto:
        {
            //键盘控制
//            [self finishSendMessageWithBubbleMessageType:WLBubbleMessageMediaTypePhoto];
            
            // 1.封装图片数据
            NSArray *photoData = [self.messages bk_select:^BOOL(id obj) {
                return [obj messageMediaType] == WLBubbleMessageMediaTypePhoto;
            }];
            NSInteger selectIndex = [photoData indexOfObject:message];
            NSMutableArray *photos = [NSMutableArray arrayWithCapacity:photoData.count];
            for (int i = 0; i<photoData.count; i++) {
                WLMessage *wlMessage = photoData[i];
                NSInteger index = [self.messages indexOfObject:wlMessage];
                WLPhotoView *photoView = [[WLPhotoView alloc] init];
                photoView.image = [ResManager imageWithPath:wlMessage.thumbnailUrl];
                
                MJPhoto *photo = [[MJPhoto alloc] init];
                if( message.bubbleMessageType == WLBubbleMessageTypeSending){
                    photo.image = [ResManager imageWithPath:wlMessage.thumbnailUrl];
                }else{
                    //去除，现实高清图地址
                    NSString *photoUrl = wlMessage.originPhotoUrl;
                    photoUrl = [photoUrl stringByReplacingOccurrencesOfString:@"_x.jpg" withString:@".jpg"];
                    photoUrl = [photoUrl stringByReplacingOccurrencesOfString:@"_x.png" withString:@".png"];
                    photo.url = [NSURL URLWithString:photoUrl]; // 图片路径
                }
                photo.srcImageView = photoView; // 来源于哪个UIImageView
                photo.hasNoImageView = YES;
                WLMessageTableViewCell *cell = (WLMessageTableViewCell *)[self.messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                photo.imageCurrentRect = [cell.messageBubbleView.bubblePhotoImageView convertRect:cell.messageBubbleView.bubblePhotoImageView.bounds toView:self.view];
                [photos addObject:photo];
            }
            
            // 2.显示相册
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.currentPhotoIndex = selectIndex; // 弹出相册时显示的第一张图片是？
            browser.photos = photos; // 设置所有的图片
            [browser show];
//
//            
//            DLog(@"message ----> photo");
//            WLDisplayMediaViewController *messageDisplayTextView = [[WLDisplayMediaViewController alloc] init];
//            messageDisplayTextView.message = message;
//            [self.navigationController pushViewController:messageDisplayTextView animated:YES];
        }
            break;
        default:
            break;
    }
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
 *  点击消息发送者的头像回调方法
 *
 *  @param indexPath 该目标消息在哪个IndexPath里面
 */
- (void)didSelectedAvatorOnMessage:(id <WLMessageModel>)message atIndexPath:(NSIndexPath *)indexPath
{
//    DLog(@"点击头像---------");
    
    IBaseUserM *userMode = [[IBaseUserM alloc] init];
    //自己发送
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    if (message.bubbleMessageType == WLBubbleMessageTypeSending) {
        userMode.uid = loginUser.uid;
        userMode.name = loginUser.name;
    }else{
        //好友头像
        MyFriendUser *friendUser = [loginUser getMyfriendUserWithUid:@(message.uid.integerValue)];
        userMode.uid = friendUser.uid;
        userMode.name = friendUser.name;
    }
    
    UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:userMode isAsk:NO];
    userInfoVC.isHideSendMsgBtn = YES;
    [self.navigationController pushViewController:userInfoVC animated:YES];
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
