//
//  TeacherClassListTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/10/16.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moodle.h"

@interface TeacherClassListTableViewController : UITableViewController
{
    Moodle* moodle;
    NSDictionary* classListData;
}

@property (strong,nonatomic)NSString* semester;

@end
