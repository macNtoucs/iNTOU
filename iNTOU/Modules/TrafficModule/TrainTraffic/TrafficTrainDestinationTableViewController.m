//
//  TrafficTrainDestinationTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/17.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TrafficTrainDestinationTableViewController.h"
#import "TrafficTrainTabBarController.h"

@interface TrafficTrainDestinationTableViewController ()

@end

@implementation TrafficTrainDestinationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    trafficTrainTabBarController = ((TrafficTrainTabBarController*)self.tabBarController);
    
    dataArray = trafficTrainTabBarController.dataArray;
    locationArray = trafficTrainTabBarController.locationArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exchangeDepartureAndDestination:(id)sender {
    [trafficTrainTabBarController exchangeDepartureAndDestination];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [locationArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [dataArray[section][@"stations"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrainDestinationCells" forIndexPath:indexPath];
    
    cell.textLabel.text = dataArray[indexPath.section][@"stations"][indexPath.row][@"nameZh"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return locationArray[section];
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
    return index;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return locationArray;
}

#pragma mark - table view

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ((TrafficTrainTabBarController*)self.tabBarController).destination = dataArray[indexPath.section][@"stations"][indexPath.row][@"nameZh"];
    ((TrafficTrainTabBarController*)self.tabBarController).destinationId = dataArray[indexPath.section][@"stations"][indexPath.row][@"station"];
}

@end
