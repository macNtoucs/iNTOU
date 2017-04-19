//
//  TrafficTrainTimeTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/20.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrafficTrainTabBarController.h"
#import "MBProgressHUD.h"

@interface TrafficTrainTimeTableViewController : UITableViewController {
    TrafficTrainTabBarController* trafficTrainTabBarController;
    NSDictionary* trainData;
}

-(void)downloadDataFromServer;

@end
