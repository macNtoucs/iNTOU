//
//  NTOUR66PictureViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "NTOUR66PictureViewController.h"

@interface NTOUR66PictureViewController ()

@end

@implementation NTOUR66PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Scroll View

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollViewInside
{
    return _R66Picture;
}

@end
