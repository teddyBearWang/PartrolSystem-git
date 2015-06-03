//
//  TownReserviorController.m
//  PartrolSystem
//*****************乡镇列表和水库数量******************************
//  Created by teddy on 14-3-19.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "TownReserviorController.h"
#import "DetailReserviorController.h"
#import "TownReservior.h"
#import "Reservior.h"
#import "ASIFormDataRequest.h"
#import "TownDetailResvior.h"
#import "Reservior.h"
#import "ReserviorButton.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"

@interface TownReserviorController ()

@end

@implementation TownReserviorController
@synthesize totalReserviorLabel = _totalReserviorLabel;
@synthesize townReserviorLabel  = _townReserviorLabel;
@synthesize noPartolReserviorLabel = _noPartolReserviorLabel;
@synthesize problemReserviorLabel = _problemReserviorLabel;
@synthesize firstHeadNameLabel = _firstHeadNameLabel;
@synthesize secondheadNameLabel = _secondheadNameLabel;
@synthesize firstHeadNumber = _firstHeadNumber;
@synthesize secondHeadNumber = _secondHeadNumber;
@synthesize tableView = _tableView;
@synthesize reserviorModal = _reserviorModal;
@synthesize firstName = _firstName;
@synthesize secondName = _secondName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
  
    self.reserviorModal = [ReserviorModal sharedReserviorModal];
    self.title = self.reserviorModal.titleString;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44-20) style:UITableViewStylePlain];
    //设置背景颜色
    self.tableView.backgroundColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 130;
    //设置没有分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 15, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popToCtrlAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)popToCtrlAction:(id)sender
{
    if (_isLoading) {
        [[ASIHTTPRequest sharedQueue] cancelAllOperations];
        [SVProgressHUD dismiss];
        _isLoading = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reserviorModal.townArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyCell";
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReserviorDetail" owner:self options:nil] lastObject];
         
         UIView *subView = (UIView *)[self.view viewWithTag:2000];
         subView.layer.masksToBounds = YES;
         subView.layer.borderWidth = 1.0f;
         subView.layer.cornerRadius = 5.0f;
         subView.layer.borderColor = [UIColor clearColor].CGColor;
         
        self.townReserviorLabel = (UILabel *)[cell viewWithTag:101];
        self.townReserviorLabel.font = [UIFont systemFontOfSize:16];
         self.townReserviorLabel.textAlignment = NSTextAlignmentCenter;
        self.totalReserviorLabel = (UILabel *)[cell viewWithTag:102];
        self.totalReserviorLabel.font = [UIFont systemFontOfSize:13];
        self.noPartolReserviorLabel = (UILabel *)[cell viewWithTag:103];
        self.noPartolReserviorLabel.font = [UIFont systemFontOfSize:13];
        self.problemReserviorLabel = (UILabel *)[cell viewWithTag:104];
        self.problemReserviorLabel.font = [UIFont systemFontOfSize:13];
        self.firstHeadNameLabel = (UILabel *)[cell viewWithTag:105];
        self.firstHeadNameLabel.font = [UIFont systemFontOfSize:12];
        self.secondheadNameLabel = (UILabel *)[cell viewWithTag:106];
        self.secondheadNameLabel.font = [UIFont systemFontOfSize:12];
         //电话号码标签
        self.firstHeadNumber = (UIButton *)[cell viewWithTag:107];
         self.firstHeadNumber.backgroundColor = [UIColor clearColor];
        self.secondHeadNumber = (UIButton *)[cell viewWithTag:108];
         [self.firstHeadNumber addTarget:self action:@selector(CallTelePhoneAction:) forControlEvents:UIControlEventTouchUpInside];
         [self.secondHeadNumber addTarget:self action:@selector(CallTelePhoneAction:) forControlEvents:UIControlEventTouchUpInside];
         
         //电话：（标签）
         self.firstName = (UILabel *)[cell viewWithTag:301];
         self.secondName = (UILabel *)[cell viewWithTag:302];
         self.bgView = (UIImageView *)[cell viewWithTag:1001];
    }
        TownReservior *town = [self.reserviorModal.townArray objectAtIndex:indexPath.row];
        self.townReserviorLabel.text = town.adcdName;
        self.totalReserviorLabel.text = [NSString stringWithFormat:@"总共%@座水库",town.totalReserviorNum];
        //全部巡查结束
        if ([town.noPartolReserviorNum intValue] == 0) {
            self.noPartolReserviorLabel.text = @"未巡查0座";
        }else{
            self.noPartolReserviorLabel.text = [NSString stringWithFormat:@"未巡查%@座",town.noPartolReserviorNum];
        }
    
        if ([town.problemReserviorNum intValue] == 0) {
            self.problemReserviorLabel.text = @"存在隐患0座";
            
            if ([town.noPartolReserviorNum intValue] == 0) {
                //全部巡查完并且没有隐患
                self.bgView.image = [UIImage imageNamed:@"menu_item_up_green"];
            }else{
                //设置相应的颜色
                self.bgView.image = [UIImage imageNamed:@"menu_item_up_yellow"];
            }
        }else{
            //接收的数据为“nil”,因此显示为空
            self.problemReserviorLabel.text = [NSString stringWithFormat:@"存在隐患%@座",town.problemReserviorNum];
            self.bgView.image = [UIImage imageNamed:@"menu_item_up_red"];
        }
        //若负责人为空或者号码空，则隐藏
        if (town.firstHeadName == nil && town.secondHeadName == nil) {
            self.firstName.hidden = YES;
            self.secondName.hidden = YES;
            self.secondHeadNumber.hidden = YES;
            self.firstHeadNumber.hidden = YES;
        }else if (town.secondHeadName == nil){
            self.secondName.hidden = YES;
            self.secondHeadNumber.hidden = YES;
        }
        self.firstHeadNameLabel.text = town.firstHeadName;
        [self.firstHeadNumber setTitle:town.firstHeadNumber forState:UIControlStateNormal];
        self.secondheadNameLabel.text = town.secondHeadName;
        [self.secondHeadNumber setTitle:town.secondHeadNumber forState:UIControlStateNormal];
    return cell;
}

