//
//  TrafficExpressDetailTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/17.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TrafficExpressDetailTableViewController.h"

@interface TrafficExpressDetailTableViewController ()

@end

@implementation TrafficExpressDetailTableViewController
@synthesize expressName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = expressName;
    updater = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(downloadDataFromServer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:updater forMode:NSDefaultRunLoopMode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [updater fire];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [updater invalidate];
}

-(void)downloadDataFromServer {
    NSString* urlString = [[NSString alloc]initWithFormat:@"http://140.121.91.62/TrafficAPI_ver2.0/Bus/ExpressEstimateTime.php?name=%@",expressName];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data)
        {
            self->expressData = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
    [task resume];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [expressData[@"expressInfo"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpressDetailCells" forIndexPath:indexPath];
    
    ((UILabel*)[cell viewWithTag:101]).text = expressData[@"expressInfo"][indexPath.row][@"nameZh"];
    ((UILabel*)[cell viewWithTag:103]).text = expressData[@"expressInfo"][indexPath.row][@"EstimateTime"];
    
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
