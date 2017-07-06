//
//  NTOUBusTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "NTOUBusTableViewController.h"

@interface NTOUBusTableViewController ()

@end

@implementation NTOUBusTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    busData = @[@[@"1800海洋大學 -> 中崙",@"1800中崙 -> 海洋大學"]
                ,@[@"八斗子 -> 海大 -> 火車站",@"火車站 -> 海大 -> 八斗子",@"R66 (海科館/七堵車站)"]];
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

    return [busData[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NTOUBusCells" forIndexPath:indexPath];
    
    cell.textLabel.text = busData[indexPath.section][indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    switch(section)
    {
        case 0:
            return @"學生專車";
            break;
        case 1:
            return @"市區公車";
            break;
        default:
        return  nil;
        
    }
}

#pragma mark - Table view

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if(indexPath.row == 0 || indexPath.row == 1)
                [self performSegueWithIdentifier:@"NTOU1800" sender:indexPath];
            break;
            
        case 1:
            if(indexPath.row == 0 || indexPath.row == 1)
                [self performSegueWithIdentifier:@"Badouzi" sender:indexPath];
            if(indexPath.row == 2)
                [self performSegueWithIdentifier:@"R66" sender:indexPath];
            break;
            
        default:
            break;
    }
}



#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id page = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"捷運劍潭站"])
    {
        if([sender row] == 0)
           [page setValue:@0 forKey:@"goBack"];
        else
            [page setValue:@1 forKey:@"goBack"];
    }
    if([segue.identifier isEqualToString:@"NTOU1800"])
    {
        if([sender row] == 0)
            [page setValue:@0 forKey:@"goBack"];
        else
            [page setValue:@1 forKey:@"goBack"];
    }
    if([segue.identifier isEqualToString:@"Badouzi"])
    {
        if([sender row] == 0)
            [page setValue:@1 forKey:@"goBack"];
        else
            [page setValue:@0 forKey:@"goBack"];
    }
}


@end
