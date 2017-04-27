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
        [account setEnabled:NO];
        [password setEnabled:NO];
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
                    break;
                case 1:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"MoodlePasswordCells"];
                    password = [cell viewWithTag:102];
                    password.text = moodle.password;
                    break;
                default:
                    return nil;
                    break;
            }
            break;
            
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MoodleInfoCells"];
            ((UITextView*)[cell viewWithTag:103]).text = @"帳號：請輸入學號，教職員證號或本館借書證號\n密碼：您的身分證字號（預設值）\n\n    若無法使用，請將您的《姓名》、《讀者證號》、《身份證號》 E-mail至hwa重新設定！\n    若您的證件曾經補發過一次，請在讀者證號後加二位數字01；補發二次，請加02；其餘類推。";
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
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [moodle loginAccount:account.text AndPassword:password.text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [button setEnabled:YES];
            
            if([moodle checkLogin]) {
                [button setTitle:@"登出" forState:UIControlStateNormal];
                [button removeTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
                [button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchDown];
            }
            else {
                [account setEnabled:YES];
                [password setEnabled:YES];
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
