//
//  TrafficHSRDateViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/17.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TrafficHSRDateViewController.h"
#import "FSCalendar.h"

@interface TrafficHSRDateViewController ()

@end

@implementation TrafficHSRDateViewController
@synthesize calendarHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    trafficHSRTabBarController = ((TrafficHSRTabBarController*)self.tabBarController);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exchangeDepartureAndDestination:(id)sender {
    [trafficHSRTabBarController exchangeDepartureAndDestination];
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
    
    trafficHSRTabBarController.selectedDate = [formatter stringFromDate:date];
}


@end
