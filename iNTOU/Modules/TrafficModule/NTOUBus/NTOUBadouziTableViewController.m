//
//  NTOUBadouziTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "NTOUBadouziTableViewController.h"

@interface NTOUBadouziTableViewController ()

@end

@implementation NTOUBadouziTableViewController
@synthesize goBack;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    busData = @[@[@"海大體育館",@"海大濱海校門(一)",@"海大祥豐校門(二)",@"海大中正路口",@"二信中學"],@[@"海大體育館",@"海大濱海校門(二)",@"海大祥豐校門(一)",@"海大中正路口",@"二信中學"]];
    
    if(goBack)
        self.title = @"往火車站";
    else
        self.title = @"往八斗子";
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

    return [busData[goBack] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BadouziCells" forIndexPath:indexPath];
    
    cell.textLabel.text = busData[goBack][indexPath.row];
    
    return cell;
}


#pragma mark - Table view

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"八斗子站牌" sender:indexPath];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id page = [segue destinationViewController];
    [page setValue:busData[goBack][[sender row]] forKey:@"name"];
    [page setValue:@"K" forKey:@"city"];
    if(goBack)
        [page setValue:@1 forKey:@"goBack"];
    else
        [page setValue:@0 forKey:@"goBack"];
    
}


@end
