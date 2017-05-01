//
//  StellarCourseInfoTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/29.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "StellarCourseInfoTableViewController.h"
#import "StellarClassViewController.h"
#import "Moodle.h"

@interface StellarCourseInfoTableViewController ()

@end

@implementation StellarCourseInfoTableViewController
@synthesize classData,courseInfoData;

static NSDictionary* tagName;
static NSArray* tagOrder;
static NSDictionary* mustType;

-(instancetype)initWithCoder:(NSCoder *)c {
    self = [super initWithCoder:c];
    if(self) {
        if(!tagName)
            tagName = @{@"ch_target":@"教學目標",@"must":@"選課類別",@"ch_teachsch":@"教學進度",@"ch_teach":@"教學方式",@"ch_preobj":@"先修科目",@"crd":@"學分",@"name":@"中文課名"
                        ,@"ch_object":@"教材內容",@"teacher":@"教授",@"ch_ref":@"參考書目",@"ch_type":@"評量方式",@"download_addr":@"參考網址",@"open_clsid":@"班級"
                        ,@"classroom":@"上課地點",@"id":@"課號",@"teacher":@"授課教授"};
        if(!tagOrder)
            tagOrder = @[@"name",@"open_clsid",@"classroom",@"id",@"teacher",@"must",@"crd",@"ch_target",@"ch_preobj",@"ch_object",@"ch_teach",@"ch_ref",@"ch_teachsch",@"ch_type",@"download_addr"];
        if(!mustType)
            mustType = @{@"A":@"A - 必修",@"B":@"B - 選修",@"C":@"C - 通識"};
    }
    return self;
}

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
            courseInfoData = [moodle getCourseInfoWithCosid:classData[@"id"] Clsid:classData[@"open_clsid"]];
            
            //檢查連線
            if(!courseInfoData) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"連線失敗！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
            //token過氣
            if([courseInfoData[@"result"] isEqualToString:@"-404"]) {
                NSDictionary* accountResult = [moodle loginAccount:moodle.account AndPassword:moodle.password];
                //帳號密碼錯誤或連線出問題
                if([accountResult[@"result"] isEqualToString:@"1"]) {
                    courseInfoData = [moodle getCourseInfoWithCosid:classData[@"id"] Clsid:classData[@"open_clsid"]];
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

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tagOrder count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StellarCourseCells" forIndexPath:indexPath];
    
    ((UILabel*)[cell viewWithTag:101]).text = tagName[tagOrder[indexPath.row]];
    [((UITextView*)[cell viewWithTag:102]) setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    if(indexPath.row<=3)
        ((UITextView*)[cell viewWithTag:102]).text = classData[tagOrder[indexPath.row]];
    else
        switch (indexPath.row) {
            case 5:
                ((UITextView*)[cell viewWithTag:102]).text = mustType[courseInfoData[tagOrder[indexPath.row]]];
                break;
                
            default:
                //(防閃退)是否存在物件
                if(courseInfoData[tagOrder[indexPath.row]])
                {
                    //(防閃退)是否是NSNumber
                    if([courseInfoData[tagOrder[indexPath.row]] isKindOfClass:[NSNumber class]])
                        ((UITextView*)[cell viewWithTag:102]).text = [courseInfoData[tagOrder[indexPath.row]] stringValue];
                    else
                        ((UITextView*)[cell viewWithTag:102]).text = courseInfoData[tagOrder[indexPath.row]];
                }
                else
                {
                    ((UITextView*)[cell viewWithTag:102]).text = @"";
                }
                break;
        }
    return cell;
}




@end
