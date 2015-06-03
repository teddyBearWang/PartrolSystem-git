//
//  NewPathViewController.m
//  PartrolSystem
//
//  Created by teddy on 14-8-29.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "NewPathViewController.h"
#import "ASIFormDataRequest.h"
#import "PathObject.h"
#import "SVProgressHUD.h"

@interface NewPathViewController ()
{
}

@end


@implementation NewPathViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"巡查轨迹";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationItem setHidesBackButton:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = back;
    
    _modal = [ReserviorModal sharedReserviorModal];
    [self getWebServiceData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//在地图上画线
- (void)initGoogleMapPolyAction:(NSArray *)pointArray
{
    if (pointArray.count == 0) {
        return;
    }
    
    AGSSpatialReference *sr = [AGSSpatialReference spatialReferenceWithWKID:102100];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:pointArray.count];
    //转换经纬度
    for (int i=0; i<pointArray.count; i++) {
        PathObject *path = [pointArray objectAtIndex:i];
        AGSPoint *point = [self lonLat2Mercator:[path.lng floatValue] :[path.lat floatValue]];
        [arr addObject:point];
    }
    
    self.mapView = [[AGSMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:self.mapView];
    NSURL *mapUrl = [NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer"];
	AGSTiledMapServiceLayer *tiledLyr = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:mapUrl];
	[self.mapView addMapLayer:tiledLyr withName:@"Tiled Layer"];
    
    //加载bing地图层
    NSString *bingMapkey = @"Alec4E58KHHP0ry9yxJRe0OJFtPQVPQ_Pz6-ESf5F675evXeq9JYUlxRD8748mdN";
   // NSString *bingMapkey = @"Anp5fmvc2pyJHTIzEDQEfRVk0kch7vTI2XgFB-XhBP-hdzbiwOZz-uXErlkHWhWR";
    AGSBingMapLayer *bingmayer = [[AGSBingMapLayer alloc] initWithAppID:bingMapkey style:AGSBingMapLayerStyleAerialWithLabels];
    [self.mapView addMapLayer:bingmayer withName:@"BingMapLayer"];
    
    AGSPoint *point1 = [arr objectAtIndex:0];
    AGSPoint *point2 = [arr objectAtIndex:(arr.count/2)];
    //范围
    
	AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:point1.x
												ymin:point1.y
												xmax:point2.x
												ymax:point2.y
									spatialReference:sr];

	[self.mapView zoomToEnvelope:env animated:YES];
  
    self.drawLineLayer = [AGSGraphicsLayer graphicsLayer];
	[self.mapView addMapLayer:self.drawLineLayer withName:@"DrawLineLayer"];
    
    int count = (int)[arr count];
	if ( count> 1) {
        
        AGSMutablePolyline *polyLine = [[AGSMutablePolyline alloc] initWithSpatialReference:self.mapView.spatialReference];
        [polyLine addPathToPolyline];
        for (int i = 0; i < count; i++) {
			[polyLine addPointToPath:[arr objectAtIndex:i]];
        }
        
        AGSSimpleLineSymbol* myOutlineSymbol = [AGSSimpleLineSymbol simpleLineSymbol];
        myOutlineSymbol.color = [UIColor redColor];
        myOutlineSymbol.width = 2;
        myOutlineSymbol.style = AGSSimpleLineSymbolStyleSolid;
        
        AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:polyLine symbol:myOutlineSymbol attributes:nil];
        
        [self.drawLineLayer addGraphic:graphic];
    }
}

//经纬度转墨卡托坐标系
- (AGSPoint *)lonLat2Mercator:(float)x :(float)y
{
    AGSSpatialReference *sr = [AGSSpatialReference spatialReferenceWithWKID:102100];
    double x1 = x * 20037508.34/180;
    double y1 = log(tan((90+y)*M_PI/360))/(M_PI/180);
    y1 = y1 * 20037508.34/180;
    AGSPoint *point = [[AGSPoint alloc] initWithX:x1 y:y1 spatialReference:sr];
    return point ;
}

//获取网络数据
- (void)getWebServiceData
{
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.delegate = self;
    [request setPostValue:@"getPath" forKey:@"t"];
    [request setPostValue:_modal.objType forKey:@"objtype"];
    [request setPostValue: self.objcode forKey:@"type"];
    [request setPostValue:self.date forKey:@"date"];
    [SVProgressHUD showWithStatus:@"地图加载中.."];
    [request startAsynchronous];
    
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    if (request.responseStatusCode == 200) {
        NSString *string = [request responseString];
        NSString *jsonString = [[string substringFromIndex:1] substringToIndex:[string substringFromIndex:1].length - 1];
        NSString *jsonString1 = [jsonString stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        NSData *jsondata = [jsonString1 dataUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableLeaves error:nil];
        
        pathArray = [NSMutableArray arrayWithCapacity:jsonArray.count];
        for (int i=0; i<jsonArray.count; i++) {
            PathObject *pathObject = [[PathObject alloc] init];
            NSDictionary *jsonDic = [jsonArray objectAtIndex:i];
            pathObject.lng = [jsonDic objectForKey:@"lng"];
            pathObject.lat = [jsonDic objectForKey:@"lat"];
            pathObject.sDatetime = [jsonDic objectForKey:@"Sdatetime"];
            pathObject.isIn = [jsonDic objectForKey:@"ISIn"];
            pathObject.itTime = [jsonDic objectForKey:@"itime"];
            pathObject.eventType = [jsonDic objectForKey:@"Eventtype"];
            pathObject.sevent = [jsonDic objectForKey:@"Sevent"];
            pathObject.sbeiZhu = [jsonDic objectForKey:@"Sbeizhu"];
            [pathArray addObject:pathObject];
        }
        if (pathArray.count != 0) {
            [self initGoogleMapPolyAction:pathArray];
        }else{
            //没有坐标点
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有坐标点和巡查轨迹" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegateMethod
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
