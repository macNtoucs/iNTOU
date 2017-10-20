//
//  TeacherAndStudentGradeListTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/10/16.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moodle.h"

@interface TeacherAndStudentGradeListTableViewController : UITableViewController
{
    Moodle* moodle;
    NSDictionary* gradeData;
}

@property (strong,nonatomic)NSString* semester;
@property (strong,nonatomic)NSString* stidTarget;

@end
