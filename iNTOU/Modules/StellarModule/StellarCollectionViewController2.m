//
//  StellarCollectionViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/27.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "StellarCollectionViewController.h"
#import "StellarCollectionViewLayout.h"
#import "Moodle.h"

@interface StellarCollectionViewController ()

@end

@implementation StellarCollectionViewController

static NSArray * weekday;
static NSArray * weekTag;
static NSArray * classTime;

-(instancetype)initWithCoder:(NSCoder *)c {
    self = [super initWithCoder:c];
    if(self) {
        if(!weekday)
            weekday = @[@"",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
        if(!weekTag)
            weekTag = @[@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun"];
        if(!classTime)
            classTime = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    stellarData = [defaults objectForKey:@"StellarModule"];
    ((StellarCollectionViewLayout*)self.collectionViewLayout).stellarData = stellarData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //section = 星期行
    return 8;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return 16;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath section] > 0 && [indexPath row] > 0) {
        NSArray* list = stellarData[@"list"];
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF['day'] == %@",weekTag[indexPath.section - 1]];
        NSArray* dayTemp = [list filteredArrayUsingPredicate:filter];
        if([dayTemp count] > 0) {
            NSArray* course = dayTemp[0][@"course"];
            filter = [NSPredicate predicateWithFormat:@"SELF['time'] == %d",(int)[indexPath row]];
            NSArray* class = [course filteredArrayUsingPredicate:filter];
            if([class count] > 0) {
                [self performSegueWithIdentifier:@"Action" sender:class[0]];
            }
        }

    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StellarCells" forIndexPath:indexPath];
    
        cell.backgroundColor = [UIColor colorWithRed:0 green:137.0/255 blue:123.0/255 alpha:1.0f];
    
    if([indexPath row] == 5)
        cell.backgroundColor = [UIColor colorWithRed:158.0/255 green:0 blue:58.0/255 alpha:1.0f];
    
    if([indexPath row] == 0) {
        //星期行
        ((UILabel*)[cell viewWithTag:101]).text = weekday[indexPath.section];
    }
    else if([indexPath section] == 0 && [indexPath row] >0){
        //課堂列
        ((UILabel*)[cell viewWithTag:101]).text = classTime[indexPath.row - 1];
    }
    else if([indexPath section] > 0 && [indexPath row] > 0) {
        //課程
        NSArray* list = stellarData[@"list"];
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF['day'] == %@",weekTag[indexPath.section - 1]];
        NSArray* dayTemp = [list filteredArrayUsingPredicate:filter];
        if([dayTemp count] > 0) {
            NSArray* course = dayTemp[0][@"course"];
            filter = [NSPredicate predicateWithFormat:@"SELF['time'] == %d",(int)[indexPath row]];
            NSArray* class = [course filteredArrayUsingPredicate:filter];
            if([class count] > 0) {
                ((UILabel*)[cell viewWithTag:101]).text = class[0][@"name"];
                
                return cell;
            }
        }
        ((UILabel*)[cell viewWithTag:101]).text = nil;
    }
    
    return cell;
}
- (IBAction)refreshButton:(UIBarButtonItem *)sender {
    [self downloadDataFromServer];
}

-(void)downloadDataFromServer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Moodle* moodle = [Moodle sharedInstance];
        if([moodle checkLogin]) {
            stellarData = [moodle getCourse];
            ((StellarCollectionViewLayout*)self.collectionViewLayout).stellarData = stellarData;
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:stellarData forKey:@"StellarModule"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
        }
    });
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id page = [segue destinationViewController];
    [page setValue:(NSDictionary*)sender forKey:@"classData"];
}


@end
