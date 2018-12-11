//
//  StellarClassBar.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/4/12.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "StellarClassBar.h"

@implementation StellarClassBar
@synthesize baseViewWidth,baseViewHeight;

static NSArray* classStartTime;
static NSArray* classEndTime;

-(instancetype)init {
    self = [super init];
    if(self)
    {
        if(!classStartTime)
            classStartTime = @[@"8:20",@"9:20",@"10:20",@"11:15",@"12:10",@"13:10",@"14:10",@"15:10",@"16:05",@"17:30",@"18:30",@"19:25",@"20:20",@"21:15"];
        if(!classEndTime)
            classEndTime = @[@"9:10",@"10:10",@"11:10",@"12:05",@"13:00",@"14:00",@"15:00",@"16:00",@"16:55",@"18:20",@"19:20",@"20:15",@"21:10",@"22:05"];
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
    return 14;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClassCells" forIndexPath:indexPath];
    
    //((UILabel*)[cell viewWithTag:101]).text = [[NSString alloc] initWithFormat:@"%ld",(long)indexPath.row+1];
    ((UILabel*)[cell viewWithTag:102]).text = classStartTime[indexPath.row];
    ((UILabel*)[cell viewWithTag:103]).text = classEndTime[indexPath.row];
    return cell;
}

@end
