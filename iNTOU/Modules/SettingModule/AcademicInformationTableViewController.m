//
//  AcademicInformationTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/10/18.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "AcademicInformationTableViewController.h"
#import "MBProgressHUD.h"

@interface AcademicInformationTableViewController ()

@end

@implementation AcademicInformationTableViewController
@synthesize accountCell,passwordCell,loginButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    academicInformation = [AcademicInformation sharedInstance];
    if([academicInformation checkLogin]) {
        ((UITextField*)[accountCell viewWithTag:101]).text = academicInformation.account;
        ((UITextField*)[passwordCell viewWithTag:101]).text = academicInformation.password;
        [((UITextField*)[accountCell viewWithTag:101]) setEnabled:NO];
        [((UITextField*)[passwordCell viewWithTag:101]) setEnabled:NO];
        [loginButton setTitle:@"登出"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(UIBarButtonItem *)sender {
    //登出
    if([academicInformation checkLogin]) {
        ((UITextField*)[accountCell viewWithTag:101]).text = nil;
        ((UITextField*)[passwordCell viewWithTag:101]).text = nil;
        [((UITextField*)[accountCell viewWithTag:101]) setEnabled:YES];
        [((UITextField*)[passwordCell viewWithTag:101]) setEnabled:YES];
        [academicInformation logout];
        [loginButton setTitle:@"登入"];
    }
    //登入
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide = true;
        hud.label.text = @"登入中...";
        
        NSString* account = ((UITextField*)[accountCell viewWithTag:101]).text;
        NSString* password = ((UITextField*)[passwordCell viewWithTag:101]).text;
        [((UITextField*)[accountCell viewWithTag:101]) setEnabled:NO];
        [((UITextField*)[passwordCell viewWithTag:101]) setEnabled:NO];
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [academicInformation loginAccount:account AndPassword:password];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if([academicInformation checkLogin])
                {
                    [loginButton setTitle:@"登出"];
                }
                else
                {
                    [((UITextField*)[accountCell viewWithTag:101]) setEnabled:YES];
                    [((UITextField*)[passwordCell viewWithTag:101]) setEnabled:YES];
                    
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"登入失敗！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
                    
                    [alert addAction:cancel];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            });
        });
    }
    
}



@end
