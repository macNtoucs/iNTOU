//
//  TeacherAndStudentListTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/10/16.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moodle.h"

@interface TeacherAndStudentListTableViewController : UITableViewController
{
    Moodle* moodle;
    NSDictionary* listData;
    NSDictionary* typeData;
}

@property (strong,nonatomic)NSString* stidTarget;
@property (strong,nonatomic)NSString* customTitle;
@end
