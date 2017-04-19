//
//  TrafficExpressTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/15.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrafficExpressTableViewController : UITableViewController
{
    NSArray* searchResult;
    NSMutableArray* usuallyUse;
}

@property (weak, nonatomic) IBOutlet UISearchBar *expressSearchBar;

@end
