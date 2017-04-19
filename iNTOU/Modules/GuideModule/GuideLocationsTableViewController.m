//
//  GuideLocationsTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "GuideLocationsTableViewController.h"
#import "GoogleMapViewController.h"

@interface GuideLocationsTableViewController ()

@end

@implementation GuideLocationsTableViewController
@synthesize guideLocationsTitle,guideLocationsData;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = guideLocationsTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [guideLocationsData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuideLocationsCells" forIndexPath:indexPath];
    
    cell.textLabel.text = guideLocationsData[indexPath.row][@"name"];
    cell.detailTextLabel.text = guideLocationsData[indexPath.row][@"id"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoogleMapViewController* googleMap = [GoogleMapViewController new];
    googleMap.title = guideLocationsData[indexPath.row][@"name"];
    [googleMap setLongitude:[guideLocationsData[indexPath.row][@"longitude"] doubleValue] andLatitude:[guideLocationsData[indexPath.row][@"latitude"] doubleValue] andZoom:17];
    [googleMap setMark:guideLocationsData[indexPath.row][@"name"]];
    
    [self showViewController:googleMap sender:nil];
}

@end
