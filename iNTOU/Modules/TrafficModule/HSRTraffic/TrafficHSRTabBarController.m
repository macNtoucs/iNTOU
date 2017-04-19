//
//  TrafficHSRTabBarController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/17.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TrafficHSRTabBarController.h"
#import "TrafficHSRTimeTableViewController.h"

@interface TrafficHSRTabBarController ()

@end

@implementation TrafficHSRTabBarController
@synthesize departure = _departure;
@synthesize destination = _destination;
@synthesize selectedDate,carClass,departureCode,destinationCode,dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init data
    dataArray = [[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HSRStationList" ofType:@"plist"]][@"stations"];
    self.departure = dataArray[0][@"nameZh"];
    departureCode = dataArray[0][@"StationCode"];
    self.destination = dataArray[1][@"nameZh"];
    destinationCode = dataArray[1][@"StationCode"];
    
    NSDate* date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyyMMdd"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    selectedDate = [formatter stringFromDate:date];
    
    UIBarButtonItem * swapStation = [[UIBarButtonItem alloc]initWithTitle:@"往返" style:UIBarButtonItemStylePlain target:self action:@selector(exchangeDepartureAndDestination)];
    self.navigationItem.rightBarButtonItem = swapStation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)exchangeDepartureAndDestination {
    NSString* temp = self.departure;
    self.departure = self.destination;
    self.destination = temp;
    temp = destinationCode;
    destinationCode = departureCode;
    departureCode = temp;
    
    if(self.selectedIndex == 3)
        [((TrafficHSRTimeTableViewController*)self.viewControllers[3]) downloadDataFromServer];
}

-(void)setDeparture:(NSString*)departure {
    _departure = departure;
    self.title = [[NSString alloc] initWithFormat:@"%@ -> %@",self.departure,self.destination];
}

-(void)setDestination:(NSString*)destination {
    _destination = destination;
    self.title = [[NSString alloc] initWithFormat:@"%@ -> %@",self.departure,self.destination];
}

-(NSString*)departure {
    return _departure;
}

-(NSString*)destination {
    return _destination;
}

@end
