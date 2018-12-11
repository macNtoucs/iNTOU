//
//  TrafficTrainDateViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/17.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrafficTrainTabBarController.h"

@interface TrafficTrainDateViewController : UIViewController {
    TrafficTrainTabBarController* trafficTrainTabBarController;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeight;

@end
