//
//  StellarViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/4/12.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StellarWeekBar.h"
#import "StellarViewLayout.h"
#import "StellarClassBar.h"


@interface StellarViewController : UIViewController <StellarViewLayoutDelegate> {
    NSDictionary* stellarData;
}


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewWidth;
@property (weak, nonatomic) IBOutlet UICollectionView *weekScrollView;
@property (strong, nonatomic) StellarWeekBar *stellarWeekBar;
@property (weak, nonatomic) IBOutlet UICollectionView *classScrollView;
@property (strong, nonatomic) StellarClassBar *stellarClassBar;
@property (weak, nonatomic) IBOutlet UICollectionView *mainScrollView;

@end
