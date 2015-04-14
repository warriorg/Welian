//
//  NSUserDefaults+Standard.m
//  FoursquareIntegration
//
//  Created by Andreas Katzian on 07.08.10.
//  Copyright 2010 Blackwhale GmbH. All rights reserved.
//

#import "NSUserDefaults+Standard.h"


@implementation NSUserDefaults (Standard)


+ (void) setBool:(BOOL) value forKey:(NSString*) key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:value forKey:key];
	[defaults synchronize];
}

+ (BOOL) boolForKey:(NSString*) key
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}


+ (void) setObject:(id) value forKey:(NSString*) key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:value forKey:key];
	[defaults synchronize];
}

+ (id)objectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void) setString:(NSString*) value forKey:(NSString*) key
{
	[NSUserDefaults setObject:value forKey:key];
}

+ (NSString*) stringForKey:(NSString*) key
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

+ (void)setInt:(int)value forKey:(NSString *)key 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}

+ (int)intForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (void)registerDefaultValueWithTestKey:(NSString *)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = nil;
    
    if (standardUserDefaults) {
        val = [standardUserDefaults valueForKey:key];
    }
    
    if (val == nil) {
        NSString *bPath = [[NSBundle mainBundle] bundlePath];
        NSString *settingPath = [bPath stringByAppendingPathComponent:@"Settings.bundle"];
        NSString *plistPath = [settingPath stringByAppendingPathComponent:@"Root.plist"];
        
        NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
        
        NSDictionary *item;
        for (item in preferencesArray) {
            NSString *keyValue = [item objectForKey:@"Key"];
            
            id defaultValue = [item objectForKey:@"DefaultValue"];
            
            if (keyValue && defaultValue) {
                [standardUserDefaults setObject:defaultValue forKey:keyValue];
            }
        }
        [standardUserDefaults synchronize];
    }
}

@end
