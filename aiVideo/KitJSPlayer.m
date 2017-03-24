//
//  KitJSPlayer.m
//  aiVideo
//
//  Created by asdsjw on 16/9/28.
//  Copyright © 2016年 asdsjw. All rights reserved.
//
//Objective-C NSLog 和 Swift Print最大区别在于上架APP,只要进入调试状态,NSlog是能获取日志信息的
//强烈建议上架APP去掉所有的日志输出日志
//防止APP上的信息被窥探
//TVOS 10.0,IOS 9.0模拟器最坑爹的地方就是一堆系统反馈日志
//2016-10-7
//TVML中创建类似官方的JS调用,不知是何机制来清除内存资源
//最后使用- (void)dealloac; 清除
#import "KitJSPlayer.h"
#import "KitJSPlayerController.h"
@implementation KitJSPlayer
@synthesize modalOverlayClock = _modalOverlayClock, context = _context, playlist = _playlist, appController = _appController, jsPlayerController = _jsPlayerController, this = _this, skipForward = _skipForward, episodes = _episodes, resumeTime = _resumeTime;

- (id)init {
    self = [super init];
    if (self) {
        id myDelegate = [[UIApplication sharedApplication] delegate];
        self.appController = [myDelegate appController];
    }
    return self;
}

//const jsPlayer = new JSPlayer();
//jsPlayer.bridgeConnection(jsPlayer);
//jsPlayer.mediaItemDidChange = function() { console.log("test sus!"); };
//建立任何当前JSPlayer的回调函数
- (void)bridgeConnection:(id)arg1 {
    //JSContext是全局的,能获取整个TVML的JS变量和函数
    _context = [JSContext currentContext];
    //管理当前的Javascipt变量
    _this = [[JSManagedValue alloc] initWithValue:arg1];
    //建立Objective-C和Javascript稳定的联系桥梁
    [_context.virtualMachine addManagedReference:_this withOwner:self];
}

- (void)changeToMediaAtIndex:(unsigned long long)arg1 {
    
}

- (void)previous {
    
}

- (void)next {
    
}
- (void)stop {
    
}
- (void)pause {
    
}

- (void)onNextItem {
    NSLog(@"onChangeItem");
    if (_jsPlayerController) {
        [_jsPlayerController play:true];
    }
}

//开始播放视频
- (void)play {
    //延时操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_jsPlayerController) {
            NSLog(@"KitJSPlayer Play:B");
            [_jsPlayerController play:false];
        }
    });
}

//显示播放器窗体
- (void)present {
    NSLog(@"KitJSPlayer Present");
    NSInteger viewCount = _appController.navigationController.viewControllers.count;
    //防止空导航出错
    if (viewCount > 0) {
        id currentView = [_appController.navigationController.viewControllers objectAtIndex:viewCount-1];
        NSString *strs = [NSString stringWithUTF8String:object_getClassName(currentView)];
        //判断当前视图是否为视频播放控制视图
        if([strs isEqual:@"_TVPlaybackViewController"] || [currentView isKindOfClass:[KitJSPlayerController class]])
        {
            NSLog(@"remove suss!");
            //判断KitJSPlayerController是否存在
            if (_jsPlayerController) {
                [_jsPlayerController removeFromParentViewController];
                _jsPlayerController = nil;
                [_appController.navigationController popViewControllerAnimated:YES];
            }else {
                [_appController.navigationController removeFromParentViewController];
                [_appController.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    
    _jsPlayerController = [[KitJSPlayerController alloc] init];
    _jsPlayerController.kitJSPlayer = self;
    _jsPlayerController.episodes = self.episodes;
    _jsPlayerController.resumeTime = self.resumeTime;
    [_jsPlayerController setActionForward:_skipForward];
    //载入视频和播放视频要同步进行,不然引起APP崩溃
    //由于是在子线程中运行,所以需要回到UI线程
    dispatch_async(dispatch_get_main_queue(), ^{
        [_appController.navigationController pushViewController:_jsPlayerController animated:true];
        [_jsPlayerController addStatusLabel];
        [_jsPlayerController addSubviewOverlay:_modalOverlayClock];
    });
  
}

- (void)testRelease {
    [_context.virtualMachine removeManagedReference:_this withOwner:self];
    if(_playlist)
    {
        _playlist = nil;
    }
    if(_jsPlayerController)
    {
        _jsPlayerController = nil;
    }
}

- (void)seekToTime:(double)arg1 {
    
}

- (void)addEventListener:(id)arg1 :(id)arg2 :(id)arg3 {
    
}

- (void)changStatusText:(NSString *)str {
    [_jsPlayerController changStatusText:str];
}


@end
