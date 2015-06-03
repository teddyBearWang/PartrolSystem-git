//
//  DetailReserviorController.m
//  PartrolSystem
// **************某一城镇下面的水库**************
//  Created by teddy on 14-3-20.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "DetailReserviorController.h"
#import "CCSegmentedControl.h"
#import "TownDetailResvior.h"
#import "SingleReserviorController.h"
#import "ASIFormDataRequest.h"
#import "Reservior.h"
#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface DetailReserviorController ()

@end

@implementation DetailReserviorController
@synthesize tableView = _tableView;
@synthesize imgView = _imgView;
@synthesize nameLabel = _nameLabel;
@synthesize adcdLabel = _adcdLabel;
@synthesize patrolStatusLabel = _patrolStatusLabel;
@synthesize dataArray = _dataArray;
@synthesize itemArray = _itemArray;
@synthesize reserviorModal = _reserviorModal;

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
    
    UIView *segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44+2)];
    [self.view addSubview:segmentView];
    
    self.reserviorModal = [ReserviorModal sharedReserviorModal];
    self.title = self.reserviorModal.titleString;
    self.dataArray = [NSMutableArray array];
    self.dataArray = self.reserviorModal.totalReserviorArray;
    self.itemArray = @[@"全部",@"未巡查",@"有隐患",@"已巡查"];
    CCSegmentedControl *segmentedCtrl = [[CCSegmentedControl alloc] initWithItems:self.itemArray];
    segmentedCtrl.frame = CGRectMake(0, 0, ScreenWidth, 44);
    //设置背景颜色
    segmentedCtrl.backgroundColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1];
    //阴影部分图片，不设置使用默认椭圆外观的stain
    segmentedCtrl.selectedStainView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stain"]];
    segmentedCtrl.selectedSegmentTextColor = [UIColor whiteColor];
    [segmentedCtrl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [segmentView addSubview:segmentedCtrl];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, 2)];
    imgView.image = [UIImage imageNamed:@"menu_line"];
    [segmentView addSubview:imgView];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+2, ScreenWidth, ScreenHeight-20-44-44-2) style:UITableViewStylePlain];
    //设置背景颜色
    self.tableView.backgroundColor = [UIColor colorWithRed:36/255.0 green:50/255.0 blue:65/255.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 120;
    [self.view addSubview:self.tableView];
    
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 0, 15, 20);
    [Btn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backAction
{
    if (_loading) {
        [[ASIHTTPRequest sharedQueue] cancelAllOperations];
        [SVProgressHUD dismiss];
        _loading = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

//segmentedCtrl Action
- (void)valueChanged:(id)sender
{
    //每次都要重新给self.dataArray赋值
    self.dataArray = self.reserviorModal.totalReserviorArray;
    NSMutableArray *selectedArray = [NSMutableArray array];
    CCSegmentedControl *segmentedCtrl = (CCSegmentedControl *)sender;
    NSString *contentString = (NSString *)[self.itemArray objectAtIndex:segmentedCtrl.selectedSegmentIndex];
    
    for (int i=0; i<self.dataArray.count; i++) {
        TownDetailResvior *detailReservior = [self.dataArray objectAtIndex:i];
        switch (segmentedCtrl.selectedSegmentIndex) {
            case 0:
                //全部水库
                [selectedArray addObject:detailReservior];
                break;
            case 1://未巡查
                if ([detailReservior.skContent isEqualToString:contentString]) {
                    [selectedArray addObject:detailReservior];
                }
                break;
            case 2:
                //有隐患
                if ([detailReservior.skContent isEqualToString:@"已巡查"] &&[detailReservior.skEvent intValue] !=0) {
                    [selectedArray addObject:detailReservior];
                }
                break;
            case 3://已巡查
                if ([detailReservior.skContent isEqualToString:contentString]) {
                    [selectedArray addObject:detailReservior];
                }
                break;
            default:
                break;
        }
    }
    self.dataArray = selectedArray;
    
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row <= self.dataArray.count) {
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ReserviorCell" owner:self options:nil] lastObject];
            self.imgView = (UIImageView *)[cell viewWithTag:201];
            self.imgView.layer.cornerRadius = 5.0f;
            self.imgView.layer.masksToBounds = YES;
            self.nameLabel = (UILabel *)[cell viewWithTag:202];
            self.nameLabel.font = [UIFont boldSystemFontOfSize:15];
            self.patrolStatusLabel = (UILabel *)[cell viewWithTag:203];
            self.patrolStatusLabel.font = [UIFont systemFontOfSize:13];
            self.adcdLabel = (UILabel *)[cell viewWithTag:204];
            self.adcdLabel.font = [UIFont systemFontOfSize:13];
        }
        
        TownDetailResvior *detailReservior = [self.dataArray objectAtIndex:indexPath.row];
        self.imgView.image = [UIImage imageNamed:@"river_small"];
        self.patrolStatusLabel.text = detailReservior.skContent;
        self.adcdLabel.text = detailReservior.skCode;
        self.nameLabel.text = detailReservior.skName;
        if ([detailReservior.skEvent intValue] != 0) {
            self.patrolStatusLabel.textColor = [UIColor redColor];
            self.adcdLabel.textColor = [UIColor redColor];
            self.nameLabel.textColor = [UIColor redColor];
        }else{
            self.patrolStatusLabel.textColor = [UIColor whiteColor];
            self.adcdLabel.textColor = [UIColor whiteColor];
            self.nameLabel.textColor = [UIColor whiteColor];
        }
    }else{
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            //  your code...
        }
    }
    //只显示cell的边框度，这样在没有cell的时候可以隐藏
   // cell.layer.borderWidth = 1.0f;
       return cell;
}

#pragma mark - UITableView Delegate
//selected cell action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TownDetailResvior *detailReservior = [self.dataArray objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    NSLog(@"参数两个是——类型：%@  编码：%@",detailReservior.objType,detailReservior.skCode);
    _passCode = detailReservior.skCode;
    [request setPostValue:@"SerSkInfo" forKey:@"t"];
    [request setPostValue:detailReservior.objType forKey:@"objtype"];
    [request setPostValue:_passCode forKey:@"type"];
    //发送一个异步请求
    [SVProgressHUD show];
    _loading = YES;
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
    _loading = NO;
    NSString *responseString = [request responseString];
    NSString *string1 = [responseString substringFromIndex:1];
    NSString *string2 = [string1 substringToIndex:string1.length - 1];
    NSString *jsonString = [string2 stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *singleReserviorArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    self.reserviorModal.singleArray = singleReserviorArray;
    SingleReserviorController *singleCtrl = [[SingleReserviorController alloc] init];
    singleCtrl.codeNum = _passCode;
    [self.navigationController pushViewController:singleCtrl animated:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
}
@end
