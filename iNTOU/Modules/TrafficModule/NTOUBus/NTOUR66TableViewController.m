//
//  NTOUR66TableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "NTOUR66TableViewController.h"

@interface NTOUR66TableViewController ()

@end

@implementation NTOUR66TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    busData = @[@{@"marine":@[@"海科館", @"06:30", @"06:50", @"07:10", @"07:30", @"08:00", @"08:20", @"08:40", @"09:10", @"10:00", @"11:20", @"12:40", @"14:00", @"15:20", @"15:40", @"★15:55", @"16:20", @"★16:35", @"17:00", @"★17:25", @"18:10", @"19:00", @"19:40", @"20:30"],@"qidu":@[@"七堵車站", @"★07:05", @"07:25", @"★07:45", @"08:05", @"★08:35", @"08:55", @"09:15", @"09:45", @"10:35", @"11:55", @"13:15", @"14:35", @"15:55", @"16:15", @"16:45", @"17:15", @"17:35", @"17:55", @"18:15", @"18:45", @"19:35", @"20:15", @"21:00", @"17:50"]}
                ,@{@"marine":@[@"海科館", @"07:00", @"08:20", @"09:40", @"11:00", @"12:20", @"13:40", @"15:00", @"16:20", @"17:40", @"19:00"],@"qidu":@[@"七堵車站", @"07:35", @"08:55", @"10:15", @"11:35", @"12:55", @"14:15", @"15:35", @"16:55", @"18:15", @"19:35"]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segAction:(id)sender {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [busData[_weekDaySegment.selectedSegmentIndex][@"marine"] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if(indexPath.row == [busData[_weekDaySegment.selectedSegmentIndex][@"marine"] count]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NTOUR66Cells2" forIndexPath:indexPath];
        ((UILabel*)[cell viewWithTag:101]).text = @"『★』代表本班車繞行海洋大學校區";
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NTOUR66Cells" forIndexPath:indexPath];
        
        ((UILabel*)[cell viewWithTag:101]).text = busData[_weekDaySegment.selectedSegmentIndex][@"marine"][indexPath.row];
        ((UILabel*)[cell viewWithTag:102]).text = busData[_weekDaySegment.selectedSegmentIndex][@"qidu"][indexPath.row];
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
