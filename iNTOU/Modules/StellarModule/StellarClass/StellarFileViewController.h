//
//  StellarFileViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/29.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StellarFileViewController : UIViewController {
    UIRefreshControl* refresh;
    NSString* moodleid;
    NSArray* cellData;
    NSArray* buttons;
}

@property (weak,nonatomic)NSDictionary* classData;
@property (weak, nonatomic) IBOutlet UITableView *fileTableView;
@property (nonatomic)unsigned int selected;
@property (weak, nonatomic) IBOutlet UIView *buttonBoard;

@end
