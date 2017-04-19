//
//  GoogleMapViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/16.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;

@interface GoogleMapViewController : UIViewController {
    GMSCameraPosition *camera;
    GMSMapView *mapView;
    
    UIBarButtonItem *switchButton;
}

-(void)setLongitude:(double)longitude andLatitude:(double)latitude andZoom:(double)zoom;
-(void)setMark:(NSString*)markTitle;

@end
