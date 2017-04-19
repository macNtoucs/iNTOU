//
//  NTOU1800TableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "NTOU1800TableViewController.h"

@interface NTOU1800TableViewController ()

@end

@implementation NTOU1800TableViewController
@synthesize goBack;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    busData = @[@[@"16:50",@"17:20",@"17:50",@"18:20",@"21:30"],@[@"07:10",@"07:30",@"08:10",@"08:30"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [busData[goBack] count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NTOU1800Cells" forIndexPath:indexPath];
    
    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"班次";
        cell.textLabel.textColor = [UIColor blueColor];
        cell.detailTextLabel.text = @"發車時間";
        cell.detailTextLabel.textColor = [UIColor blueColor];
    }
    else
    {
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%ld",(long)indexPath.row];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.text = busData[goBack][indexPath.row - 1];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }

    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(!goBack)
        return @"1800海洋大學 -> 中崙";
    else
        return @"1800中崙 -> 海洋大學";
    
}




@end
