//
//  PathObject.h
//  PartrolSystem
// //********************巡查轨迹对象（包含经纬度属性）*****************
//  Created by teddy on 14-4-16.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathObject : NSObject

@property (nonatomic, strong) NSString *lng; //精度
@property (nonatomic, strong) NSString *lat; //纬度
@property (nonatomic, strong) NSString *sDatetime;
@property (nonatomic, strong) NSString *isIn;
@property (nonatomic, strong) NSString *itTime;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *sevent;
@property (nonatomic, strong) NSString *sbeiZhu;
@end
