//
//  CalendarPageViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/4/25.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "CalendarPageViewController.h"
#import "CalendarTableViewController.h"

@interface CalendarPageViewController ()

@end

@implementation CalendarPageViewController

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
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //設定delegate
    self.dataSource = self;
    self.delegate = self;
    
    //讀取檔案
    calenderData = [[NSUserDefaults standardUserDefaults] objectForKey:@"CalendarModule"];
    if(!calenderData)
        calenderData = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CalendarModule" ofType:@"plist"]];
    
    [self setCalendarData];
    [self setViewControllers:@[pages[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    //下載檔案
    [self downloadDataFromServer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setCalendarData {
    //找出最大的年份
    NSArray* target = calenderData[@"event"];
    max_year = [[[target  valueForKeyPath:@"@max.DtStart"] substringToIndex:4] intValue];
    
    //讀取現在年份
    NSDateFormatter* formatter = [NSDateFormatter new];
    NSDate* now = [NSDate date];
    [formatter setDateFormat:@"YYYY"];
    now_year = [[formatter stringFromDate:now] intValue];
    //讀取現在月份
    [formatter setDateFormat:@"MM"];
    int nowMon = [[formatter stringFromDate:now] intValue];
    
    //如果過八月，年份使用下一年
    if(nowMon >= 8)
        now_year++;
    
    //相差太多年只列出三年份
    if(max_year - now_year > 3 || max_year - now_year < 0)
        now_year = max_year - 3;
    
    //做出年份字串陣列
    NSMutableArray* yearsTemp = [NSMutableArray new];
    for(int i = 0 ; i <= max_year - now_year ; i++)
    {
        [yearsTemp addObject:[[NSString alloc] initWithFormat:@"%d",now_year + i]];
    }
    years = [yearsTemp copy];
    
    //做出page 物件
    NSMutableArray* pagesTemp = [NSMutableArray new];
    for(int j = 0 ; j < [years count] ; j++)
    {
        CalendarTableViewController* page = [self.storyboard instantiateViewControllerWithIdentifier:@"CalendarTable"];
        
        page.year = now_year + j;
        //填入當年資料
        NSMutableArray* sectionData = [NSMutableArray new];
        for(int i = 0 ; i < [month count] ; i++)
        {
            //年月份的漏斗 例：201706
            NSString* sortKey;
            if(i < 5) // 8 ~ 12 月
                sortKey = [[NSString alloc]initWithFormat:@"%d%02d",now_year + j - 1,[monthNum[i] intValue]];
            else
                sortKey = [[NSString alloc]initWithFormat:@"%d%02d",now_year + j,[monthNum[i] intValue]];
            NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF['DtStart'] CONTAINS %@",sortKey];
            
            //排序工具 優先順序 DtStart > DtEnd
            NSSortDescriptor* DtStartDescriptor = [[NSSortDescriptor alloc] initWithKey:@"DtStart" ascending:YES];
            NSSortDescriptor* DtEndDescriptor = [[NSSortDescriptor alloc] initWithKey:@"DtEnd" ascending:YES];
            NSArray *sortDescriptors = @[DtStartDescriptor,DtEndDescriptor];
            NSArray *sortedArray = [[calenderData[@"event"] filteredArrayUsingPredicate:filter] sortedArrayUsingDescriptors:sortDescriptors];
            
            [sectionData addObject: sortedArray];
        }
        page.sectionData = [sectionData copy];
        
        [pagesTemp addObject:page];
    }
    pages = [pagesTemp copy];
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
                                                                                  [self setCalendarData];
                                                                                  [self setViewControllers:@[pages[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
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

#pragma mark - UIPageViewControllerDataSource

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    
    return [years count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    
    return 0;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if(viewController == nil)
        return pages[0];
    
    NSInteger idx = [pages indexOfObject:viewController];
    if(idx == 0)
        return nil;
    
    return pages[idx - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    
    if(viewController == nil)
        return pages[0];
    
    NSInteger idx = [pages indexOfObject:viewController];
    if(idx == [pages count] - 1)
        return nil;
    
    return pages[idx + 1];
}

@end
