//
//  KitJSMediaItem.m
//  aiVideo
//
//  Created by asdsjw on 16/9/28.
//  Copyright © 2016年 asdsjw. All rights reserved.
//

#import "KitJSMediaItem.h"

@implementation KitJSMediaItem
@synthesize title = _title, subtitle = _subtitle, description = _description, artworkImageURL = _artworkImageURL, resumeTime = _resumeTime, url = _url, type = _type, seekTime = _seekTime, subtitleUrl = _subtitleUrl, videoId = _videoId;

//在Javascript中创建new MediaItem("video","http://baidu.com")
- (id)initWithType:(NSString *)arg1 :(NSString *)arg2 {
    self = [super self];
    if (self) {
        if (![arg1 isEqual:@"undefined"] && ![arg1 isEqual:@"video"] && ![arg1 isEqual:@"audio"] && ![arg1 isEqual:@""]) {
            self.type = arg1;
        }else {
            self.type = @"video";
        }
        
        if (![arg2 isEqual:@"undefined"] && [arg2 hasPrefix:@"http"]) {
            self.url = arg2;
        }
    }
    return self;
}

@end
