//
//  TrafficHSRDateViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/17.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrafficHSRTabBarController.h"

@interface TrafficHSRDateViewController : UIViewController {
    TrafficHSRTabBarController* trafficHSRTabBarController;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeight;

@end
