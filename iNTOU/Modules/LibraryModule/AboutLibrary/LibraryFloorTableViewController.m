//
//  LibraryFloorTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/5.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "LibraryFloorTableViewController.h"

@interface LibraryFloorTableViewController ()

@end

@implementation LibraryFloorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    libraryFloorData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LibraryModuleFloor" ofType:@"plist"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [libraryFloorData[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"圖書一館";
            break;
        case 1:
            return @"圖書二館";
            break;
            
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryModuleFloorCells" forIndexPath:indexPath];
    
    [((UITextView*)[cell viewWithTag:102]) setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    ((UILabel*)[cell viewWithTag:101]).text = libraryFloorData[indexPath.section][indexPath.row][@"floor"];
    ((UITextView*)[cell viewWithTag:102]).text = libraryFloorData[indexPath.section][indexPath.row][@"info"];
    return cell;
}


@end
