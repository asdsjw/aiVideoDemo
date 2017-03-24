//
//  KitJSPlaylist.h
//  aiVideo
//
//  Created by asdsjw on 16/9/28.
//  Copyright © 2016年 asdsjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class NSString,NSNumber;

@protocol KitJSArray <JSExport>
@property(readonly, nonatomic) unsigned long long length;
-(void)removeAllObjects;
- (id)item:(long long)arg1;
- (NSArray *)splice:(long long)arg1 :(long long)arg2 :(JSValue *)arg3;
- (id)pop;
- (void)push:(id)arg1;
- (id)init;
@end

@interface KitJSArray : NSObject <KitJSArray>
{
    NSMutableArray *listArray;
}
@property(readonly, nonatomic) unsigned long long length;
- (id)item:(long long)arg1;
- (id)pop;
- (void)push:(id)arg1;
- (id)splice:(long long)arg1 :(long long)arg2 :(id)arg3;
-(void)removeAllObjects;
- (id)init;
@end
