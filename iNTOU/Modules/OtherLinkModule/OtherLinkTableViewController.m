//
//  OtherLinkTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/4/7.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "OtherLinkTableViewController.h"
#import <SafariServices/SafariServices.h>

@interface OtherLinkTableViewController ()

@end

@implementation OtherLinkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            SFSafariViewController* safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:@"http://www.season2016.com/"]];
            [self presentViewController:safari animated:YES completion:nil];
            break;
        }
        case 1:
        {
            SFSafariViewController* safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:@"http://www.stu.ntou.edu.tw/sq/Page_Show.asp?Page_ID=13007"]];
            [self presentViewController:safari animated:YES completion:nil];
            break;
        }
        case 2:
        {
            SFSafariViewController* safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:@"http://www.stu.ntou.edu.tw/sm/Page_Show.asp?Page_ID=9551"]];
            [self presentViewController:safari animated:YES completion:nil];
            break;
        }
        case 3:
        {
            SFSafariViewController* safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:@"http://www.stu.ntou.edu.tw/sm/Page_Show.asp?Page_ID=23437"]];
            [self presentViewController:safari animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

@end
