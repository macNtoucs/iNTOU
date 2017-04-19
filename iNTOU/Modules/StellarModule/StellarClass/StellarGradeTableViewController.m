//
//  StellarGradeTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/29.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "StellarGradeTableViewController.h"
#import "StellarClassViewController.h"
#import "Moodle.h"

@interface StellarGradeTableViewController ()

@end

@implementation StellarGradeTableViewController
@synthesize classData,gradeData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    classData = ((StellarClassViewController*)self.tabBarController).classData;
    
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Moodle* moodle = [Moodle sharedInstance];
        if([moodle checkLogin]) {
            gradeData = [moodle getgetGradeWithClosid:classData[@"id"] Clsid:classData[@"open_clsid"]];
            //檢查連線
            if(!gradeData) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"連線失敗！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
            //token過氣
            if([gradeData[@"result"] isEqualToString:@"-404"]) {
                NSDictionary* accountResult = [moodle loginAccount:moodle.account AndPassword:moodle.password];
                //帳號密碼錯誤或連線出問題
                if([accountResult[@"result"] isEqualToString:@"1"]) {
                    gradeData = [moodle getgetGradeWithClosid:classData[@"id"] Clsid:classData[@"open_clsid"]];
                }
                else {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"Moodle帳號密碼錯誤或連線失敗！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancel];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [refresh endRefreshing];
            });
        }
        else {
            [refresh endRefreshing];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"沒有登入的Moodle帳戶，請前往設定登入！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if([gradeData[@"list"] count] != 0) {
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
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [gradeData[@"list"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StellarGradeCells" forIndexPath:indexPath];
    

    ((UILabel*)[cell viewWithTag:101]).text = gradeData[@"list"][indexPath.row][@"name"];
    if(gradeData[@"list"][indexPath.row][@"grade"]) {
        if([gradeData[@"list"][indexPath.row][@"grade"] isKindOfClass:[NSNumber class]])
            ((UILabel*)[cell viewWithTag:102]).text = [[NSString alloc] initWithFormat:@"分數：%@",[gradeData[@"list"][indexPath.row][@"grade"] stringValue]];
        else
            ((UILabel*)[cell viewWithTag:102]).text = [[NSString alloc] initWithFormat:@"分數：%@",gradeData[@"list"][indexPath.row][@"grade"]];

    }
    else {
        ((UILabel*)[cell viewWithTag:102]).text = @"";
    }
    ((UITextView*)[cell viewWithTag:103]).text = gradeData[@"list"][indexPath.row][@"comment"];
    
    return cell;
}



@end
