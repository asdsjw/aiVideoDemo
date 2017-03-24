//
//  LivePLayerController.m
//  aiVideo
//
//  Created by asdsjw on 16/9/19.
//  Copyright © 2016年 asdsjw. All rights reserved.
//
//2016-10-8
//关于KVO下面崩溃问题,其实里面有一个问题
//当你使用self 或 赋值 操作时候,其实是产生的副本,removeObserver删除时候只是删除副本中的KVO,原本创建对象上的并没有删除
//很多人不知道这个事情
#import "KitJSPlayerController.h"
#import "KitJSPlayer.h"
#import "KitJSPlaylist.h"
#import "KitJSMediaItem.h"
#import "KitJSContentProposal.h"
@implementation KitJSPlayerController
@synthesize titlea, description, subtitle, artworkImage, kitJSPlayer = _kitJSPlayer, episodes = _episodes, resumeTime = _resumeTime;

- (id)init {
    self = [super init];
    if (self) {
        //_jsPlayerController = [[KitJSPlayerController alloc] init];
        NSLog(@"KitJSPlayerController Init");
        index = 0;
        clockBool = @"";
        statusInt = 0;
        videoLenghtInt = 0;
        defaultBackgroud = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.sjw.ai"];
    }
    return self;
}

- (void)playerViewController:(AVPlayerViewController *)playerViewController didAcceptContentProposal:(AVContentProposal *)proposal {
    NSLog(@"did Accept Content Proposal");
    if (_resumeTime && resumeTimeFloat > 0) {
        [self seekTime:resumeTimeFloat];
    }
}

- (BOOL)playerViewController:(AVPlayerViewController *)playerViewController shouldPresentContentProposal:(AVContentProposal *)proposal {
    UIStoryboard *contentProposalStoryboard = [UIStoryboard storyboardWithName:@"ContentProposal" bundle:[NSBundle mainBundle]];
    KitJSContentProposal *contentProposalViewController = (KitJSContentProposal *)[contentProposalStoryboard instantiateInitialViewController];
    self.contentProposalViewController = contentProposalViewController;
    return true;
}

- (void)setActionForward:(BOOL)isForward {
    //创建播放器时候,这样打开视频时候不会出现控制器,表现比较舒适.
    //下面2属性必须启用
    //创建跳过项目的委托
    //使用该方式创建时候,初始化init数据
    self.delegate = self;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.000000 && isForward) {
        self.skipForwardEnabled = true;
        self.skipBackwardEnabled = false;
        [self setSkippingBehavior:AVPlayerViewControllerSkippingBehaviorSkipItem];
    }
}

- (void)setEpisodes:(NSNumber *)episodes {
    NSNumber *numInt = [NSNumber numberWithInteger:0];
    if (episodes) {
        _episodes = episodes;
    }else {
        _episodes = numInt;
    }
}

- (void)addSubviewOverlay:(NSString *)str {
    NSLog(@"KitJSPlayer Clock");
    if ([str isEqual:@"开"] || [str isEqual:@"半点显示"]) {
        clockBool = str;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width - 104 - 120, 40, 124, 40)];
        clockLabel.text = @"";
        clockLabel.textColor = [UIColor whiteColor];
        clockLabel.font = [UIFont systemFontOfSize:40];
        [self.view addSubview:clockLabel];
        [self getCurrentTimeDate];
    }
}

//播放器状态提示
- (void)addStatusLabel {
    statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 450, 1920, 50)];
    statusLabel.font = [UIFont systemFontOfSize:40];
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.text = @"视频数据加载中...";
    statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:statusLabel];
}

//下一个项目的委托
//TVOS10的新功能,在Siri遥控器上触控板的右侧长按启用
//必须skipForwardEnabled = true,启用skipToNextItemForPlayerViewController委托,还有用户行为发生之时有效
- (void)skipToNextItemForPlayerViewController:(AVPlayerViewController *)playerViewController {
    NSLog(@"skipToNextItemForPlayerViewController");
    [self currentMediaItemToEndNot];
}

- (void)nextMediaItem:(UITapGestureRecognizer *)up {
    NSLog(@"next item");
    [self currentMediaItemToEndNot];
}

//恢复上次观看视频时间点的操作窗口
- (void)addSubviewResumeOverlay {
    
}

