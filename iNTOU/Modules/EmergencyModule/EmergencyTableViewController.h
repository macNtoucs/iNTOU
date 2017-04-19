//
//  EmergencyTableViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/25.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface EmergencyTableViewController : UITableViewController <MFMailComposeViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSDictionary* emergencyData;
    NSArray* inner;
    NSArray* outer;
}

@end
