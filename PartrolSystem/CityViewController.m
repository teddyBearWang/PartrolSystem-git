//
//  CityViewController.m
//  PartrolSystem
//**********************登陆省份情况下的市控制器**********************
//  Created by teddy on 14-3-24.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "CityViewController.h"
#import "TownReservior.h"
#import "ASIFormDataRequest.h"
#import "CountyViewController.h"
#import  <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"


@interface CityViewController ()

@end

@implementation CityViewController
@synthesize tableView = _tableView;
@synthesize reserviorModal = _reserviorModal;
@synthesize cityName = _cityName;
@synthesize totalReservior = _totalReservior;
@synthesize noPatrolLabel = _noPatrolLabel;
@synthesize problemLabel = _problemLabel;
@synthesize firstNameLabel = _firstNameLabel;
@synthesize firstNumLabel = _firstNumLabel;
@synthesize firstNum = _firstNum;
@synthesize secondNameLabel = _secondNameLabel;
@synthesize secondNumLabel = _secondNumLabel;
@synthesize secondNum = _secondNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // _isload = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
   
    self.reserviorModal = [ReserviorModal sharedReserviorModal];
    self.title = self.reserviorModal.titleString;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44) style:UITableViewStylePlain];
    //设置背景颜色
    self.tableView.backgroundColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1];
    self.tableView.rowHeight = 130;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //tableView没有分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 15, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - privationAction
//返回前一个视图控制器
- (void)backAction
{
    if (_isload == YES) {
        [[ASIHTTPRequest sharedQueue] cancelAllOperations];
        [SVProgressHUD dismiss];
        _isload = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reserviorModal.cityArray.count;
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
            subView.layer.cornerRadius = 6.0f;
            subView.layer.borderColor = [UIColor clearColor].CGColor;
            
            self.cityName = (UILabel *)[cell viewWithTag:101];
            self.cityName.font = [UIFont systemFontOfSize:18];
            self.cityName.textAlignment = NSTextAlignmentCenter;
            self.totalReservior = (UILabel *)[cell viewWithTag:102];
            self.totalReservior.font = [UIFont systemFontOfSize:13];
            self.noPatrolLabel = (UILabel *)[cell viewWithTag:103];
            self.noPatrolLabel.font = [UIFont systemFontOfSize:13];
            self.problemLabel = (UILabel *)[cell viewWithTag:104];
            self.problemLabel.font = [UIFont systemFontOfSize:13];
            self.firstNameLabel = (UILabel *)[cell viewWithTag:105];
            self.firstNameLabel.font = [UIFont systemFontOfSize:12];
            self.secondNameLabel = (UILabel *)[cell viewWithTag:106];
            self.secondNameLabel.font = [UIFont systemFontOfSize:12];
            //电话号码button
            self.firstNumLabel = (UIButton *)[cell viewWithTag:107];
            self.firstNumLabel.backgroundColor = [UIColor clearColor];
            self.secondNumLabel = (UIButton *)[cell viewWithTag:108];
            [self.firstNumLabel addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
            [self.secondNumLabel addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
            
            //标签：（电话：）
            self.firstNum = (UILabel *)[cell viewWithTag:301];
            self.secondNum = (UILabel *)[cell viewWithTag:302];
            self.bgView = (UIImageView *)[cell viewWithTag:1001];
           
        }
        TownReservior *town = [self.reserviorModal.cityArray objectAtIndex:indexPath.row];
        self.cityName.text = town.adcdName;
        self.totalReservior.text = [NSString stringWithFormat:@"总共%@座水库",town.totalReserviorNum];
        //若是全部巡查结束
        if ([town.noPartolReserviorNum intValue] == 0) {
            self.noPatrolLabel.text = @"未巡查0座";
        }else{
            self.noPatrolLabel.text = [NSString stringWithFormat:@"未巡查%@座",town.noPartolReserviorNum];
        }
    
        if ([town.problemReserviorNum intValue] == 0) {
            self.problemLabel.text = @"存在隐患0座";
            if ([town.noPartolReserviorNum integerValue] == 0) {
                //全部巡查过并且没有隐患
                self.bgView.image = [UIImage imageNamed:@"menu_item_up_green"];
            }else{
            //没有巡查完，没有隐患
                self.bgView.image = [UIImage imageNamed:@"menu_item_up_yellow"];
            }
        }else{
            //接收的数据为“nil”,因此显示为空
            self.problemLabel.text = [NSString stringWithFormat:@"存在隐患%@座",town.problemReserviorNum];
            self.bgView.image = [UIImage imageNamed:@"menu_item_up_red"];
        }
        //若负责人为空或者号码空，则隐藏
        if (town.firstHeadName == nil && town.secondHeadName == nil) {
            self.firstNum.hidden = YES;
            self.secondNum.hidden = YES;
            self.secondNumLabel.hidden = YES;
            self.firstNumLabel.hidden = YES;
        }else if (town.secondHeadName == nil){
            self.secondNum.hidden = YES;
            self.secondNumLabel.hidden = YES;
        }
        self.firstNameLabel.text = town.firstHeadName;
        [self.firstNumLabel setTitle:town.firstHeadNumber forState:UIControlStateNormal];
        self.secondNameLabel.text = town.secondHeadName;
        [self.secondNumLabel setTitle:town.secondHeadNumber forState:UIControlStateNormal];
    return cell;
}

#pragma mark - private method
- (NSString *)getLvl:(NSString *)sender
{
    if (sender.length > 3 && sender.length < 6) {
        return @"3";
    }else if (sender.length == 6){
        return @"4";
    }else if (sender.length > 6 && sender.length < 10){
        return @"5";
    }else{
        return @"2";
    }
}

#pragma mark - UITableView Deletage
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TownReservior *town = [self.reserviorModal.cityArray objectAtIndex:indexPath.row];
    self.reserviorModal.titleString = town.adcdName;
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //........添加webService参数
    [request setPostValue:@"getObjInfo" forKey:@"t"];
    [request setPostValue:[town.adcd substringToIndex:4] forKey:@"padcd"];
    [request setPostValue:self.reserviorModal.objType forKey:@"objtype"];
    [request setPostValue:[self getLvl:[town.adcd substringToIndex:4]] forKey:@"lvl"];
    [request setDelegate:self];
    //发送一个异步请求
    [SVProgressHUD show];
    _isload = YES; //表示正在加载网络数据
    [request startAsynchronous];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1];
}

