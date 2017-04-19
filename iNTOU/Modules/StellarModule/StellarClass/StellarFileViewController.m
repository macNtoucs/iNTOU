//
//  StellarFileViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/29.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "StellarFileViewController.h"
#import "StellarClassViewController.h"
#import "Moodle.h"
#import <SafariServices/SafariServices.h>

@interface StellarFileViewController ()

@end

@implementation StellarFileViewController
@synthesize classData,fileTableView,selected,buttonBoard;

static NSArray* types;

-(instancetype)initWithCoder:(NSCoder *)c {
    self = [super initWithCoder:c];
    if(self) {
        if(!types)
            types = @[@"考古題",@"課程講義",@"作業"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    classData = ((StellarClassViewController*)self.tabBarController).classData;
    
    //刷新鈕
    refresh =[UIRefreshControl new];
    [refresh addTarget:self action:@selector(downloadDataFromServer:) forControlEvents:UIControlEventValueChanged];
    fileTableView.refreshControl = refresh;
    
    //製造對應數量的class type按鈕
    NSMutableArray* tempArray = [NSMutableArray new];
    for(int i = 0; i < [types count]; i++) {
        UIButton* b = [UIButton buttonWithType:UIButtonTypeSystem];
        [b setTintColor:[UIColor whiteColor]];
        [b setTitle:types[i] forState:UIControlStateNormal];
        [b setFrame:CGRectMake(0 + i*80, 0, 80, 40)];
        [b setTag:i];
        [b addTarget:self action:@selector(buttonHandler:) forControlEvents:UIControlEventTouchDown];
        [buttonBoard addSubview: b];
        [tempArray addObject:b];
    }
    buttons = [tempArray copy];
    
    [self buttonHandler:buttons[0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadDataFromServer:(int)tag {
    [refresh beginRefreshing];
    int tempSelected = selected;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Moodle* moodle = [Moodle sharedInstance];
        if([moodle checkLogin]) {
            if(!moodleid) {
                NSDictionary* result = [moodle getMoodleIDWithClosid:classData[@"id"] Clsid:classData[@"open_clsid"]];
                moodleid = result[@"moodleid"];
                
                //檢查連線
                if(!result) {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"連線失敗！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancel];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                //token過氣
                if([result[@"result"] isEqualToString:@"-404"]) {
                    NSDictionary* accountResult = [moodle loginAccount:moodle.account AndPassword:moodle.password];
                    //帳號密碼錯誤或連線出問題
                    if([accountResult[@"result"] isEqualToString:@"1"]) {
                        result = [moodle getMoodleIDWithClosid:classData[@"id"] Clsid:classData[@"open_clsid"]];
                        moodleid = result[@"moodleid"];
                    }
                    else {
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"Moodle帳號密碼錯誤或連線失敗！" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
                        [alert addAction:cancel];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }
                
            }
            cellData = [Moodle getDirWithMoodleId:moodleid Type:types[tempSelected]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(tempSelected == selected)
                    [fileTableView reloadData];
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

- (void)buttonHandler:(UIButton *)sender {
    [(UIButton*)buttons[selected] setEnabled:YES];
    
    selected = (unsigned int)[sender tag];
    refresh.tag = (int)[sender tag];
    [(UIButton*)buttons[selected] setEnabled:NO];
    [self downloadDataFromServer:(int)[sender tag]];
    [fileTableView setContentOffset:CGPointMake(0,-refresh.frame.size.height) animated:YES];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if([cellData count] != 0) {
        fileTableView.backgroundView = nil;
        fileTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    }
    else {
        UILabel* messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.height)];
        messageLabel.text = @"沒有資料！";
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        fileTableView.backgroundView = messageLabel;
        fileTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [cellData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StellarFileCells" forIndexPath:indexPath];

        cell.textLabel.text = cellData[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cellData count] != 0) {
        NSString* urlString = [[NSString alloc]initWithFormat:@"http://moodle.ntou.edu.tw/file.php/%@/%@/%@",moodleid,types[selected],cellData[indexPath.row]];
        //ios 不支援網址中有中文，用下行重新encoding
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        SFSafariViewController* safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:urlString]];
        [self presentViewController:safari animated:YES completion:nil];
    }
}




@end
