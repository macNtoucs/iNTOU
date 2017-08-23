//
//  LibraryTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/26.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "LibraryTableViewController.h"
#import "MBProgressHUD.h"

@interface LibraryTableViewController ()

@end

@implementation LibraryTableViewController
@synthesize account,password,button,tapRecognizer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    library = [Library sharedInstance];
    
    if(library.account) {
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
                    cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryAccountCells"];
                    account = [cell viewWithTag:101];
                    account.text = library.account;
                    if(library.account)
                        [account setEnabled:NO];
                    break;
                case 1:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryPasswordCells"];
                    password = [cell viewWithTag:102];
                    password.text = library.password;
                    if(library.account)
                        [password setEnabled:NO];
                    break;
                default:
                    return nil;
                    break;
            }
            break;
            
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryInfoCells"];
            ((UITextView*)[cell viewWithTag:103]).text = @"帳號：請輸入學號，教職員證號或本館借書證號\n密碼：您的身分證字號（預設值）\n\n若您的證件曾經補發過一次，請在讀者證號後加二位數字01；補發二次，請加02；其餘類推。";
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
        [library loginAccount:account.text AndPassword:password.text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [button setEnabled:YES];
            
            
            if([library checkLogin]) {
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
    [library logout];
    
    account.text = nil;
    [account setEnabled:YES];
    password.text = nil;
    [password setEnabled:YES];
    [button setTitle:@"登入" forState:UIControlStateNormal];
    [button removeTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
}

@end
