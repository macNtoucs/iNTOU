//
//  LibraryBarCodeViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/27.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LibraryBarCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession* captureSession;
    AVCaptureDevice* audioCaptureDevice;
    bool canCapture;
}

@end
