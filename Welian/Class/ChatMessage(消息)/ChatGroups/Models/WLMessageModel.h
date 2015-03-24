//
//  WLMessageModel.h
//  Welian
//
//  Created by weLian on 14/12/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WLMessageBubbleFactory.h"

@class WLMessage;

@protocol WLMessageModel <NSObject>

@required
- (NSString *)msgId;
- (NSString *)text;

- (UIImage *)photo;
- (NSString *)thumbnailUrl;
- (NSString *)originPhotoUrl;

- (UIImage *)videoConverPhoto;
- (NSString *)videoPath;
- (NSString *)videoUrl;

- (NSString *)voicePath;
- (NSString *)voiceUrl;
- (NSString *)voiceDuration;

- (UIImage *)localPositionPhoto;
- (NSString *)geolocations;
- (CLLocation *)location;

- (NSString *)emotionPath;

- (UIImage *)avator;
- (NSString *)avatorUrl;

- (WLBubbleMessageMediaType)messageMediaType;

- (WLBubbleMessageType)bubbleMessageType;

@optional

- (NSString *)sender;
- (NSString *)uid;

- (NSNumber *)cardId;
- (NSNumber *)cardType;
- (NSString *)cardTitle;
- (NSString *)cardIntro;
- (NSString *)cardUrl;
- (NSString *)cardMsg;

- (NSDate *)timestamp;
- (void)setTimestamp:(NSDate *)timestamp;

- (BOOL)isRead;
- (void)setIsRead:(BOOL)isRead;
- (BOOL)showTimeStamp;
- (void)setShowTimeStamp:(BOOL)showTimeStamp;
- (NSString *)sended;
- (void)setSended:(NSString *)sended;

@end
