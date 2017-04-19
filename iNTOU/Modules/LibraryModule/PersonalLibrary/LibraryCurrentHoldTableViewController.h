//
//  LibraryCurrentHoldTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/6.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Library.h"

@interface LibraryCurrentHoldTableViewController : UITableViewController {
    UIRefreshControl* refresh;
    Library* library;
    NSArray* libraryCurrentHoldData;
    
}

@end
