//
//  LibraryBorrowTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/7.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Library.h"

@interface LibraryBorrowTableViewController : UITableViewController {
    UIRefreshControl* refresh;
    Library* library;
    NSArray* libraryBorrowData;
}

@end
