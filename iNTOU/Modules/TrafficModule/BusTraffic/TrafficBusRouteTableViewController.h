//
//  TrafficBusRouteTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/14.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrafficBusRouteTableViewController : UITableViewController {
    NSDictionary* routeData;
    NSTimer* updater;
    bool goBack;
}


@property(strong,nonatomic)NSString *name;
@property(strong,nonatomic)NSString *routeId;
@property(strong,nonatomic)NSString *city;
@property(strong,nonatomic)NSString *departureZh;
@property(strong,nonatomic)NSString *destinationZh;
@property (weak, nonatomic) IBOutlet UILabel *titleMain;
@property (weak, nonatomic) IBOutlet UILabel *titleSub;

@end
