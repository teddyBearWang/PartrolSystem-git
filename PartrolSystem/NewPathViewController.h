//
//  NewPathViewController.h
//  PartrolSystem
//
//  Created by teddy on 14-8-29.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReserviorModal.h"
#import "ASIHTTPRequest.h"
#import <ArcGIS/ArcGIS.h>

@interface NewPathViewController : UIViewController<ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
    ReserviorModal *_modal;
    NSMutableArray *pathArray; //路径对象数组
    AGSMapView *_mapView;
}

@property (nonatomic, strong) NSString *objcode; //工程编号；
@property (nonatomic, strong) NSString *date;    //选择的时间
@property (nonatomic, strong) AGSMapView *mapView;
@property (nonatomic, retain) AGSGraphicsLayer *drawLineLayer;

@end
