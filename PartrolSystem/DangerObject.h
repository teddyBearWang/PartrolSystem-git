//
//  DangerObject.h
//  PartrolSystem
// ******************历史隐患对象*************
//  Created by teddy on 14-4-24.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DangerObject : NSObject

@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *objCode;
@property (nonatomic, strong) NSString *objName;
@property (nonatomic, strong) NSString *objType;
@property (nonatomic, strong) NSString *eventTime;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *ps;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *voiceUrl;
@property (nonatomic, strong) NSString *objUrl;
@property (nonatomic, strong) NSString *personName;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *locationName;;



@end
