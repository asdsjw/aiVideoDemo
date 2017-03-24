//
//  LivePLayerController.h
//  aiVideo
//
//  Created by asdsjw on 16/9/19.
//  Copyright © 2016年 asdsjw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <TVMLKit/TVMLKit.h>
#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
@class KitJSPlayer,CustomView;
@interface KitJSPlayerController : AVPlayerViewController<AVPlayerViewControllerDelegate>
{
    NSString *titlea;
    NSString *description;
    NSString *subtitle;
    NSString *artworkImage;
    KitJSPlayer *_kitJSPlayer;
    NSInteger index;
    UILabel *clockLabel;
    id _timeObser;
    id _otherObser;
    NSString *clockBool;
    AVContentProposal *proposal;
    float resumeTimeFloat;
    NSMutableArray *srtArray;
    UILabel *subtitleLabel;
    UILabel *statusLabel;
    NSInteger statusInt;
    AVPlayerItem *playerItem;
    NSNumber *_episodes;
    NSInteger videoLenghtInt;
    NSUserDefaults *defaultBackgroud;
    NSString *albumStr;
    BOOL _resumeTime;
    JSValue *onJSValue;
}
@property(nonatomic) BOOL resumeTime;
@property(nonatomic) NSNumber *episodes;
@property(retain, nonatomic) KitJSPlayer *kitJSPlayer;
@property(readwrite,copy) NSString *titlea;
@property(readwrite,copy) NSString *description;
@property(readwrite,copy) NSString *subtitle;
@property(readwrite,copy) NSString *artworkImage;
- (void)playerGravityResize:(NSString *)model;
- (void)seekTime:(float)newTime;
- (void)play:(BOOL)next;
- (void)addSubviewOverlay:(NSString *)str;
- (void)changStatusText:(NSString *)str;
- (void)addStatusLabel;
- (void)setActionForward:(BOOL)isForward;
@end
