//
//  UserModal.m
//  PartrolSystem
//
//  Created by teddy on 14-3-20.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "UserModal.h"


static UserModal *userInstance = nil;
@implementation UserModal

+ (id)sharedUserModal
{
    //添加线程锁，防止其他类去修改
    @synchronized(self){
    
        if (userInstance == nil) {
            userInstance = [[[self class] alloc] init];
        }
    }
    return userInstance;
}

#pragma mark -- 
//覆写allocWithZone方法
+ (id)allocWithZone:(NSZone *)zone
{
    if (userInstance == nil) {
        userInstance = [super allocWithZone:zone];
    }
    return userInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return userInstance;
}

//覆盖retain方法
- (id)retain
{
    return userInstance;
}

//覆盖release方法
- (oneway void)release
{
    
}

-(id)autorelease
{
    return userInstance;
}

-(NSUInteger)retainCount
{
    return UINT_MAX;
}
@end
