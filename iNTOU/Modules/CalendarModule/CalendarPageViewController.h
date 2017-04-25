//
//  CalendarPageViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/4/25.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarPageViewController : UIPageViewController <UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
    NSDictionary* calenderData;
    NSArray* years;
    NSArray* pages;
    int now_year;
    int max_year;
}

@end
