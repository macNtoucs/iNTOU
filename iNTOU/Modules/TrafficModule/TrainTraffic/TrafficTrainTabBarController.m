//
//  TrafficTrainTabBarController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/17.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TrafficTrainTabBarController.h"
#import "TrafficTrainTimeTableViewController.h"

@interface TrafficTrainTabBarController ()

@end

@implementation TrafficTrainTabBarController
@synthesize departure = _departure;
@synthesize destination = _destination;
@synthesize selectedDate,carClass,departureId,destinationId,dataArray,locationArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init data
    dataArray = [[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TrainStationList" ofType:@"plist"]][@"locations"];
    self.departure = dataArray[0][@"stations"][0][@"nameZh"];
    departureId = dataArray[0][@"stations"][0][@"station"];
    self.destination = dataArray[0][@"stations"][1][@"nameZh"];
    destinationId = dataArray[0][@"stations"][1][@"station"];
    
    NSDate* date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyyMMdd"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    selectedDate = [formatter stringFromDate:date];
    
    NSMutableArray* locationArrayTemp = [NSMutableArray new];
    
    for(NSDictionary* location in dataArray)
        [locationArrayTemp addObject:location[@"locationZh"]];
    
    locationArray = [locationArrayTemp copy];
    
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
    temp = destinationId;
    destinationId = departureId;
    departureId = temp;
    
    if(self.selectedIndex == 4)
        [((TrafficTrainTimeTableViewController*)self.viewControllers[4]) downloadDataFromServer];
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
