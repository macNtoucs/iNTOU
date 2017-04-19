//
//  LifeStreetViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/24.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeStreetViewController : UIViewController

@property (strong,nonatomic) NSString* streetName;
@property (strong,nonatomic) NSArray* streetData;
@property (strong,nonatomic) NSDictionary* streetInfo;
@property (weak, nonatomic) IBOutlet UIScrollView *streetScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *streetImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleTap;

@end
