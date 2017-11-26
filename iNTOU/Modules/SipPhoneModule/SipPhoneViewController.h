//
//  SipPhoneViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/11/26.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCsip.h"

@interface SipPhoneViewController : UIViewController <JCSipDelegate> {
    JCsip* jcsip;
    NSArray* diagPadArray;
    NSMutableString* diagString;
}
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *hangUpButton;
@property (weak, nonatomic) IBOutlet UIButton *speakerButton;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;

@end
