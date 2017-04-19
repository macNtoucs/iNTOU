//
//  GoogleMapViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/16.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "GoogleMapViewController.h"


@interface GoogleMapViewController ()

@end

@implementation GoogleMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = mapView;
    
    switchButton = [[UIBarButtonItem alloc] initWithTitle:@"衛星地圖" style:UIBarButtonItemStylePlain target:self action:@selector(switchMapType)];
    self.navigationItem.rightBarButtonItem = switchButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLongitude:(double)longitude andLatitude:(double)latitude andZoom:(double)zoom {
    camera = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:zoom];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
}

-(void)setMark:(NSString*)markTitle {
    GMSMarker *marker = [GMSMarker new];
    marker.position = camera.target;
    marker.snippet = markTitle;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = mapView;
}

-(void)switchMapType{
    if ([switchButton.title isEqualToString: @"衛星地圖" ])
    {
        mapView.mapType=kGMSTypeSatellite;
        switchButton.title =@"混合地圖";
    }
    else if ([switchButton.title isEqualToString: @"標準地圖"])
    {
        mapView.mapType = kGMSTypeNormal;
        switchButton.title =@"衛星地圖";
        
    }
    else if ([switchButton.title isEqualToString: @"混合地圖"])
    {
        mapView.mapType = kGMSTypeHybrid;
        switchButton.title =@"標準地圖";
        
    }
    [self reloadInputViews];
}

@end
