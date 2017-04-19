//
//  StellarWeekBar.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/4/12.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "StellarWeekBar.h"

@implementation StellarWeekBar
@synthesize baseViewHeight,baseViewWidth;

static NSArray* week;

-(instancetype)init {
    self = [super init];
    if(self)
    {
        if(!week)
            week = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    }
    return self;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(baseViewWidth, baseViewHeight);
}

#pragma mark - data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeekCells" forIndexPath:indexPath];
    
    ((UILabel*)[cell viewWithTag:101]).text = week[indexPath.row];
    
    return cell;
}

@end
