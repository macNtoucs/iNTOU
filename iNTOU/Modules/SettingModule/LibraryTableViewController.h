//
//  LibraryTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/26.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Library.h"

@interface LibraryTableViewController : UITableViewController {
    Library* library;
}

@property (weak, nonatomic) UITextField *account;
@property (weak, nonatomic) UITextField *password;

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

@end