//开 时钟显示时钟
- (void)getCurrentTimeDate {
    @autoreleasepool {
        NSDateFormatter *nsdf2 = [[NSDateFormatter alloc] init];
        [nsdf2 setDateStyle:NSDateFormatterShortStyle];
        [nsdf2 setDateFormat:@"HH:mm"];
        NSString *resultDate = [nsdf2 stringFromDate:[NSDate date]];
        clockLabel.text = resultDate;
    }
}

//半点显示时钟
- (void)getHalfTimeDate {
    @autoreleasepool {
        NSDateFormatter *nsdf2 = [[NSDateFormatter alloc] init];
        [nsdf2 setDateStyle:NSDateFormatterShortStyle];
        [nsdf2 setDateFormat:@"HH:mm"];
        NSString *resultDate = [nsdf2 stringFromDate:[NSDate date]];
        NSArray *dateArray = [resultDate componentsSeparatedByString:@":"];
        if ([dateArray[1] isEqual:@"0"] || [dateArray[1] isEqual:@"30"] || [dateArray[1] isEqual:@"45"] || [dateArray[1] isEqual:@"15"]) {
            if ([clockLabel.text isEqual: @""]) {
                clockLabel.text = resultDate;
            }
        }else {
            if (![clockLabel.text isEqual: @""]) {
                clockLabel.text = @"";
            }
        }
    }
}

- (void)play:(BOOL)next {
    statusInt = 0;
    KitJSPlaylist *playlist = _kitJSPlayer.playlist;
    if (!playlist) {
        return;
    }
    
    if (playlist.length == 0) {
        return;
    }
    
    KitJSMediaItem *mediaItem = [playlist item:index];
    if (!mediaItem) {
        return;
    }
    
    if (!mediaItem.url) {
        return;
    }
    
    if (mediaItem.title) {
        titlea = mediaItem.title;
    }

    if (mediaItem.subtitle) {
        subtitle = mediaItem.subtitle;
    }
    
    if (mediaItem.description) {
        description = mediaItem.description;
    }
    
    if (mediaItem.artworkImageURL) {
        artworkImage = mediaItem.artworkImageURL;
    }
    albumStr = mediaItem.videoId;
    [self loadSrtSubtitle:mediaItem.subtitleUrl];
 
    NSURL *mediaURL = [NSURL URLWithString:mediaItem.url];
    AVAsset *asset = [AVAsset assetWithURL:mediaURL];
    playerItem = [AVPlayerItem playerItemWithAsset:asset];
    playerItem.externalMetadata = [self externalMetaData];
    
    if (next) {
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
    }else {
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
    }
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    float currentAvPos= [self currentPos];
    if (currentAvPos > 0 && _resumeTime) {
        NSLog(@"start resume time");
        if ([UIDevice currentDevice].systemVersion.floatValue < 10.000000) {
            UIAlertController* continueWatchingAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *continueWatching = [UIAlertAction actionWithTitle:@"观看上次视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                [self seekTime:currentAvPos];
            }];
            UIAlertAction *startWatching = [UIAlertAction actionWithTitle:@"回到当前视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            }];
            [continueWatchingAlert addAction:continueWatching];
            [continueWatchingAlert addAction:startWatching];
            [self presentViewController:continueWatchingAlert animated:YES completion:nil];
        }else {
            resumeTimeFloat = currentAvPos;
            [self setContentProposalView];
        }
    }else {
        if ([mediaItem.seekTime intValue] > 0) {
            [self seekTime:[mediaItem.seekTime floatValue]];
        }
    }
    
    //防止播放完视频之后停留在第一帧
    //网传的AVPlayerActionAtItemEndPause在这里没用的
    [self.player setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    
    //建立全局的播放事件通知
    if(!onJSValue)
    {
        onJSValue = [_kitJSPlayer.this.value valueForProperty:@"onChangeItem"];
        NSLog(@"初始化");
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentMediaItemToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    KitJSPlayerController __weak *ctSelf = self;
    NSString *ctClockStr = clockBool;
    _otherObser = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(2, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if ([ctClockStr isEqual:@"开"]) {
            [ctSelf getCurrentTimeDate];
        }
        if ([ctClockStr isEqual:@"半点显示"]) {
            [ctSelf getHalfTimeDate];
        }
        Float64 timeInterval = CMTimeGetSeconds(time);
        if(videoLenghtInt>500 && ![mediaItem.videoId isEqual:@""] && _resumeTime && timeInterval > 120)
        {
            NSDictionary *cuttrentPPOS = [ctSelf getItem:@"playpos"];
            NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:cuttrentPPOS];
            [mutDic setValue:[NSNumber numberWithFloat:timeInterval] forKey:mediaItem.videoId];
            [ctSelf savePlaypos:mutDic];
        }
    }];
    
    //加载网络上的SRT字幕
    if ([mediaItem.subtitleUrl hasPrefix:@"http"] && srtArray) {
        _timeObser = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 60) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            Float64 timeInterval = CMTimeGetSeconds(time);
            [ctSelf filterCurrentSubTime:[NSNumber numberWithFloat:timeInterval]];
        }];
    }
}

