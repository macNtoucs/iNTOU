//
//  TrafficClassViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/14.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TrafficClassViewController.h"

@interface TrafficClassViewController ()

@end

@implementation TrafficClassViewController
@synthesize trafficCollectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [trafficCollectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        NSString* reuseIdentifier  = [[NSString alloc]initWithFormat:@"TrafficClassCells%d",(int)indexPath.row + 1];
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
        
        return cell;
}

#pragma mark - collection view

#define view_width self.trafficCollectionView.bounds.size.width
#define view_height self.trafficCollectionView.bounds.size.height

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
        if(view_width > view_height){
            return CGSizeMake(view_height/2, view_height/2);
        }
        else{
            return CGSizeMake(view_width/2,view_width/2);
        }
    }
    else {
        return CGSizeMake(view_width/4,view_width/4);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
