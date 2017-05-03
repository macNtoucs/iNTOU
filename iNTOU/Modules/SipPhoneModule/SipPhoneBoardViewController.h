//
//  SipPhoneBoardViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/5/1.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VialerPJSIP/pjsua.h"

@interface SipPhoneBoardViewController : UIViewController {
    pjsua_acc_id m_acc_id;
    pjsua_call_id m_current_call;
}

@end
