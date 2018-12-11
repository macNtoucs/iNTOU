//
//  TrafficTrainTimeTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/20.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TrafficTrainTimeTableViewController.h"

@interface TrafficTrainTimeTableViewController ()

@end

@implementation TrafficTrainTimeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    trafficTrainTabBarController = ((TrafficTrainTabBarController*)self.tabBarController);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    trainData = nil;
    [self.tableView reloadData];
    [self downloadDataFromServer];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadDataFromServer {
    MBProgressHUD*hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.removeFromSuperViewOnHide = true;
    hud.label.text = @"下載中";
    
    NSString* urlString = [[NSString alloc]initWithFormat:@"http://140.121.91.62/TrafficAPI_ver2.0/Train/TrainTime.php?startId=%@&endId=%@&date=%@&car=%ld",
                           trafficTrainTabBarController.departureId,trafficTrainTabBarController.destinationId,trafficTrainTabBarController.selectedDate,(long)trafficTrainTabBarController.carClass];
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data)
        {
            self->trainData = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
        });
    }];
    [task resume];
    NSLog(@"%@", trainData);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [trainData[@"trainInfo"] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrainTimeCells" forIndexPath:indexPath];
    
    if(indexPath.row == 0)
    {
        ((UILabel*)[cell viewWithTag:101]).text = @"車次";
        ((UILabel*)[cell viewWithTag:102]).text = @"車種";
        ((UILabel*)[cell viewWithTag:103]).text = trafficTrainTabBarController.departure;
        ((UILabel*)[cell viewWithTag:104]).text = trafficTrainTabBarController.destination;
        ((UILabel*)[cell viewWithTag:105]).text = @"";
    }
    else
    {
        ((UILabel*)[cell viewWithTag:101]).text = trainData[@"trainInfo"][indexPath.row - 1][@"trainNumber"];
        ((UILabel*)[cell viewWithTag:102]).text = trainData[@"trainInfo"][indexPath.row - 1][@"carClass"];
        ((UILabel*)[cell viewWithTag:103]).text = trainData[@"trainInfo"][indexPath.row - 1][@"departureTime"];
        ((UILabel*)[cell viewWithTag:104]).text = trainData[@"trainInfo"][indexPath.row - 1][@"arriveTime"];
        ((UILabel*)[cell viewWithTag:105]).text = trainData[@"trainInfo"][indexPath.row - 1][@"note"];
    }
    
    return cell;
}

@end
