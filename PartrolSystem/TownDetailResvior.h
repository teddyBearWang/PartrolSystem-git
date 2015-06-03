//
//  TownDetailResvior.h
//  PartrolSystem
//*****************乡镇级别最详细的水库对象(包括坐标)*******************************
//  Created by teddy on 14-3-24.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TownDetailResvior : NSObject

@property (nonatomic, strong) NSString *skCode;
@property (nonatomic, strong) NSString *skName;
@property (nonatomic, strong) NSString *objType;
@property (nonatomic, strong) NSString *skType;
@property (nonatomic, strong) NSString *skContent;
@property (nonatomic, strong) NSString *skLng;
@property (nonatomic, strong) NSString *skLat;
@property (nonatomic, strong) NSString *skLngend;
@property (nonatomic, strong) NSString *skLatend;
@property (nonatomic, strong) NSString *skEvent;
@property (nonatomic, strong) NSString *personID;
@property (nonatomic, strong) NSString *skImg;
@end
