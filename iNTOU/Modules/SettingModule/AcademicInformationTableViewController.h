//
//  AcademicInformationTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/10/18.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcademicInformation.h"

@interface AcademicInformationTableViewController : UITableViewController {
    AcademicInformation* academicInformation;
}
@property (weak, nonatomic) IBOutlet UITableViewCell *accountCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *passwordCell;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginButton;

@end
