//
//  TrafficTrainDateViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/17.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TrafficTrainDateViewController.h"
#import "FSCalendar.h"

@interface TrafficTrainDateViewController ()

@end

@implementation TrafficTrainDateViewController
@synthesize calendarHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    trafficTrainTabBarController = ((TrafficTrainTabBarController*)self.tabBarController);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exchangeDepartureAndDestination:(id)sender {
    [trafficTrainTabBarController exchangeDepartureAndDestination];
}

#pragma mark - FSCalender

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar {
    return [NSDate date];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *dateAfter44day = [cal dateByAddingUnit:NSCalendarUnitDay
                                       value:44
                                      toDate:[NSDate date]
                                     options:0];
    return dateAfter44day;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyyMMdd"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    trafficTrainTabBarController.selectedDate = [formatter stringFromDate:date];
}


@end
