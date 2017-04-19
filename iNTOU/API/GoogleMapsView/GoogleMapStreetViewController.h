//
//  GoogleMapStreetViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/16.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;

@interface GoogleMapStreetViewController : UIViewController {
    GMSPanoramaView *panoView;
}

-(void)setLongitude:(double)longitude andLatitude:(double)latitude;

@end
