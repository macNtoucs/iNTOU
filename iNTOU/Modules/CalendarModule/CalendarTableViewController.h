//
//  CalendarTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/4/10.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarTableViewController : UITableViewController {
    NSDictionary* calenderData;
}

@property (nonatomic)int year;
@property (strong,nonatomic)NSArray* sectionData;

@end
