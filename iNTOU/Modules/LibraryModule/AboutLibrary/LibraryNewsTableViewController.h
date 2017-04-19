//
//  LibraryNewsTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/5.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryNewsTableViewController : UITableViewController <NSXMLParserDelegate>
{
    UIRefreshControl* refresh;
    NSArray* libraryNewsData;
}

@end
