//
//  GoogleMapStreetViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/16.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "GoogleMapStreetViewController.h"

@interface GoogleMapStreetViewController ()

@end

@implementation GoogleMapStreetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = panoView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLongitude:(double)longitude andLatitude:(double)latitude {
    panoView = [[GMSPanoramaView alloc] initWithFrame:CGRectZero];
    [panoView moveNearCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
}

@end
