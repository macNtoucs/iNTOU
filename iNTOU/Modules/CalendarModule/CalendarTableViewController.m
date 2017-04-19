//
//  CalendarTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/4/10.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "CalendarTableViewController.h"

@interface CalendarTableViewController ()

@end

@implementation CalendarTableViewController
static NSArray* month;
static NSArray* monthNum;

-(instancetype)initWithCoder:(NSCoder *)c {
    self = [super initWithCoder:c];
    if(self) {
        if(!month)
            month = @[@"八月",@"九月",@"十月",@"十一月",@"十二月",@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月"];
        if(!monthNum)
            monthNum = @[@"8",@"9",@"10",@"11",@"12",@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //讀取檔案
    calenderData = [[NSUserDefaults standardUserDefaults] objectForKey:@"CalendarModule"];
    if(!calenderData)
        calenderData = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CalendarModule" ofType:@"plist"]];
    [self setSectionData];
    
    //下載檔案
    [self downloadDataFromServer];
    
    [self.tableView reloadData];
    //讀取現在月份
    NSDateFormatter* formatter = [NSDateFormatter new];
    NSDate* now = [NSDate date];
    [formatter setDateFormat:@"MM"];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[[formatter stringFromDate:now] intValue] + 4 % 12] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSectionData {
    //找出最新的年份
    NSArray* target = calenderData[@"event"];
    max_year = [[[target  valueForKeyPath:@"@max.DtStart"] substringToIndex:4] intValue];
    
    sectionData = [NSMutableArray new];
    
    for(int i = 0 ; i < [month count] ; i++)
    {
        //年月份的漏斗 例：201706
        NSString* sortKey;
        if(i < 5) // 8 ~ 12 月
            sortKey = [[NSString alloc]initWithFormat:@"%d%02d",max_year - 1,[monthNum[i] intValue]];
        else
            sortKey = [[NSString alloc]initWithFormat:@"%d%02d",max_year,[monthNum[i] intValue]];
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF['DtStart'] CONTAINS %@",sortKey];
        
        //排序工具 優先順序 DtStart > DtEnd
        NSSortDescriptor* DtStartDescriptor = [[NSSortDescriptor alloc] initWithKey:@"DtStart" ascending:YES];
        NSSortDescriptor* DtEndDescriptor = [[NSSortDescriptor alloc] initWithKey:@"DtEnd" ascending:YES];
        NSArray *sortDescriptors = @[DtStartDescriptor,DtEndDescriptor];
        NSArray *sortedArray = [[calenderData[@"event"] filteredArrayUsingPredicate:filter] sortedArrayUsingDescriptors:sortDescriptors];
        
        [sectionData addObject: sortedArray];
    }
}


-(void)downloadDataFromServer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* urlString = @"http://140.121.100.103:8080/CalendarServlet/CalendarServlet.do";
        NSURL* url = [[NSURL alloc]initWithString:urlString];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        [request setHTTPMethod:@"POST"];
        NSString *postString = @"version=0&dataType=json";
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSession* session = [NSURLSession sharedSession];
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(data) {
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                //版本不符合
                if(![json[@"version"] isEqualToString:calenderData[@"version"]]) {
                    
                    //更新本地檔案
                    [[NSUserDefaults standardUserDefaults]setObject:json forKey:@"CalendarModule"];
                    
                    //跳出更新視窗
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"偵測到更新"
                                                                                       message:@"有新版本的行事曆！"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {
                                                                                  calenderData = json;
                                                                                  [self setSectionData];
                                                                                  [self.tableView reloadData];
                                                                              }];
                        
                        [alert addAction:defaultAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    });
                }
                
            }
            dispatch_semaphore_signal(semaphore);
        }];
        [task resume];
        dispatch_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 12;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [sectionData[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalendarCells" forIndexPath:indexPath];
    
    NSDictionary* cellData = sectionData[indexPath.section][indexPath.row];
    //格式轉換
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSDate* DtStart = [formatter dateFromString:cellData[@"DtStart"]];
    NSDate* DtEnd = [formatter dateFromString:cellData[@"DtEnd"]];
    [formatter setDateFormat:@"MM/dd(E)"];
    
    //判斷有無同天發生
    if([cellData[@"DtStart"] isEqualToString:cellData[@"DtEnd"]])
        ((UILabel*)[cell viewWithTag:101]).text = [formatter stringFromDate:DtStart];
    else
        ((UILabel*)[cell viewWithTag:101]).text = [[NSString alloc]initWithFormat:@"%@ ～ %@",[formatter stringFromDate:DtStart],[formatter stringFromDate:DtEnd]];
    
    //事件內容
    ((UILabel*)[cell viewWithTag:102]).text = cellData[@"Summary"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section < 5)
        return [[NSString alloc] initWithFormat:@"%d年%@",max_year - 1,month[section]];
    else
        return [[NSString alloc] initWithFormat:@"%d年%@",max_year,month[section]];
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
    return index;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return monthNum;
}


@end