#pragma mark - ASIHTTPRequestDeledate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    _isload = NO;
    if (request.responseStatusCode == 200) {
        self.reserviorModal.countyArray = [NSMutableArray array];
        NSString *response = [request responseString];        
        NSString *string1 = [response substringFromIndex:1];
        NSString *string2 = [string1 substringToIndex:string1.length - 1];
        NSString *jsonString = [string2 stringByReplacingOccurrencesOfString:@"'" withString:@"\""];        
        NSData *jsondata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *countyArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableLeaves error:nil];
        
        for (int i=0; i<countyArray.count; i++) {
            NSDictionary *countyDic = (NSDictionary*)[countyArray objectAtIndex:i];
            TownReservior *county = [[TownReservior alloc] init];
            county.adcd = [countyDic objectForKey:@"ADCD"];
            county.adcdName = [countyDic objectForKey:@"ADCDName"];
            county.lvlName = [countyDic objectForKey:@"LVL"];
            county.imgName = [countyDic objectForKey:@"AdcdImg"];
            county.totalReserviorNum = [countyDic objectForKey:@"adcdcount"];
            county.noPartolReserviorNum = [countyDic objectForKey:@"nopatrol"];
            county.problemReserviorNum = [countyDic objectForKey:@"haveconcerns"];
        
            NSString *peopleString = [countyDic objectForKey:@"presideweb"];
            NSArray *peopleArray = [peopleString componentsSeparatedByString:@","];
            for (int j=0; j<peopleArray.count; j++) {
                NSString *string = [peopleArray objectAtIndex:j];
                if (![string isEqualToString:@""]) {
                    if (j == 0) {
                        county.firstHeadName = [[string substringFromIndex:12] substringToIndex:[[string substringFromIndex:12] length]- 1];
                        county.firstHeadNumber = [string substringToIndex:11];
                    }else if (j==1){
                        county.secondHeadName = [[string substringFromIndex:12] substringToIndex:[[string substringFromIndex:12] length]- 1];
                        county.secondHeadNumber = [string substringToIndex:11];
                    }
                }
            }
            
            [self.reserviorModal.countyArray addObject:county];
        }
        
        //push to county controller
        CountyViewController *countyCtrl = [[CountyViewController alloc] init];
        [self.navigationController pushViewController:countyCtrl animated:YES];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{

    [SVProgressHUD dismiss];
}

#pragma mark - play phone call action
//拨打电话
- (void)callPhone:(id)sender
{
    UIButton *button = (UIButton *)sender;
    UIWebView *callView = [[UIWebView alloc] init];
    //获取button上面的号码
    NSString *teleNumber = [button currentTitle];
    NSString *teleUrl = [NSString stringWithFormat:@"tel://%@",teleNumber];
    NSURL *url = [NSURL URLWithString:teleUrl];
    [callView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:callView];
}

@end
