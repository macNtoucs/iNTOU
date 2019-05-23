//
//  TrafficBusRouteTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/14.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TrafficBusRouteTableViewController.h"

@interface TrafficBusRouteTableViewController ()

@end

@implementation TrafficBusRouteTableViewController
@synthesize name,routeId,city,titleMain,titleSub,departureZh,destinationZh;

- (void)viewDidLoad {
    [super viewDidLoad];
    titleMain.text = name;
    titleSub.text = [[NSString alloc] initWithFormat:@"%@ -> %@",departureZh,destinationZh];

    updater = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(downloadDataFromServer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:updater forMode:NSDefaultRunLoopMode];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadDataFromServer {
    NSString* urlString = [[NSString alloc]initWithFormat:@"http://140.121.91.62/TrafficAPI_ver2.0/Bus/BusRouteEstimateTime.php?id=%@&city=%@&goBack=%d",routeId,city,goBack];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        self->routeData = nil;
        if(data)
            self->routeData = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    [task resume];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [updater fire];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [updater invalidate];
}

- (IBAction)changeGoBack:(UIButton *)sender {
    if(goBack) {
        goBack = 0;
        titleSub.text = [[NSString alloc] initWithFormat:@"%@ -> %@",departureZh,destinationZh];
    }
    else {
        goBack = 1;
        titleSub.text = [[NSString alloc] initWithFormat:@"%@ -> %@",destinationZh,departureZh];
    }
    [updater fire];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //有資料的狀況
    if(routeData) {
        if([routeData[@"routeInfo"] count] != 0) {
            self.tableView.backgroundView = nil;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            return 1;
        }
        else {
            //這個方向沒有資料
            goBack = !goBack;
            [self downloadDataFromServer];
        }
        
    }
    
    //網路不穩的狀況
    UILabel* messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.height)];
    messageLabel.text = @"連線中！";
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.backgroundView = messageLabel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [routeData[@"routeInfo"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrafficRouteCells" forIndexPath:indexPath];
    
    ((UILabel*)[cell viewWithTag:101]).text = routeData[@"routeInfo"][indexPath.row][@"nameZh"];
    ((UILabel*)[cell viewWithTag:103]).text = routeData[@"routeInfo"][indexPath.row][@"EstimateTime"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"每五秒自動更新";
            break;
            
        default:
            return nil;
            break;
    }
}


@end
