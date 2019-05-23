//
//  MoodleTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/26.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "MoodleTableViewController.h"
#import "MBProgressHUD.h"

@interface MoodleTableViewController ()

@end

@implementation MoodleTableViewController
@synthesize tapRecognizer,account,password,button;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    moodle = [Moodle sharedInstance];
    
    if(moodle.account) {
        [button setTitle:@"登出" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchDown];
    }
    else
        [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
    
    [tapRecognizer addTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"MoodleAccountCells"];
                    account = [cell viewWithTag:101];
                    account.text = moodle.account;
                    if(moodle.account)
                        [account setEnabled:NO];
                    break;
                case 1:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"MoodlePasswordCells"];
                    password = [cell viewWithTag:102];
                    password.text = moodle.password;
                    if(moodle.account)
                        [password setEnabled:NO];
                    break;
                default:
                    return nil;
                    break;
            }
            break;
            
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MoodleInfoCells"];
            ((UITextView*)[cell viewWithTag:103]).text = @"帳號：海大mail帳號 (預設為學號或教職員證號)\n密碼：海大mail密碼 (預設為身分證字號)\n若忘記密碼，請與圖資處圖書系統組聯繫。";
            break;
            
        default:
            return nil;
            break;
    }
    
    return cell;
}

-(void)dismissKeyboard {
    [account resignFirstResponder];
    [password resignFirstResponder];
}

-(void)login {
    [button setEnabled:NO];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = true;
    hud.label.text = @"登入中...";
    
    [account setEnabled:NO];
    [password setEnabled:NO];
    
    NSString* accountTemp = account.text;
    NSString* passwordTemp = password.text;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self->moodle loginAccount:accountTemp AndPassword:passwordTemp];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self->button setEnabled:YES];
            
            if([self->moodle checkLogin]) {
                [self->button setTitle:@"登出" forState:UIControlStateNormal];
                [self->button removeTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
                [self->button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchDown];
            }
            else {
                [self->account setEnabled:YES];
                [self->password setEnabled:YES];
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"登入失敗！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
                
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
        });
    });
}

-(void)logout {
    [moodle logout];
    
    account.text = nil;
    [account setEnabled:YES];
    password.text = nil;
    [password setEnabled:YES];
    [button setTitle:@"登入" forState:UIControlStateNormal];
    [button removeTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
}



@end
