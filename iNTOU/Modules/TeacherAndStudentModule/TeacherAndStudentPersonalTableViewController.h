//
//  TeacherAndStudentPersonalTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/10/16.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moodle.h"

@interface TeacherAndStudentPersonalTableViewController : UITableViewController {
    Moodle* moodle;
    NSDictionary* personalData;
}

@property (strong,nonatomic)NSString* stidTarget;

@end
