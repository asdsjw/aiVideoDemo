//
//  KitJSPlaylist.m
//  aiVideo
//
//  Created by asdsjw on 16/9/28.
//  Copyright © 2016年 asdsjw. All rights reserved.
//
//2016-10-9
//不得已创建了一个JSArray,因为自带的数组受限只能达到850程度
#import "KitJSArray.h"

@implementation KitJSArray

- (id)init {
    self = [super init];
    if (self) {
        listArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)removeAllObjects {
    [listArray removeAllObjects];
}

//Objective-c中的Get方式
- (unsigned long long)length {
    return listArray.count;
}

//返回播放列表中的当前媒体项目
- (id)item:(long long)arg1 {
    
    if (listArray && listArray.count > 0 && arg1 < listArray.count) {
        return listArray[arg1];
    }
    
    return nil;
}

//返回最后一个媒体项目
- (id)pop {
    
    if (listArray && listArray.count > 0) {
        return listArray.lastObject;
    }
    
    return nil;
}

//往最后一个位置添加数据KitJSMediaItem
- (void)push:(id)arg1 {
    
    if (listArray) {
        [listArray addObject:arg1];
    }
}

//插入、删除或替换数组的元素
//splice第一个参数的添加删除位置
//splice第二个参数的是删除的数量,为0就是添加
- (id)splice:(long long)arg1 :(long long)arg2 :(id)arg3 {
    return nil;
}

@end
