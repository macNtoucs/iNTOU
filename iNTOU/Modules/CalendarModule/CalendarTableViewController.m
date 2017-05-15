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
@synthesize year,sectionData;

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
    
    //DtEnd - 1天 ？？？
    NSDateComponents *dayComponent = [NSDateComponents new];
    dayComponent.day = -1;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    DtEnd = [theCalendar dateByAddingComponents:dayComponent toDate:DtEnd options:0];
    
    //判斷有無同天發生
    if([[formatter stringFromDate:DtStart] isEqualToString:[formatter stringFromDate:DtEnd]])
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
        return [[NSString alloc] initWithFormat:@"%d年%@",year - 1,month[section]];
    else
        return [[NSString alloc] initWithFormat:@"%d年%@",year,month[section]];
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
