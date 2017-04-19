//
//  StellarClassViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/27.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "StellarClassViewController.h"

@interface StellarClassViewController ()

@end

@implementation StellarClassViewController
@synthesize classData;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = classData[@"name"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
