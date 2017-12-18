//
//  SipPhoneViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/11/26.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "SipPhoneViewController.h"

@interface SipPhoneViewController ()

@end

@implementation SipPhoneViewController
@synthesize callButton,hangUpButton,speakerButton,statueLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    jcsip = [JCsip new];
    jcsip.delegate = self;
    
    diagPadArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"*",@"0",@"#"];
    
    session = [AVAudioSession sharedInstance];
}

-(void)viewWillAppear:(BOOL)animated {
    switch ([session recordPermission]) {
        case AVAudioSessionRecordPermissionGranted:
            [callButton setEnabled:true];
            [hangUpButton setEnabled:false];
            break;
        case AVAudioSessionRecordPermissionDenied:
            [statueLabel setText:@"沒有麥克風權限"];
            [callButton setEnabled:false];
            [hangUpButton setEnabled:false];
            break;
        case AVAudioSessionRecordPermissionUndetermined:
            [session requestRecordPermission:^(BOOL granted) {
                if(!granted)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [statueLabel setText:@"沒有麥克風權限"];
                        [callButton setEnabled:false];
                        [hangUpButton setEnabled:false];
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [callButton setEnabled:true];
                        [hangUpButton setEnabled:false];
                    });
                }
            }];
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)diagButtonPressed:(UIButton *)sender {
    if(diagString){
        [jcsip sendDtmf:diagPadArray[sender.tag - 101]];
        [diagString appendString:diagPadArray[sender.tag - 101]];
        [statueLabel setText:diagString];
    }
}
- (IBAction)callButtonPressed:(id)sender {
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
    [jcsip registerNtou];
}
- (IBAction)hangUpButtonPressed:(id)sender {
    [jcsip hangup];
}
- (IBAction)speakerButtonPressed:(UIButton *)sender {
    if([sender.titleLabel.text isEqualToString:@"擴音"])
    {
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        [sender setTitle:@"取消擴音" forState: UIControlStateNormal];
    }
    if([sender.titleLabel.text isEqualToString:@"取消擴音"])
    {
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
        [sender setTitle:@"擴音" forState: UIControlStateNormal];
    }
}

-(void)changeStatue:(enum JCSipConditionCode)code {
    switch (code) {
        case JCSipConditionWaiting:
            [session setActive:NO error:nil];
            [statueLabel setText:@"按下撥打連線至海大"];
            [callButton setEnabled:true];
            [hangUpButton setEnabled:false];
            diagString = nil;
            break;
        case JCSipConditionCalling:
            [statueLabel setText:@"撥號中..."];
            [callButton setEnabled:false];
            [hangUpButton setEnabled:true];
            break;
        case JCSipConditionSessionWork:
            [statueLabel setText:@"請輸入分機號碼"];
            diagString = [NSMutableString new];
            break;
        case JCSipConditionAllAccountBusy:
            [statueLabel setText:@"伺服器忙線中，稍後再試！"];
            [callButton setEnabled:true];
            [hangUpButton setEnabled:false];
            break;
        case JCsipConditionTimeOutTooMany:
            [statueLabel setText:@"網路不穩"];
            [callButton setEnabled:true];
            [hangUpButton setEnabled:false];
        default:
            break;
    }
}

@end
