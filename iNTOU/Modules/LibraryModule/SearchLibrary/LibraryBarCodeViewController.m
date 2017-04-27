//
//  LibraryBarCodeViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/27.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "LibraryBarCodeViewController.h"

@interface LibraryBarCodeViewController ()

@end

@implementation LibraryBarCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSession];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [captureSession startRunning];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [captureSession stopRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupSession {
    captureSession = [AVCaptureSession new];
    audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError* error;
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    if (audioInput) {
        [captureSession addInput:audioInput];
        
        AVCaptureMetadataOutput* captureMetadataOutput = [AVCaptureMetadataOutput new];
        [captureSession addOutput:captureMetadataOutput];
        [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        captureMetadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code];
        
        AVCaptureVideoPreviewLayer* previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
        [previewLayer setFrame:self.view.layer.bounds];
        [self.view.layer addSublayer:previewLayer];
    }
    else {
        NSLog(@"%@",error);
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"相機權限未開啟！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [self.navigationController popViewControllerAnimated:YES];
                                                             }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{

    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        [self performSegueWithIdentifier:@"SearchAction" sender:[metadataObj stringValue]];
        [captureSession stopRunning];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id view = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"SearchAction"])
    {
        [view setValue:@"i" forKey:@"type"];
        [view setValue:sender forKey:@"searchKey"];
    }
}


@end
