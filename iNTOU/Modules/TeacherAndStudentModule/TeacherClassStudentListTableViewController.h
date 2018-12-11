//
//  TeacherClassStudentListTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/10/16.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moodle.h"
#import "AcademicInformation.h"

@interface TeacherClassStudentListTableViewController : UITableViewController <UISearchBarDelegate>
{
    Moodle* moodle;
    AcademicInformation* academicInformation;
    NSDictionary* classStudentListData;
    NSArray* showData;
    NSCache* imageCache;
    NSMutableDictionary* threadLock;
    int threadNum;
}

@property (strong,nonatomic)NSString* semester;
@property (strong,nonatomic)NSDictionary* classInfo;
@property (weak, nonatomic) IBOutlet UISearchBar *studentSearchBar;

@end
