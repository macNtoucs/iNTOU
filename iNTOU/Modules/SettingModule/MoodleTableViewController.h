//
//  MoodleTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/26.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moodle.h"
@interface MoodleTableViewController : UITableViewController {
    Moodle* moodle;
}
@property (weak, nonatomic) UITextField *account;
@property (weak, nonatomic) UITextField *password;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end
