//
//  TrafficExpressDetailTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/17.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrafficExpressDetailTableViewController : UITableViewController {
    NSDictionary* expressData;
    NSTimer* updater;
}

@property(strong,nonatomic)NSString *expressName;

@end
