//
//  TrafficHSRDestinationTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/17.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TrafficHSRDestinationTableViewController.h"
#import "TrafficHSRTabBarController.h"

@interface TrafficHSRDestinationTableViewController ()

@end

@implementation TrafficHSRDestinationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    trafficHSRTabBarController = ((TrafficHSRTabBarController*)self.tabBarController);
    
    dataArray = trafficHSRTabBarController.dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exchangeDepartureAndDestination:(id)sender {
    [trafficHSRTabBarController exchangeDepartureAndDestination];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrainDestinationCells" forIndexPath:indexPath];
    
    cell.textLabel.text = dataArray[indexPath.row][@"nameZh"];
    
    return cell;
}


#pragma mark - table view

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ((TrafficHSRTabBarController*)self.tabBarController).destination = dataArray[indexPath.row][@"nameZh"];
    ((TrafficHSRTabBarController*)self.tabBarController).destinationCode = dataArray[indexPath.row][@"StationCode"];
}

@end
