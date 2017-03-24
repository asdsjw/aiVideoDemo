//
//  KitJSMediaItem.h
//  aiVideo
//
//  Created by asdsjw on 16/9/28.
//  Copyright © 2016年 asdsjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
@protocol KitJSMediaItem <JSExport>
@property(retain, nonatomic) NSString *title;
@property(retain, nonatomic) NSString *subtitle;
@property(retain, nonatomic) NSString *description;
@property(retain, nonatomic) NSString *artworkImageURL;
@property(retain, nonatomic) NSNumber *resumeTime;
@property(retain, nonatomic) NSNumber *seekTime;
@property(retain, nonatomic) NSString *url;
@property(retain, nonatomic) NSString *type;
@property(retain, nonatomic) NSString *subtitleUrl;
@property(retain, nonatomic) NSString *videoId;
- (id)initWithType:(NSString *)arg1 :(NSString *)arg2;
@end

@interface KitJSMediaItem : NSObject <KitJSMediaItem>
{
    //媒体标题
    NSString *_title;
    //副标题
    NSString *_subtitle;
    //说明
    NSString *_description;
    //图片Url
    NSString *_artworkImageURL;
    //媒体项目的时间恢复点
    NSNumber *_resumeTime;
    //媒体项目的片头时间点
    NSNumber *_seekTime;
    //媒体的Url
    NSString *_url;
    //媒体类型
    NSString *_type;
    //字幕网址,默认支持SRT字幕
    NSString *_subtitleUrl;
    //保存时间线的视频id
    NSString *_videoId;
}

@property(retain, nonatomic) NSString *title;
@property(retain, nonatomic) NSString *subtitle;
@property(retain, nonatomic) NSString *description;
@property(retain, nonatomic) NSString *artworkImageURL;
@property(retain, nonatomic) NSNumber *resumeTime;
@property(retain, nonatomic) NSNumber *seekTime;
@property(retain, nonatomic) NSString *url;
@property(retain, nonatomic) NSString *type;
@property(retain, nonatomic) NSString *subtitleUrl;
@property(retain, nonatomic) NSString *videoId;
- (id)initWithType:(NSString *)arg1 :(NSString *)arg2;
@end
