//
//  NewsContentViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsContentViewController : UIViewController <UIScrollViewDelegate,UIWebViewDelegate>


@property (weak, nonatomic) NSDictionary* data;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
