//
//  StellarWeekBar.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/4/12.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StellarWeekBar : UICollectionViewFlowLayout <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic) CGFloat baseViewHeight;
@property (nonatomic) CGFloat baseViewWidth;

@end
