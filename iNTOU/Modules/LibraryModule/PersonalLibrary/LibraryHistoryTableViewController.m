//
//  LibraryHistoryTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/6.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "LibraryHistoryTableViewController.h"

@interface LibraryHistoryTableViewController ()

@end

@implementation LibraryHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    library = [Library sharedInstance];
    maxSegment = 0;
    threadLock = false;
    
    //刷新鈕
    refresh =[UIRefreshControl new];
    [refresh addTarget:self action:@selector(initDownloadDataFromServer) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refresh;
    
    libraryHistoryData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"]];
    [self initDownloadDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initDownloadDataFromServer {
    [refresh beginRefreshing];
    [self downloadDataFromServer:1];
}

-(void)downloadDataFromServer:(int)segment {
    threadLock = true;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([library checkLogin]) {
            
            NSArray* libraryHistoryDataTemp = [library getReadingHistory:segment];
            if(!libraryHistoryDataTemp) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"登入失敗或連線失敗！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                if(segment == 1) {
                    libraryHistoryData = libraryHistoryDataTemp;
                }
                else {
                    libraryHistoryData = [libraryHistoryData arrayByAddingObjectsFromArray:libraryHistoryDataTemp];
                }
                maxSegment = segment;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [refresh endRefreshing];
            });
            
        }
        else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"沒有登入的帳號！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    });
    threadLock = false;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if([libraryHistoryData count] != 0) {
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

    return [libraryHistoryData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryModuleHistoryCells" forIndexPath:indexPath];
    
    ((UILabel*)[cell viewWithTag:101]).text = libraryHistoryData[indexPath.row][@"title"];
    ((UILabel*)[cell viewWithTag:103]).text = libraryHistoryData[indexPath.row][@"borrowDate"];
    
    return cell;
}


#pragma mark - Table view

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    //處理上拉自動更新
    if(indexPath.row >= maxSegment*10 - 5 ){
        if(!threadLock) {
            [self downloadDataFromServer:maxSegment+1];
        }
    }
}

@end
