//
//  NTOUR66TableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTOUR66TableViewController : UITableViewController {
    NSArray* busData;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *weekDaySegment;

@end
