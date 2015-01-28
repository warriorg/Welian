//
//  MsgPlaySound.h
//  Welian
//
//  Created by dong on 15/1/27.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Singleton.h"

@interface MsgPlaySound : NSObject
single_interface(MsgPlaySound)

//用于表示系统音频文件对象
@property (nonatomic, assign) SystemSoundID soundFileObject;//系统声音的id 取值范围为：1000-2000
//可以理解为音频文件的位置和目录
@property (nonatomic, assign) CFURLRef soudnFileURLRef;

- (void)playSystemShake;//系统 震动
- (void)playSystemSoundWithName:(NSString *)soundName;//初始化系统声音

@end
