//
//  GuideTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "GuideTableViewController.h"

@interface GuideTableViewController ()

@end

@implementation GuideTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    guideData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GuideModule" ofType:@"plist"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [guideData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [guideData[section][[guideData[section] allKeys][0]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuideCells" forIndexPath:indexPath];
    
    cell.textLabel.text = [guideData[indexPath.section][[guideData[indexPath.section] allKeys][0]][indexPath.row] allKeys][0];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [guideData[section] allKeys][0];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"Action" sender:indexPath];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id page = [segue destinationViewController];
    
    NSString* titleName = [guideData[[sender section]][[guideData[[sender section]] allKeys][0]][[sender row]] allKeys][0];
    
    [page setValue:titleName forKey:@"guideLocationsTitle"];
    [page setValue:guideData[[sender section]][[guideData[[sender section]] allKeys][0]][[sender row]][titleName] forKey:@"guideLocationsData"];
}


@end
