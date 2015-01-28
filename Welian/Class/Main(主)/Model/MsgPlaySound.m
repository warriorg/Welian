//
//  MsgPlaySound.m
//  Welian
//
//  Created by dong on 15/1/27.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "MsgPlaySound.h"

@implementation MsgPlaySound
single_implementation(MsgPlaySound)

- (void)playSystemShake
{
    self.soundFileObject = kSystemSoundID_Vibrate;//震动
    [self play];
}

- (void)playSystemSoundWithName:(NSString *)soundName
{
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/sms-received%@.caf",soundName];
    //[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:soundName ofType:soundType];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
    //[[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];  获取自定义的声音
    if (path) {
        self.soudnFileURLRef = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
        OSStatus error = AudioServicesCreateSystemSoundID(self.soudnFileURLRef,&_soundFileObject);
        
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            self.soundFileObject = kSystemSoundID_Vibrate;//震动
        }
    }
    [self play];
}

- (void)play
{
    AudioServicesPlaySystemSound(self.soundFileObject);
}

@end
