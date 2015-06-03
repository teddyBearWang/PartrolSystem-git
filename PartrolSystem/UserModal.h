//
//  UserModal.h
//  PartrolSystem
//************************用户信息单例*******************************
//  Created by teddy on 14-3-20.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModal : NSObject

@property (nonatomic, strong) NSString *loginName;
@property (nonatomic, strong) NSString *loginPassWord;


+ (id)sharedUserModal;
@end
