//
//  CountyViewController.m
//  PartrolSystem
//、、********************县级控制器********
//  Created by teddy on 14-3-28.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "CountyViewController.h"
#import "TownReserviorController.h"
#import "ASIFormDataRequest.h"
#import "TownReservior.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"

@interface CountyViewController ()

@end

@implementation CountyViewController
@synthesize  tableView = _tableView;
@synthesize reserviorModal = _reserviorModal;
@synthesize countyName = _countyName;
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
    }
    return self;
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44-20) style:UITableViewStylePlain];
    self.tableView.rowHeight = 130;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1];
    [self.view addSubview:self.tableView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 15, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction:(id)sender
{
    if (_isLoad) {
        [[ASIHTTPRequest sharedQueue] cancelAllOperations];
        [SVProgressHUD dismiss];
        _isLoad = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reserviorModal.countyArray.count ;
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
            
            self.countyName = (UILabel *)[cell viewWithTag:101];
            self.countyName.font = [UIFont systemFontOfSize:18];
            self.countyName.textAlignment = NSTextAlignmentCenter;
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
            self.firstNumLabel = (UIButton *)[cell viewWithTag:107];
            self.secondNumLabel = (UIButton *)[cell viewWithTag:108];
            [self.firstNumLabel addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
            [self.secondNumLabel addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
            
            self.firstNum = (UILabel *)[cell viewWithTag:301];
            self.secondNum = (UILabel *)[cell viewWithTag:302];
            self.bgView = (UIImageView *)[cell viewWithTag:1001];
        }
        
        TownReservior *county = [self.reserviorModal.countyArray objectAtIndex:indexPath.row];
        self.countyName.text = county.adcdName;
        self.totalReservior.text = [NSString stringWithFormat:@"总共有%@座水库",county.totalReserviorNum];
        if ([county.noPartolReserviorNum intValue] == 0) {
            self.noPatrolLabel.text = @"未巡查0座";
        }else{
            self.noPatrolLabel.text = [NSString stringWithFormat:@"未巡查%@座",county.noPartolReserviorNum];
        }
        
        if ([county.problemReserviorNum intValue] == 0) {
            self.problemLabel.text = @"存在隐患0座";
            if ([county.noPartolReserviorNum integerValue] == 0) {
                //全部巡查过并且没有隐患
                self.bgView.image = [UIImage imageNamed:@"menu_item_up_green"];
            }else{
            //没有巡查完，没有隐患
                self.bgView.image = [UIImage imageNamed:@"menu_item_up_yellow"];
            }
        }else{
            //接收的数据为“nil”,因此显示为空
            self.problemLabel.text = [NSString stringWithFormat:@"存在隐患%@座",county.problemReserviorNum];
            self.bgView.image = [UIImage imageNamed:@"menu_item_up_red"];
        }
        //若负责人为空或者号码空，则隐藏
        if (county.firstHeadName == nil && county.secondHeadName == nil) {
            self.firstNum.hidden = YES;
            self.secondNum.hidden = YES;
            self.firstNumLabel.hidden = YES;
            self.secondNumLabel.hidden = YES;
        }else if (county.secondHeadName == nil){
            self.secondNum.hidden = YES;
            self.secondNumLabel.hidden = YES;
        }
        self.firstNameLabel.text = county.firstHeadName;
        [self.firstNumLabel setTitle:county.firstHeadNumber forState:UIControlStateNormal];
        self.secondNameLabel.text = county.secondHeadName;
        [self.secondNumLabel setTitle:county.secondHeadNumber forState:UIControlStateNormal];
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

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TownReservior *county = [self.reserviorModal.countyArray objectAtIndex:indexPath.row    ];
    self.reserviorModal.titleString = county.adcdName;
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:WebServiceUrl]];
    request.delegate = self;
    [request setPostValue:@"getObjInfo" forKey:@"t"];
    [request setPostValue:self.reserviorModal.objType forKey:@"objtype"];
    [request setPostValue:[county.adcd substringToIndex:6] forKey:@"padcd"];
    [request setPostValue:[self getLvl:[county.adcd substringToIndex:6]] forKey:@"lvl"];
    
    //发送一个异步请求
    [SVProgressHUD show];
    _isLoad = YES;
    [request startAsynchronous];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//修改tableViewCell的背景颜色
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
        cell.backgroundColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
   
}
#pragma mark - ASIHTTPRequestDeledate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    _isLoad = NO;
    self.reserviorModal.townArray = [NSMutableArray array];
    if (request.responseStatusCode == 200) {
        NSString *responseString = [request responseString];
        NSString *jsonString1 = [responseString substringFromIndex:1];
        NSString *jsonString2 = [jsonString1 substringToIndex:jsonString1.length-1];
        //将字符串中的单引号替换成双引号
        NSString *jsonString3 = [jsonString2 stringByReplacingOccurrencesOfString:@"'" withString:@"\""];        
        NSData *jsonData = [jsonString3 dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *townJsonArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        
        for (int i=0; i<townJsonArray.count; i++) {
            TownReservior *town = [[TownReservior alloc] init];
            NSDictionary *townDic = (NSDictionary *)[townJsonArray objectAtIndex:i];
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
            [self.reserviorModal.townArray addObject:town];
        }
        //push to county controller
        TownReserviorController *townCtrl = [[TownReserviorController alloc] init];
        [self.navigationController pushViewController:townCtrl animated:YES];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
}

#pragma mark - buttonAction
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
