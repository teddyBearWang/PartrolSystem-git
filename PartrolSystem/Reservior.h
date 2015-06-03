//
//  Reservior.h
//  PartrolSystem
////**********************水库水闸对象*************************
//  Created by teddy on 14-3-18.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reservior : NSObject

@property (nonatomic, strong) NSString *typeName; //设施类型
@property (nonatomic, strong) NSString *adcdName; //区域名字
@property (nonatomic) int objectType; //对象类型
@property (nonatomic) int uncheckNum; //未巡查数目

@end
