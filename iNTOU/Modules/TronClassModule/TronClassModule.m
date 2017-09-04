//
//  TronClassModule.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/9/4.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TronClassModule.h"

@implementation TronClassModule

-(UIViewController*)getViewController {
    
    NSString *customURL = @"tencent1104342231://";
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:customURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }
    else
    {
        //開啟app store
        NSString *iTunesLink = @"itms-apps://itunes.apple.com/us/app/apple-store/id973028199?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
    
    return nil;
}

@end