//加载网络字幕
- (void)loadSrtSubtitle:(NSString *)str {
    NSURL *url =[NSURL URLWithString:str];
    if (!url) {
        return;
    }
    
    NSMutableString *strs = [[NSMutableString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    if (strs) {
        
        if (!srtArray) {
            srtArray = [[NSMutableArray alloc] init];
        }else {
            [srtArray removeAllObjects];
        }
        
        [self parseSRT:strs];
    }
    
    if (subtitleLabel) {
        return;
    }
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, screenSize.height - 150, screenSize.width, 100)];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.numberOfLines = 2;
    subtitleLabel.font = [UIFont systemFontOfSize:40.0];
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
    subtitleLabel.layer.shadowOffset = CGSizeMake(1.0, 1.2);
    subtitleLabel.layer.shadowOpacity = 0.85;
    subtitleLabel.layer.shadowRadius = 0.75;
    subtitleLabel.layer.shouldRasterize = true;
    if ([UIDevice currentDevice].systemVersion.floatValue < 10.000000) {
        NSLog(@"9.0");
        //介于视频介绍导航Top Bar之下
        [self.view addSubview:subtitleLabel];
    }else {
        NSLog(@"10.0");
        //介于视频层与控制层之间
        [self.contentOverlayView addSubview:subtitleLabel];
    }
}

