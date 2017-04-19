//
//  NTOUToMRTTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "NTOUToMRTTableViewController.h"
#import "GoogleMapViewController.h"

@interface NTOUToMRTTableViewController ()

@end

@implementation NTOUToMRTTableViewController
@synthesize goBack;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    busData = @[@[@{@"name":@"工學院",@"first":@"15:20",@"second":@"17:15",@"longitude":@121.780073,@"latitude":@25.150531}
                  ,@{@"name":@"祥豐校區站",@"first":@"15:20",@"second":@"17:15",@"longitude":@121.773067,@"latitude":@25.149939}
                  ,@{@"name":@"人社院站",@"first":@"15:20",@"second":@"17:15",@"longitude":@121.775200,@"latitude":@25.149955}]
                ,@[@{@"name":@"啟聰學校",@"first":@"06:40",@"second":@"08:45",@"longitude":@121.513700,@"latitude":@25.074764}
                   ,@{@"name":@"酒泉街",@"first":@"06:40",@"second":@"08:45",@"longitude":@121.514442,@"latitude":@25.072068}
                   ,@{@"name":@"市立美術館",@"first":@"06:45",@"second":@"08:50",@"longitude":@121.524336,@"latitude":@25.07318}
                   ,@{@"name":@"捷運劍潭站",@"first":@"07:00",@"second":@"09:00",@"longitude":@121.52531,@"latitude":@25.084919}
                   ,@{@"name":@"士林行政中心",@"first":@"07:00",@"second":@"09:00",@"longitude":@121.520445,@"latitude":@25.092986}]];
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

    return [busData[goBack] count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NTOUtoMRTCells" forIndexPath:indexPath];
    
    if(indexPath.row == 0)
    {
        ((UILabel*)[cell viewWithTag:101]).text = @"站牌";
        ((UILabel*)[cell viewWithTag:101]).textColor = [UIColor blueColor];
        ((UILabel*)[cell viewWithTag:102]).text = @"第一班";
        ((UILabel*)[cell viewWithTag:102]).textColor = [UIColor blueColor];
        ((UILabel*)[cell viewWithTag:103]).text = @"第二班";
        ((UILabel*)[cell viewWithTag:103]).textColor = [UIColor blueColor];
    }
    else
    {
        ((UILabel*)[cell viewWithTag:101]).text = busData[goBack][indexPath.row - 1][@"name"];
        ((UILabel*)[cell viewWithTag:101]).textColor = [UIColor blackColor];
        ((UILabel*)[cell viewWithTag:102]).text = busData[goBack][indexPath.row - 1][@"first"];
        ((UILabel*)[cell viewWithTag:102]).textColor = [UIColor grayColor];
        ((UILabel*)[cell viewWithTag:103]).text = busData[goBack][indexPath.row - 1][@"second"];
        ((UILabel*)[cell viewWithTag:103]).textColor = [UIColor grayColor];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(!goBack)
            return @"海洋大學 -> 捷運劍潭站";
    else
            return @"捷運劍潭站 -> 海洋大學";

}

#pragma mark - Table view

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row > 0)
    {
        GoogleMapViewController* googleMap = [GoogleMapViewController new];
        [googleMap setLongitude:[busData[goBack][indexPath.row - 1][@"longitude"] doubleValue]  andLatitude:[busData[goBack][indexPath.row - 1][@"latitude"] doubleValue]  andZoom:18];
        googleMap.title = busData[goBack][indexPath.row - 1][@"name"];
        [googleMap setMark:busData[goBack][indexPath.row - 1][@"name"]];
        
        [self showViewController:googleMap sender:nil];
    }
}


@end
