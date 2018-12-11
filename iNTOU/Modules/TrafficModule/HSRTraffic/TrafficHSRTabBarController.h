//
//  TrafficHSRTabBarController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/17.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrafficHSRTabBarController : UITabBarController

@property(strong,nonatomic)NSArray* dataArray;
@property(strong,nonatomic)NSString* departure;
@property(strong,nonatomic)NSString* departureCode;
@property(strong,nonatomic)NSString* destination;
@property(strong,nonatomic)NSString* destinationCode;
@property(strong,nonatomic)NSString* selectedDate;
@property(nonatomic)NSInteger carClass;

-(void)exchangeDepartureAndDestination;

@end