//该部分代码是我subEditer osx软件的SRT解析
-(void)parseSRT:(NSMutableString *)dataString
{
    //追加换行
    NSRange range = NSMakeRange(0, dataString.length);
    [dataString replaceOccurrencesOfString:@"\n\n" withString:@"\r\n\r\n" options:0 range:range];
    [dataString appendFormat:@"\r\n\r\n"];
    NSError *error = NULL;
    //[array_controller setEditable:NO];
    //[array_controller setAutomaticallyPreparesContent:NO];
    NSRegularExpression *srtRegex = [[NSRegularExpression alloc] initWithPattern:@"(\\d{2}:\\d{2}:\\d{2}[,.]\\d{3})\\s*-->\\s*(\\d{2}:\\d{2}:\\d{2}[,.]\\d{3})\\s*([\\s\\S]*?)\r\n\r\n" options: NSRegularExpressionDotMatchesLineSeparators error:&error];
    @autoreleasepool {
        __block int jiaPlug = 0;
        
        [srtRegex enumerateMatchesInString:dataString options:0 range:NSMakeRange(0, [dataString length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            jiaPlug++;
            
            NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithCapacity:4];
            NSString *fromTime = [[dataString substringWithRange:[result rangeAtIndex:1]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *toTime = [[dataString substringWithRange:[result rangeAtIndex:2]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *textSub = [[dataString substringWithRange:[result rangeAtIndex:3]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            [mutDic setValue:[NSNumber numberWithFloat:[self convertToQTime:fromTime]] forKey:@"FromTime"];
            [mutDic setValue:[NSNumber numberWithFloat:[self convertToQTime:toTime]] forKey:@"ToTime"];
            [mutDic setValue:textSub forKey:@"text"];
            [srtArray addObject:mutDic];
        }];
    }

    srtRegex=nil;
}

-(float)convertToQTime:(NSString *)formatTime
{
    NSArray *arrayTime=[formatTime componentsSeparatedByString:@":"];
    float hours=[[arrayTime objectAtIndex:0] floatValue];
    float minutes=[[arrayTime objectAtIndex:1] floatValue];
    NSArray *secondsComponents=[[arrayTime objectAtIndex:2] componentsSeparatedByString:@","];
    NSUInteger seconds=[[secondsComponents objectAtIndex:0] floatValue];
    float milliseconds=[[secondsComponents objectAtIndex:1] floatValue];
    float totalNumSeconds = (hours * 3600) + (minutes * 60) + (seconds)+milliseconds/1000;
    return totalNumSeconds;
}

- (void)filterCurrentSubTime:(NSNumber *)time {
    NSPredicate *initialPredicate = [NSPredicate predicateWithFormat:@"(%@ >= FromTime) AND (%@ <= ToTime)", time, time];
    NSDictionary *dic = [srtArray filteredArrayUsingPredicate:initialPredicate].firstObject;
    if (!dic) {
        subtitleLabel.text = @"";
        return;
    }
    
    if (!subtitleLabel) {
        return;
    }
    
    subtitleLabel.text = [dic objectForKey:@"text"];
}

- (void)setContentProposalView {
    NSLog(@"恢复时间");
    proposal = [[AVContentProposal alloc] initWithContentTimeForTransition:CMTimeMake(1.0, 1.0) title:@"下一集" previewImage:nil];
    proposal.automaticAcceptanceInterval = 4;
    self.player.currentItem.nextContentProposal = proposal;
}

- (NSMutableArray *)externalMetaData {
    NSMutableArray *samArray = [[NSMutableArray alloc] init];
    
    if (titlea) {
        [samArray addObject:[self metadataItem:titlea identifier:AVMetadataCommonIdentifierTitle]];
    }
    
    if (subtitle) {
        //[samArray addObject:[self metadataItem:@"1080P" identifier:AVMetadataIdentifieriTunesMetadataContentRating]];
        [samArray addObject:[self metadataItem:subtitle identifier:AVMetadataIdentifierQuickTimeMetadataGenre]];
    }
 
    //description虽然已经修改成功,但是属于继承的,所以初始化还是@""
    if (!description || [description isEqual:@""]) {
        description = @" ";
    }
    [samArray addObject:[self metadataItem:description identifier:AVMetadataCommonIdentifierDescription]];

    //tvos10添加图像时候,必须添加说明description
    //tvos9下也没怎么正常,图片缩小了一半,我估计是Auto Layout导致的
    //同一个网站的图片,可能存在缩略图显示大学不一致的情况
    //这个就和我之前写的漫画软件好像有点像图片大小识别不准确
    //可惜啊这个也改不了的
    if (artworkImage) {
        AVMutableMetadataItem *descriptionItem = [[AVMutableMetadataItem alloc] init];
        NSURL *url = [NSURL URLWithString:artworkImage];
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:nil];
        descriptionItem.identifier = AVMetadataCommonIdentifierArtwork;
        descriptionItem.value = data;
        descriptionItem.dataType = (__bridge NSString * _Nullable)(kCMMetadataBaseDataType_JPEG);
        descriptionItem.extendedLanguageTag = @"und";
        [samArray addObject:descriptionItem];
    }
    return samArray;
}

- (AVMutableMetadataItem *)metadataItem:(NSString *)title identifier:(NSString *)str {
    AVMutableMetadataItem *item = [[AVMutableMetadataItem alloc] init];
    item.identifier = str;
    item.value = title;
    item.extendedLanguageTag = @"und";
    return item;
}

//设置视频的拉伸模式
- (void)playerGravityResize:(NSString *)model {
    if ([model isEqual:@"全屏拉伸"]) {
        self.videoGravity = AVLayerVideoGravityResizeAspect;
    }else if ([model isEqual:@"全屏去黑边"]) {
        self.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }else {
        self.videoGravity = AVLayerVideoGravityResize;
    }
}

//移动时间轴到指定的时间点
- (void)seekTime:(float)newTime {
    NSLog(@"%f",newTime);
    NSLog(@"跳转");
    CMTime cmTime = CMTimeMakeWithSeconds(newTime, NSEC_PER_SEC);
    [self.player seekToTime:cmTime];
}

//通知当前媒体项目播放完毕
- (void)currentMediaItemToEnd:(NSNotification *)notification {
    NSLog(@"KitJSPlayer Current Media Played End!");
    [self currentMediaItemToEndNot];
}

- (void)currentMediaItemToEndNot {
    NSLog(@"Test A;");
    if (_timeObser) {
        [self.player removeTimeObserver:_timeObser];
        _timeObser = nil;
    }
    if (_otherObser) {
        [self.player removeTimeObserver:_otherObser];
        _otherObser = nil;
    }
    NSLog(@"Test B;");
    if (proposal) {
        proposal = nil;
    }
    NSLog(@"Test C;");
    index = index + 1;
    KitJSPlaylist *playlist = _kitJSPlayer.playlist;
    if (index < playlist.length) {
        NSLog(@"Next KitJSPlayer Item!");
        [self play:true];
        return;
    }
    NSLog(@"Test D;");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    //NSLog(@"%@",_kitJSPlayer.this.value);
    
    if (![[onJSValue toString] isEqual:@"undefined"] && index < [_episodes integerValue]) {
        NSLog(@"onNextItem");
        self.player.currentItem.externalMetadata = @[];
        [self.player replaceCurrentItemWithPlayerItem:nil];
        playerItem = nil;
        [self changStatusText:@"下一集视频准备中..."];
        [onJSValue callWithArguments:@[]];
        return;
    }
    NSLog(@"Test E;");
    [_kitJSPlayer.appController.navigationController popViewControllerAnimated:true];
}

- (void)changStatusText:(NSString *)str {
    if (statusLabel) {
        statusLabel.text = str;
    }
}

//播放器的委托,对时间轴移动 播放是否完毕等进行追踪
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (playerItem) {
        if ([keyPath isEqualToString:@"status"]) {
            if ([playerItem status] == AVPlayerStatusFailed) {
                statusLabel.text = @"视频加载失败! 请检查你的网络设置!";
                self.showsPlaybackControls = false;
                [playerItem removeObserver:self forKeyPath:@"status"];
                statusInt = 1;
                playerItem = nil;
            }else if ([playerItem status] == AVPlayerStatusReadyToPlay) {
                [self.player play];
                statusLabel.text = @"";
                [playerItem removeObserver:self forKeyPath:@"status"];
                statusInt = 1;
                Float64 timeInterval = CMTimeGetSeconds(playerItem.duration);
                videoLenghtInt = timeInterval;
            }else {
                statusLabel.text = @"视频数据加载中...";
            }
        }
    }
}

//dealloc居然在JavascriptCore Class模式先不能启用
//所以用viewDidDisappear代替,目前不清楚这种方式的资源释放机制
//释放大部分的JS创建对象资源
//好像只有这个方法比较时候
//反正内存是控制住了
- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_timeObser) {
        [self.player removeTimeObserver:_timeObser];
        _timeObser = nil;
    }
    if (_otherObser) {
        [self.player removeTimeObserver:_otherObser];
        _otherObser = nil;
    }
    if (proposal) {
        proposal = nil;
    }
    if (playerItem && statusInt == 0) {
        [playerItem removeObserver:self forKeyPath:@"status"];
    }
    if (srtArray) {
        [srtArray removeAllObjects];
    }
    if (self.player.currentItem) {
        NSLog(@"FFFFFF");
        [self.player pause];
        self.player.currentItem.externalMetadata = @[];
        [self.player replaceCurrentItemWithPlayerItem:nil];
        playerItem = nil;
        [self.view.layer removeFromSuperlayer];
        self.player = nil;
    }
    onJSValue = nil;
    [_kitJSPlayer testRelease];
    _kitJSPlayer = nil;
}

- (NSDictionary *)getItem:(NSString *)str {
    if ([defaultBackgroud valueForKey:str]) {
        return [defaultBackgroud valueForKey:str];
    }
    return nil;
}

- (float)currentPos {
    NSDictionary *cuttrentPPOS = [self getItem:@"playpos"];
    if (cuttrentPPOS) {
        if ([cuttrentPPOS valueForKey:albumStr]) {
            return [[cuttrentPPOS valueForKey:albumStr] floatValue];
        }
    }
    return 0;
}

- (void)savePlaypos:(NSDictionary *)str {
    [defaultBackgroud setValue:str forKey:@"playpos"];
    [defaultBackgroud synchronize];
}
@end
