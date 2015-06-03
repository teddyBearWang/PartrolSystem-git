//
//  ReserviorViewController.m
//  PartrolSystem
//
//***********************水库类型选择控制器*******************************
//  Created by teddy on 14-3-18.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "ReserviorViewController.h"
#import "TownReserviorController.h"
#import "CityViewController.h"
#import "ASIFormDataRequest.h"
#import "CountyViewController.h"
#import "DetailReserviorController.h"
#import "ReserviorModal.h"
#import "ReserviorButton.h"
#import "HYZBadgeView.h"
#import "Reservior.h"
#import "TownReservior.h"
#import "TownDetailResvior.h"
#import "HistoryViewController.h"
#import "SVProgressHUD.h"
#import "DangerViewController.h"

#define COLUMN 2
#define VIEWHEIGHT 120
#define VIEWWIDTH 120
#define BUTTONWIDTH 100
#define BUTTONHEIGTH 100

@interface ReserviorViewController ()

@end

@implementation ReserviorViewController
@synthesize imageArray = _imageArray;
@synthesize reserviorModal = _reserviorModal;
@synthesize userModal = _userModal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    //set backItem hidden
    [self.navigationItem setHidesBackButton:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1];
    self.reserviorModal = [ReserviorModal sharedReserviorModal];
    [self layoutView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }else{
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:29/255.0 green:37/255.0 blue:42/255.0 alpha:1.0f];
    }
    
    //创建UIBarButtonItem
    NSArray *imgArray = @[@"btn_history",@"menu"];
    NSArray *clickImgArray = @[@"btn_history_click",@"menu_click"];
    for (int i=0; i<imgArray.count; i++) {
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 30, 30);
        [button setImage:[UIImage imageNamed:[imgArray objectAtIndex:i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[clickImgArray objectAtIndex:i]] forState:UIControlStateHighlighted];
        [itemView addSubview:button];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:itemView];
        if (i == 0) {
            [button addTarget:self action:@selector(historyClickAction) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = item;
        }else{
            [button addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = item;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutView
{
      self.imageArray = @[@"option_sk",@"option_st",@"option_dfht",@"option_sz",@"option_hddm",@"option_dzzhd"];
    //获取中的行数
    NSUInteger total =self.reserviorModal.reserviorArray.count;
    for (int i=0; i<total; i++) {
        Reservior *reservior = (Reservior *)[self.reserviorModal.reserviorArray objectAtIndex:i];
        
        self.title = reservior.adcdName; // set title;
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        
        int row = i / COLUMN;//第几行
        int column = i % COLUMN; //第几列
        UIView *reserviorView = [[UIView alloc] initWithFrame:CGRectMake((30*(column+1))+VIEWWIDTH*column, (30*(row+1))+VIEWHEIGHT*row, VIEWWIDTH, VIEWHEIGHT)];
        
        [self.view addSubview:reserviorView];
        
        ReserviorButton *button = [ReserviorButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(5, 5, BUTTONWIDTH, BUTTONHEIGTH);
        button.selectNum = i; //判断点击了哪个button
        [button setImage:[UIImage imageNamed:[self.imageArray objectAtIndex:i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(butonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [reserviorView addSubview:button];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 110, BUTTONWIDTH, 14)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = reservior.typeName;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:13];
        [reserviorView addSubview:nameLabel];
        
        HYZBadgeView *badgeView = [[HYZBadgeView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        
        [badgeView setNumber:reservior.uncheckNum];
        //将数字标签添加在button上面
        [button addSubview:badgeView];
        
    }

}
#pragma  mark - UIBarButtonItemAction
//获取历史记录
- (void)historyClickAction
{
    if (_isload) {
        [[ASIHTTPRequest sharedQueue] cancelAllOperations];
        [SVProgressHUD dismiss];
        _isload =  NO;
    }
    HistoryViewController *historyCtrl = [[HistoryViewController alloc] init];
    [self.navigationController pushViewController:historyCtrl animated:YES];
}

//新的隐患消息
- (void)messageAction
{
    if (_isload) {
        [[ASIHTTPRequest sharedQueue] cancelAllOperations];
        [SVProgressHUD dismiss];
        _isload =  NO;
    }
    DangerViewController *danger = [[DangerViewController alloc] init];
    [self.navigationController pushViewController:danger animated:YES];
}
#pragma mark - private method
- (NSString *)getLvl:(NSString *)sender
{
    if (sender.length > 3 && sender.length < 6) {
        return @"3"; //市
    }else if (sender.length == 6){
        return @"4"; //县
    }else if (sender.length > 6 && sender.length < 10){
        return @"5"; //乡
    }else{
        return @"2";//省
    }
}

#pragma  mark -- button action method
- (void)butonClickAction:(id)sender
{
    ReserviorButton *button = (ReserviorButton *)sender;
    Reservior *reservior = (Reservior *)[self.reserviorModal.reserviorArray objectAtIndex:button.selectNum];
    ReserviorModal *modal = [ReserviorModal sharedReserviorModal];
    modal.selectedIndex = button.selectNum; //选择的第几个
    modal.titleString = reservior.adcdName;
    //将水库类型传递给单例
    modal.objType = [NSString stringWithFormat:@"%d",reservior.objectType];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //........添加webService参数
    self.userModal = [UserModal sharedUserModal];
    
    if ([[self getLvl:self.userModal.loginName] intValue] == 5) {
        //按照镇登陆
        [request setPostValue:@"SerEventInfo" forKey:@"t"];
        [request setPostValue:@"0" forKey:@"type"];
        [request setPostValue:self.userModal.loginName forKey:@"stcd"];
        [request setPostValue:modal.objType forKey:@"objtype"];
    }else{
        [request setPostValue:@"getObjInfo" forKey:@"t"];
        [request setPostValue:self.userModal.loginName  forKey:@"padcd"];
        [request setPostValue:modal.objType forKey:@"objtype"];
        [request setPostValue:[self getLvl:self.userModal.loginName] forKey:@"lvl"];
    }
    [request setDelegate:self];
    
    [SVProgressHUD showWithStatus:@"请求中..."];
    _isload = YES;
    //发送一个同步请求
    [request startAsynchronous];
  
}

#pragma mark - ASIHTTPRequestDelegate method
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    _isload = NO;
    int lvlNum = [[self getLvl:self.userModal.loginName] intValue];
    self.reserviorModal.cityArray = [NSMutableArray array];
    self.reserviorModal.townArray = [NSMutableArray array];
    self.reserviorModal.countyArray = [NSMutableArray array];
    self.reserviorModal.totalReserviorArray = [NSMutableArray array];
    if (request.responseStatusCode == 200) {
        NSString *responseString = [request responseString];
        NSString *jsonString1 = [responseString substringFromIndex:1];
        NSString *jsonString2 = [jsonString1 substringToIndex:jsonString1.length-1];
        //将字符串中的单引号替换成双引号
        NSString *jsonString3 = [jsonString2 stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        NSData *jsonData = [jsonString3 dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *townJsonArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
       
        //处理数据
        for (int i=0; i<townJsonArray.count; i++) {
            NSDictionary *townDic = (NSDictionary *)[townJsonArray objectAtIndex:i];
            if (lvlNum == 5) {
                //乡镇
                TownDetailResvior *detailReservior = [[TownDetailResvior alloc] init];
                detailReservior.skCode = [townDic objectForKey:@"Skcode"];
                detailReservior.skName = [townDic objectForKey:@"Skname"];
                detailReservior.objType = [townDic objectForKey:@"objtype"];
                detailReservior.skType = [townDic objectForKey:@"Sktype"];
                detailReservior.skContent = [townDic objectForKey:@"Skcontent"];
                detailReservior.skLng = [townDic objectForKey:@"Sklng"];
                detailReservior.skLat = [townDic objectForKey:@"Sklat"];
                detailReservior.skLngend = [townDic objectForKey:@"Sklngend"];
                detailReservior.skLatend = [townDic objectForKey:@"Sklatend"];
                detailReservior.skEvent = [townDic objectForKey:@"Skevent"];
                detailReservior.personID = [townDic objectForKey:@"PersonID"];
                detailReservior.skImg = [townDic objectForKey:@"Skimg"];
                
                [self.reserviorModal.totalReserviorArray addObject:detailReservior];
            }else{
                
                TownReservior *town = [[TownReservior alloc] init];
                //........获取各个乡镇的水库信息
                town.adcd = [townDic objectForKey:@"ADCD"];
                town.adcdName = [townDic objectForKey:@"ADCDName"];
                town.lvlName = [townDic objectForKey:@"LVL"];
                town.imgName = [townDic objectForKey:@"AdcdImg"];
                town.totalReserviorNum = [townDic objectForKey:@"adcdcount"];
                town.noPartolReserviorNum = [townDic objectForKey:@"nopatrol"];
                town.problemReserviorNum = [townDic objectForKey:@"haveconcerns"];
                
                NSString *peopleString = [townDic objectForKey:@"presideweb"];
                NSArray *peopleArray = [peopleString componentsSeparatedByString:@","];
                for (int j=0; j<peopleArray.count; j++) {
                    NSString *string = [peopleArray objectAtIndex:j];
                    //判断是否为空,若为空，则直接跳过
                    if (![string isEqualToString:@""]) {
                        if (j == 0) {
                            town.firstHeadName = [[string substringFromIndex:12] substringToIndex:[[string substringFromIndex:12] length]- 1];
                            town.firstHeadNumber = [string substringToIndex:11];
                        }else if (j==1){
                            town.secondHeadName = [[string substringFromIndex:12] substringToIndex:[[string substringFromIndex:12] length]- 1];
                            town.secondHeadNumber = [string substringToIndex:11];
                        }
                    }
                }
                
                if (lvlNum == 2) {
                    //按省份登陆
                    [self.reserviorModal.cityArray addObject:town];
                }else if(lvlNum == 4){
                    //按县登陆
                    [self.reserviorModal.townArray addObject:town];
                }else if (lvlNum == 3){
                    //按市登陆
                    [self.reserviorModal.countyArray addObject:town];
                }
            }
            
        }
        
        //按省份登陆
        if (lvlNum == 2) {
            //点击进入CityViewController
            CityViewController *cityReserviorCtrl = [[CityViewController alloc] init];
            [self.navigationController pushViewController:cityReserviorCtrl animated:YES];
        }else if(lvlNum == 4 ){
            //按县登陆，有哪些镇
         TownReserviorController *townReserviorCtrl = [[TownReserviorController alloc] init];
         [self.navigationController pushViewController:townReserviorCtrl animated:YES];
        }else if (lvlNum == 5){
            //按乡镇登陆，有哪些详细水库
            DetailReserviorController *detailCtrl = [[DetailReserviorController alloc] init];
            [self.navigationController pushViewController:detailCtrl animated:YES];
        }else if (lvlNum == 3){
            //按市登陆，有哪些县
            CountyViewController *countyCtrl = [[CountyViewController alloc] init];
            [self.navigationController pushViewController:countyCtrl animated:YES];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
}
@end
