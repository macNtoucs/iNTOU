//
//  TrafficBusStopTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/9.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrafficBusStopTableViewController : UITableViewController {
    NSDictionary* stopData;
    NSTimer* updater;
}

@property(strong,nonatomic)NSString *name;
@property(strong,nonatomic)NSString *city;
@property(nonatomic)bool goBack;
@end
