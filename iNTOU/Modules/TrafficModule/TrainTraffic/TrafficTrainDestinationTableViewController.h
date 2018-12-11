//
//  TrafficTrainDestinationTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/17.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrafficTrainTabBarController.h"

@interface TrafficTrainDestinationTableViewController : UITableViewController {
    TrafficTrainTabBarController* trafficTrainTabBarController;
    NSArray* dataArray;
    NSArray* locationArray; //給側邊選單用
}

@end
