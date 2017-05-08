//
//  LibraryBorrowTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/7.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "LibraryBorrowTableViewController.h"

@interface LibraryBorrowTableViewController () {
    UINavigationController* loginNavi;
}

@end

@implementation LibraryBorrowTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    library = [Library sharedInstance];
    
    //刷新鈕
    refresh =[UIRefreshControl new];
    [refresh addTarget:self action:@selector(downloadDataFromServer) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refresh;
    
    [self downloadDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadDataFromServer {
    [refresh beginRefreshing];
    
    if([library checkLogin])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            libraryBorrowData = [library getCurrentBorrowedBooks];
            
            if(!libraryBorrowData) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"連線失敗！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [refresh endRefreshing];
            });
        });
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"沒有登入的帳號！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction* goToLogin = [UIAlertAction actionWithTitle:@"前往登入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard* settingModule = [UIStoryboard storyboardWithName:@"SettingModule" bundle:nil];
            UIViewController* loginViewController = [settingModule instantiateViewControllerWithIdentifier:@"SettingModuleLibrary"];
            loginViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                                      style:UIBarButtonItemStylePlain target:self action:@selector(removeLogin)];
            loginNavi = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:loginNavi animated:YES completion:nil];
        }];
        [alert addAction:goToLogin];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)removeLogin {
    [loginNavi dismissViewControllerAnimated:YES completion:^{
        [self downloadDataFromServer];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if(!libraryBorrowData) {
        UILabel* messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.height)];
        messageLabel.text = @"連線中！";
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
    
    if([libraryBorrowData count] != 0) {
        self.tableView.backgroundView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    }
    else {
        UILabel* messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.height)];
        messageLabel.text = @"沒有資料！";
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [libraryBorrowData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryModuleBorrowCells" forIndexPath:indexPath];
    
    ((UILabel*)[cell viewWithTag:101]).text = libraryBorrowData[indexPath.row][@"title"];
    ((UILabel*)[cell viewWithTag:102]).text = libraryBorrowData[indexPath.row][@"status"];
    ((UILabel*)[cell viewWithTag:103]).text = libraryBorrowData[indexPath.row][@"call"];
    ((UILabel*)[cell viewWithTag:104]).text = libraryBorrowData[indexPath.row][@"barcode"];
    
    return cell;
}



@end
