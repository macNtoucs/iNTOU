//
//  AboutDeveloperTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/4/7.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "AboutDeveloperTableViewController.h"

@interface AboutDeveloperTableViewController ()

@end

@implementation AboutDeveloperTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.version.text = [[NSString alloc] initWithFormat:@"海大App %@",[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
