//
//  TrafficClassViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/14.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrafficClassViewController : UIViewController <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *trafficCollectionView;

@end
