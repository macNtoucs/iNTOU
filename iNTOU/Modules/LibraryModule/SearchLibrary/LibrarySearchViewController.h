//
//  LibrarySearchViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/8.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibrarySearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;
@property (weak, nonatomic) IBOutlet UIScrollView *searchScrollView;

@end
