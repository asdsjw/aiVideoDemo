//
//  KitJSPlayer.h
//  aiVideo
//
//  Created by asdsjw on 16/9/28.
//  Copyright © 2016年 asdsjw. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <TVMLKit/TVMLKit.h>
#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "AppDelegate.h"
@class KitJSMediaItem, KitJSPlaylist, KitJSPlayerController, KitJSPlayerController;

@protocol KitJSPlayer <JSExport>
@property(retain, nonatomic) NSString *modalOverlayClock;
@property(readonly, nonatomic) NSNumber *currentMediaItemDuration;
@property(retain, nonatomic) KitJSPlaylist *playlist;
@property(nonatomic) _Bool skipForward;
@property(nonatomic) NSNumber *episodes;
- (void)changeToMediaAtIndex:(unsigned long long)arg1;
- (void)previous;
- (void)next;
- (void)onNextItem;
- (void)stop;
- (void)pause;
- (void)play;
- (void)present;
- (void)seekToTime:(double)arg1;
- (void)changStatusText:(NSString *)str;
- (void)bridgeConnection:(JSValue *)arg1;
- (void)addEventListener:(NSString *)arg1 :(JSValue *)arg2 :(JSValue *)arg3;
@property(nonatomic) _Bool resumeTime;
- (id)init;
@end

@interface KitJSPlayer : NSObject <KitJSPlayer, UIApplicationDelegate>
{
    //播放时钟显示
    NSString *_modalOverlayClock;
    //当前媒体的视频长度
    NSNumber *_currentMediaItemDuration;
    JSManagedValue *_this;
    JSContext *_context;
    KitJSPlaylist *_playlist;
    TVApplicationController *_appController;
    KitJSPlayerController *_jsPlayerController;
    _Bool _skipForward;
    _Bool _resumeTime;
    NSNumber *_episodes;
}
@property(nonatomic) NSNumber *episodes;
@property(nonatomic) _Bool skipForward;
@property(nonatomic) _Bool resumeTime;
@property(retain, nonatomic) JSManagedValue *this;
@property(strong, nonatomic) KitJSPlayerController *jsPlayerController;
@property(strong, nonatomic) TVApplicationController *appController;
@property(retain, nonatomic) NSString *modalOverlayClock;
@property(readonly, nonatomic) NSNumber *currentMediaItemDuration;
@property(retain, nonatomic) JSContext *context;
@property(retain, nonatomic) KitJSPlaylist *playlist;
- (void)changeToMediaAtIndex:(unsigned long long)arg1;
- (void)previous;
- (void)next;
- (void)onNextItem;
- (void)stop;
- (void)pause;
- (void)play;
- (void)present;
- (void)seekToTime:(double)arg1;
- (void)bridgeConnection:(id)arg1;
- (void)addEventListener:(id)arg1 :(id)arg2 :(id)arg3;
- (void)changStatusText:(NSString *)str;
- (id)init;
- (void)testRelease;
@end
