//
//  NewsViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsClassData.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

@synthesize newsTableView,statusLabel,buttonBar,buttonBarWidth,selected,buttons;

static NSString* reuseIdentifier = @"NewsCells";
static NSArray* classType;
static NSArray* className;

-(instancetype)initWithCoder:(NSCoder *)c {
    self = [super initWithCoder:c];
    if(self) {
        //在這裡新增新的class type
        classType = @[@"focus",@"announce",@"symposium",@"admissions",@"information",@"art",@"lecture"];
        className = @[@"校園焦點",@"學校公告",@"研討會",@"招生資訊",@"校外公告",@"藝文活動",@"演講公告"];
        
        //製造對應數量的NewsClassData來儲存資料
        NSMutableArray* tempArray = [NSMutableArray new];
        for(int i=0;i< [classType count];i++) {
            NewsClassData* newsClassData = [NewsClassData new];
            newsClassData.classType = classType[i];
            [tempArray addObject:newsClassData];
        }
        classData = [tempArray copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    refresh =[UIRefreshControl new];
    [refresh addTarget:self action:@selector(downloadDataFromServerInit) forControlEvents:UIControlEventValueChanged];
    newsTableView.refreshControl = refresh;
    
    //製造對應數量的class type按鈕
    buttonBarWidth.constant = [className count] * 80;
    NSMutableArray* tempArray = [NSMutableArray new];
    for(int i = 0; i < [className count]; i++) {
        UIButton* b = [UIButton buttonWithType:UIButtonTypeSystem];
        [b setTintColor:[UIColor whiteColor]];
        [b setTitle:className[i] forState:UIControlStateNormal];
        [b setFrame:CGRectMake(0 + i*80, 0, 80, 44)];
        [b setTag:i];
        [b addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [buttonBar addSubview: b];
        [tempArray addObject:b];
    }
    buttons = [tempArray copy];
    
    [self buttonPressed:buttons[0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonPressed:(UIButton*)button {
    [buttons[selected] setEnabled:YES];
    selected = (int)[button tag];
    self.title = className[(int)button.tag];
    [buttons[selected] setEnabled:NO];
    
    //清空
    cellsData = nil;
    [newsTableView reloadData];
    
    statusLabel.text = [classData[(int)button.tag] status];
    
    //判斷是否已經下載過資料
    if([classData[(int)button.tag] classData]) {
        [refresh endRefreshing];
        cellsData = [((NewsClassData*)classData[(int)button.tag]) classData];
        [newsTableView reloadData];
    }
    else {
        [refresh beginRefreshing];
        [newsTableView setContentOffset:CGPointMake(0,-refresh.frame.size.height) animated:YES];
        statusLabel.text = @"下載中...";
        [self downloadDataFromServerInit];
    }
}

-(void)downloadDataFromServerInit {
    [self downloadDataFromServer:1];
}

-(void)downloadDataFromServer:(int)page {
    if(![classData[selected] threadLock]) {
        ((NewsClassData*)classData[selected]).threadLock = true;
        int tempSelected = selected;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [classData[tempSelected] downloadDataFromServer:page];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                ((NewsClassData*)classData[selected]).threadLock = false;
                //頁面與使用者所選相同才自動更新
                if(tempSelected == selected) {
                    cellsData = [((NewsClassData*)classData[tempSelected]) classData];
                    statusLabel.text = [((NewsClassData*)classData[tempSelected]) status];
                    [newsTableView reloadData];
                    [refresh endRefreshing];
                }
            });
        });
    }
    else {
        [refresh beginRefreshing];
        statusLabel.text = @"下載中...";
        [newsTableView setContentOffset:CGPointMake(0,-refresh.frame.size.height) animated:YES];
    }
}


//轉換16進位為UIColor
-(UIColor*)colorFromHexString:(NSString*)hexString {
    if([hexString length] == 0)
        return [UIColor blackColor];
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

-(IBAction)leftScroll:(id)sender {
    CGFloat x = self.scrollBar.contentOffset.x;
    if(x - 80 < 0)
        x = 0;
    else
        x = x - 80;
    [self.scrollBar setContentOffset:CGPointMake(x, self.scrollBar.contentOffset.y) animated:YES];
    [self checkScrollButton:x];
}

-(IBAction)rightScroll:(id)sender {
    CGFloat x = self.scrollBar.contentOffset.x;
    if(x + 80 > [className count] * 80 - self.scrollBar.frame.size.width)
        x = [className count] * 80 - self.scrollBar.frame.size.width;
    else
        x = x + 80;
    [self.scrollBar setContentOffset:CGPointMake(x, self.scrollBar.contentOffset.y) animated:YES];
    [self checkScrollButton:x];
}

-(void)checkScrollButton:(CGFloat)x{

    if(x == 0)
       [self.leftScrollButton setHidden:YES];
    else
        [self.leftScrollButton setHidden:NO];
    
    if(x == [className count] * 80 - self.scrollBar.frame.size.width)
       [self.rightScrollButton setHidden:YES];
    else
        [self.rightScrollButton setHidden:NO];
    
}

#pragma mark - sroll view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView == self.scrollBar)
        [self checkScrollButton:self.scrollBar.contentOffset.x];
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cellsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    ((UILabel*)[cell viewWithTag:101]).text = cellsData[indexPath.row][@"title"];
    ((UILabel*)[cell viewWithTag:101]).textColor = [self colorFromHexString:cellsData[indexPath.row][@"color"]];
    ((UILabel*)[cell viewWithTag:102]).text = cellsData[indexPath.row][@"dpname"];
    ((UILabel*)[cell viewWithTag:103]).text = cellsData[indexPath.row][@"pubDate"];
    
    return cell;
}

#pragma mark - TableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"Action" sender:indexPath];
}


- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //處理上拉自動更新
    if(indexPath.row >= ((NewsClassData*)classData[selected]).MaxPage*10 - 5) {
        if(![classData[selected] threadLock]) {
                [self downloadDataFromServer:((NewsClassData*)classData[selected]).MaxPage + 1];
        }
        
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id page = [segue destinationViewController];
    [page setValue:cellsData[[sender row]] forKey:@"data"];
}





@end
