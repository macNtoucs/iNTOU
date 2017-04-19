//
//  LibrarySearchResultTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/9.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibrarySearchResultTableViewController : UITableViewController {
    UIRefreshControl* refresh;
    Boolean threadLock;
    NSDictionary* searchResultdata;
    NSArray* bookResult;
    int maxSegment;
}

@property (strong,nonatomic)NSString* searchKey;
@property (strong,nonatomic)NSString* type;
@end
