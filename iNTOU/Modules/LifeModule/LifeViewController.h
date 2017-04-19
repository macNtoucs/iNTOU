//
//  LifeViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/24.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeViewController : UIPageViewController <UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
    NSArray* pages;
    NSDictionary* lifeData;
}

@end
