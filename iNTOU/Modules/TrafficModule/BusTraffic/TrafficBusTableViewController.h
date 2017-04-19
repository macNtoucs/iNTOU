//
//  TrafficBusTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/17.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrafficBusTableViewController : UITableViewController <UISearchBarDelegate>
{
    NSMutableDictionary* searchResult;
    NSMutableArray* usuallyUse;
}

@property (weak, nonatomic) IBOutlet UISearchBar *busSearchBar;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

@end
