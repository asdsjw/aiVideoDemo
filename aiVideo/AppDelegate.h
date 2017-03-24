//
//  AppDelegate.h
//  aiVideo
//

//  Copyright (c) 2016年 asdsjw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TVMLKit/TVMLKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, NSURLSessionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TVApplicationController *appController;

@end
