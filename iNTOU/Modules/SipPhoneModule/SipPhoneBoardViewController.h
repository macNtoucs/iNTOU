//
//  SipPhoneBoardViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/5/1.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pjsua.h"

@interface SipPhoneBoardViewController : UIViewController {
    pjsua_acc_id m_acc_id;
    pjsua_call_id m_current_call;
    NSMutableString* sendDtmfString;
}

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *hangUpButton;

@end
