//
//  ReserviorModal.m
//  PartrolSystem
//
//*******************单例类**********************
//  Created by teddy on 14-3-18.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "ReserviorModal.h"

//申明一个静态实例，并且赋值为nil
static ReserviorModal *segtomInstance = nil;
@implementation ReserviorModal

//定义单例的类方法
+ (id)sharedReserviorModal
{
    //添加线程锁，防止其他类去修改
    @synchronized(self){
        
        if (segtomInstance == nil) {
            segtomInstance = [[[self class] alloc] init];
        }
    }
    return segtomInstance;
}

#pragma mark - 下面的方法是为了确保只有一个实例对象

//覆盖allocWithZone方法
+ (id)allocWithZone:(NSZone *)zone
{
    if (segtomInstance == nil) {
        segtomInstance = [super allocWithZone:zone];
    }
    
    return segtomInstance;
}

//覆盖copyWithZone方法
- (id)copyWithZone:(NSZone *)zone
{
    return segtomInstance;
}

//覆盖retain方法
- (id)retain
{
    return segtomInstance;
}

//覆盖release方法
- (oneway void)release
{
    
}

-(id)autorelease
{
    return segtomInstance;
}

-(NSUInteger)retainCount
{
    return UINT_MAX;
}
@end
