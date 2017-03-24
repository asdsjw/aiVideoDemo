//
//  AppDelegate.m
//  aiVideo
//

//  Copyright (c) 2016年 asdsjw. All rights reserved.
//
#import "AppDelegate.h"
#import "JSLoadingTemplateViewController.h"
#import "JSLoadingTemplateElement.h"
#import "KitJSPlayer.h"
#import "KitJSPlaylist.h"
#import "KitJSMediaItem.h"
#import "KitJSArray.h"


@protocol ToolsJSEports <JSExport>

@end

@interface AppDelegate ()<ToolsJSEports, TVApplicationControllerDelegate, TVInterfaceCreating>
{
    NSString *tempStr;
    NSUserDefaults *defaultBackgroud;
    UIImage *bgImages;
    BOOL nightBool;
    NSArray *trustedCertArr;
}
@property (readwrite,nonatomic) NSString *tempStr;
@property (readwrite,nonatomic) UIImage *bgImages;
@end

@implementation AppDelegate
@synthesize tempStr,bgImages;
#pragma mark Javascript Execution Helper

- (void)executeRemoteMethod:(NSString *)methodName completion:(void (^)(BOOL))completion {
    [self.appController evaluateInJavaScriptContext:^(JSContext *context) {
        JSValue *appObject = [context objectForKeyedSubscript:@"App"];
        
        if ([appObject hasProperty:methodName]) {
            [appObject invokeMethod:methodName withArguments:@[]];
        }
    } completion:completion];
}

#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    nightBool = false;

    TVApplicationControllerContext *appControllerContext = [[TVApplicationControllerContext alloc] init];
    

    NSURL *baseUrl = [[NSBundle mainBundle] URLForResource:@"images" withExtension:@""];

    NSURL *jsUrl = [baseUrl URLByAppendingPathComponent:@"application.js"];
    appControllerContext.javaScriptApplicationURL = jsUrl;
    
    //自定义loadingTemplate
    //自定义TVViewElement,并绑定javascript事件
    [TVElementFactory registerViewElementClass:[JSLoadingTemplateElement class] forElementName:@"loadingTemplate"];
    //建立扩展TVML的接口
    [TVInterfaceFactory sharedInterfaceFactory].extendedInterfaceCreator = self;
    
    appControllerContext.launchOptions = @{@"baseUrl":baseUrl.absoluteString};

    self.appController = [[TVApplicationController alloc] initWithContext:appControllerContext window:self.window delegate:self];
    return YES;
}


- (UIViewController *)viewControllerForElement:(TVViewElement *)element existingViewController:(UIViewController *)existingViewController {
    
    if ([element isKindOfClass:[JSLoadingTemplateElement class]]) {
        JSLoadingTemplateViewController *loadControllerElement;
        if (existingViewController) {
            loadControllerElement = (JSLoadingTemplateViewController *)existingViewController;
        }else {
            loadControllerElement = [[JSLoadingTemplateViewController alloc] init];
        }
        
        loadControllerElement.nightBool = false;
        ////<document><loadingTemplate title="加载中..." /></document>
        if (element.attributes[@"title"]) {
            loadControllerElement.titleLabel = element.attributes[@"title"];
        }
        return loadControllerElement;
    }
    
    return nil;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self executeRemoteMethod:@"onWillResignActive" completion: ^(BOOL success) {
        // ...
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self executeRemoteMethod:@"onDidEnterBackground" completion: ^(BOOL success) {
        // ...
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self executeRemoteMethod:@"onWillEnterForeground" completion: ^(BOOL success) {
        // ...
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self executeRemoteMethod:@"onDidBecomeActive" completion: ^(BOOL success) {
        // ...
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self executeRemoteMethod:@"onWillTerminate" completion: ^(BOOL success) {
        // ...
    }];
}

#pragma mark TVApplicationControllerDelegate

- (void)appController:(TVApplicationController *)appController didFinishLaunchingWithOptions:(nullable NSDictionary<NSString *, id> *)options {
}

- (void)appController:(TVApplicationController *)appController didFailWithError:(NSError *)error {
    NSLog(@"appController:didFailWithError: invoked with error: %@", error);
    
    NSString *title = @"App发生错误";
    NSString *message = error.localizedDescription;
    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [self.appController.navigationController presentViewController:alertController animated:YES completion: ^() {
        // ...
    }];
}

- (void)appController:(TVApplicationController *)appController didStopWithOptions:(nullable NSDictionary<NSString *, id> *)options {
    NSLog(@"appController:didStopWithOptions: invoked with options: %@", options);
}

- (void)appController:(TVApplicationController *)appController evaluateAppJavaScriptInContext:(JSContext *)jsContext {
    [jsContext setObject:self forKeyedSubscript:@"javascriptTools"];
    [jsContext setObject:[KitJSPlayer class] forKeyedSubscript:@"JSPlayer"];
    [jsContext setObject:[KitJSMediaItem class] forKeyedSubscript:@"JSMediaItem"];
    [jsContext setObject:[KitJSPlaylist class] forKeyedSubscript:@"JSPlaylist"];
    [jsContext setObject:[KitJSArray class] forKeyedSubscript:@"JSArray"];
}

@end
