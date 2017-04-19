//
//  AboutTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/4/7.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "AboutTableViewController.h"
#import <SafariServices/SafariServices.h>

@interface AboutTableViewController ()

@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.version.text = [[NSString alloc] initWithFormat:@"海大App %@",[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1 && indexPath.row == 1) {
        SFSafariViewController* safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:@"https://docs.google.com/forms/d/e/1FAIpQLSfdZTh3HrNP0m5hIbjqYpM-aDZ47joil08geTJrU9kAe1CWbg/viewform"]];
        [self presentViewController:safari animated:YES completion:nil];
    }
}

@end
