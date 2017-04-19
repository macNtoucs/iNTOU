//
//  MainCollectionViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "ModuleManager.h"

@interface MainCollectionViewController ()

@end

#define view_width self.collectionView.bounds.size.width
#define view_height self.collectionView.bounds.size.height

@implementation MainCollectionViewController

static NSString * const reuseIdentifier = @"mainCells";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    moduleManager = [ModuleManager new];
    
    fontSize = [self getFontSize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(float)getFontSize {
    //找出字體最符合的大小
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view_width*0.15, 17)]; //高度固定17 但是寬度不固定
    label.text = @"四個字喔"; //這裡設定字串長度
    float fontSizeTemp = 17;
    while ([label.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSizeTemp]}].width > view_width*0.15)
    {
        fontSizeTemp--;
    }
    return fontSizeTemp;
}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [moduleManager.modulesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    ((UILabel*)[cell viewWithTag:101]).text = [moduleManager displayNameAtIndexPath:indexPath];
    [((UILabel*)[cell viewWithTag:101]) setFont:[((UILabel*)[cell viewWithTag:101]).font fontWithSize:fontSize]];
    ((UIImageView*)[cell viewWithTag:102]).image = [UIImage imageNamed:[moduleManager moduleNameAtIndexPath:indexPath]];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self showViewController:[[moduleManager moduleAtIndexPath:indexPath]getViewController] sender:nil];
    
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(view_width*0.05, view_width*0.05, 0, view_width*0.05);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return view_width*0.1;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return view_width*0.1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(view_width*0.15,view_width*0.15 + 17);
}

@end
