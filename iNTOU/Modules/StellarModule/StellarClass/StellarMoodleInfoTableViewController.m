//
//  StellarMoodleInfoTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/29.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "StellarMoodleInfoTableViewController.h"
#import "StellarClassViewController.h"
#import "MBProgressHUD.h"
#import "Moodle.h"

@interface StellarMoodleInfoTableViewController ()

@end

@implementation StellarMoodleInfoTableViewController
@synthesize classData,moodleInfoData;

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
            moodleInfoData = [moodle getMoodleInfoWithClosid:classData[@"id"] Clsid:classData[@"open_clsid"]];
            //檢查連線
            if(!moodleInfoData) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"連線失敗！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
            //token過氣
            if([moodleInfoData[@"result"] isEqualToString:@"-404"]) {
                NSDictionary* accountResult = [moodle loginAccount:moodle.account AndPassword:moodle.password];
                //帳號密碼錯誤或連線出問題
                if([accountResult[@"result"] isEqualToString:@"1"]) {
                    moodleInfoData = [moodle getMoodleInfoWithClosid:classData[@"id"] Clsid:classData[@"open_clsid"]];
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
    if([moodleInfoData[@"list"][0][@"infos"] count] != 0) {
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

    return [moodleInfoData[@"list"][0][@"infos"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StellarMoodleCells" forIndexPath:indexPath];

    cell.textLabel.text = moodleInfoData[@"list"][0][@"infos"][indexPath.row][@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSRange range = [moodleInfoData[@"list"][0][@"infos"][indexPath.row][@"url"] rangeOfString:@"id="];
    if (range.location != NSNotFound) {
        NSString *closid = [moodleInfoData[@"list"][0][@"infos"][indexPath.row][@"url"] substringFromIndex:range.location + 3];
        
        Moodle* moodle = [Moodle sharedInstance];
        NSDictionary* InfoData = [moodle MoodleInfoWithModule:moodleInfoData[@"list"][0][@"infos"][indexPath.row][@"module"] Mid:closid Closid:classData[@"id"] Clsid:classData[@"open_clsid"]];
        NSMutableString* body = [NSMutableString new];
        
        if(InfoData[@"summary"] && ![InfoData[@"summary"] isEqualToString:@""])
            [body appendString:InfoData[@"summary"]];
        
        if(InfoData[@"description"] && ![InfoData[@"description"] isEqualToString:@""])
            [body appendString:InfoData[@"description"]];
        
        if(InfoData[@"reference"] && ![InfoData[@"reference"] isEqualToString:@""] && ![InfoData[@"reference"] isEqualToString:@"http://"])
            [body appendString:[[NSString alloc] initWithFormat:@"<a href='%@'>連結</a>",InfoData[@"reference"]]];
        
        UIWebView* web = [[UIWebView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
        [web loadHTMLString:[[NSString alloc] initWithFormat:@"<body>%@</body>",[body copy]] baseURL:nil];
        UIViewController* controller = [UIViewController new];
        controller.view = web;
        [self showViewController:controller sender:nil];
    }
}



@end
