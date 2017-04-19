//
//  TrafficTrainCarClassTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/17.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TrafficTrainCarClassTableViewController.h"

@interface TrafficTrainCarClassTableViewController ()

@end

@implementation TrafficTrainCarClassTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    trafficTrainTabBarController = ((TrafficTrainTabBarController*)self.tabBarController);
    trafficTrainTabBarController.carClass = 0;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:trafficTrainTabBarController.carClass inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:trafficTrainTabBarController.carClass inSection:0]].accessoryType = UITableViewCellAccessoryNone;
    trafficTrainTabBarController.carClass = indexPath.row;
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

@end