#pragma mark - UITableView delegate method
//push to another controller
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    TownReservior *town = [self.reserviorModal.townArray objectAtIndex:indexPath.row];
    self.reserviorModal.titleString = town.adcdName;
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //........添加webService参数
    [request setPostValue:@"SerEventInfo" forKey:@"t"];
    [request setPostValue:@"0" forKey:@"type"];
    [request setPostValue:town.adcd forKey:@"stcd"];
    Reservior *reservior = [self.reserviorModal.reserviorArray objectAtIndex:self.reserviorModal.selectedIndex];
    [request setPostValue:[NSString stringWithFormat:@"%d",reservior.objectType] forKey:@"objtype"];
    request.delegate = self;
    //发送一个异步请求
    [SVProgressHUD show];
    _isLoading = YES;
    [request startAsynchronous];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1];
}
#pragma mark - ASIHTTPRequestDelegate method
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    _isLoading = NO;
    if (request.responseStatusCode == 200) {
        NSString *responseString = [request responseString];
        NSString *string1 = [responseString substringFromIndex:1];
        NSString *string2 = [string1 substringToIndex:string1.length - 1];
        //将字符串中的单引号替换成双引号
        NSString *jsonString = [string2 stringByReplacingOccurrencesOfString:@"'" withString:@"\""];        
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *reserviorArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        
        self.reserviorModal.totalReserviorArray = [NSMutableArray array];
        for (int i=0; i<reserviorArray.count; i++) {
            NSDictionary *reserviorDic = [reserviorArray objectAtIndex:i];
            TownDetailResvior *detailReservior = [[TownDetailResvior alloc] init];
            detailReservior.skCode = [reserviorDic objectForKey:@"Skcode"];
            detailReservior.skName = [reserviorDic objectForKey:@"Skname"];
            detailReservior.objType = [reserviorDic objectForKey:@"objtype"];
            detailReservior.skType = [reserviorDic objectForKey:@"Sktype"];
            detailReservior.skContent = [reserviorDic objectForKey:@"Skcontent"];
            detailReservior.skLng = [reserviorDic objectForKey:@"Sklng"];
            detailReservior.skLat = [reserviorDic objectForKey:@"Sklat"];
            detailReservior.skLngend = [reserviorDic objectForKey:@"Sklngend"];
            detailReservior.skLatend = [reserviorDic objectForKey:@"Sklatend"];
            detailReservior.skEvent = [reserviorDic objectForKey:@"Skevent"];
            detailReservior.personID = [reserviorDic objectForKey:@"PersonID"];
            detailReservior.skImg = [reserviorDic objectForKey:@"Skimg"];
            [self.reserviorModal.totalReserviorArray addObject:detailReservior];
        }
        DetailReserviorController *detailReserviorCtrl = [[DetailReserviorController alloc] init];
        [self.navigationController pushViewController:detailReserviorCtrl animated:YES];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
}


#pragma mark - Button Action
//点击电话按钮触发的方法
- (void)CallTelePhoneAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *numberString = [button currentTitle];
    UIWebView *callView = [[UIWebView alloc] init];
    NSString *teleUrl = [NSString stringWithFormat:@"tel://%@",numberString];
    NSURL *url = [NSURL URLWithString:teleUrl];
    [callView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:callView];
    NSLog(@"您拨打得号码是：%@",numberString);
}
@end
