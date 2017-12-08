//
//  LibrarySearchResultTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/9.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "LibrarySearchResultTableViewController.h"

@interface LibrarySearchResultTableViewController ()

@end

@implementation LibrarySearchResultTableViewController
@synthesize searchKey,type;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = searchKey;
    
    //刷新鈕
    refresh = [UIRefreshControl new];
    [refresh addTarget:self action:@selector(downloadDataFromServerInit) forControlEvents:UIControlEventValueChanged];
    self.tableView.backgroundView = refresh;
    
    [self downloadDataFromServerInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadDataFromServerInit {
    if(!threadLock) {
        [refresh beginRefreshing];
        [self downloadDataFromServer:1];
    }
}

-(void)downloadDataFromServer:(int)segment {
    threadLock = true;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString* urlString = [[NSString alloc]initWithFormat:@"http://140.121.100.103:8080/NTOULibraryAPI/Search.do?searcharg=%@&searchtype=%@&segment=%d",searchKey,type,segment];
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL* url = [[NSURL alloc]initWithString:urlString];
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:300.0];
        
        NSURLSession* session = [NSURLSession sharedSession];
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSData* __block result;
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            result = data;
            dispatch_semaphore_signal(semaphore);
        }];
        [task resume];
        dispatch_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        if(result) {
            NSDictionary* resultDataTemp = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if(resultDataTemp) {
                if(segment == 1) {
                    searchResultdata = resultDataTemp;
                    bookResult = resultDataTemp[@"bookResult"];
                    maxSegment = segment;
                }
                else {
                    if([resultDataTemp[@"bookResult"] count] > 0) {
                        bookResult = [bookResult arrayByAddingObjectsFromArray:resultDataTemp[@"bookResult"]];
                        maxSegment = segment;
                    }
                    else {
                        threadLock = false;
                        return;
                    }
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = [[NSString alloc]initWithFormat:@"共%d筆",[searchResultdata[@"totalBookNumber"] intValue]];
            [refresh endRefreshing];
            [self.tableView reloadData];
            threadLock = false;
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [bookResult count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryModuleSearchResultCells" forIndexPath:indexPath];
    
    ((UILabel*)[cell viewWithTag:101]).text = bookResult[indexPath.row][@"title"];
    
    NSString*author = bookResult[indexPath.row][@"author"];
    if(![author isEqualToString:@""])
        author = [[NSString alloc]initWithFormat:@"%@\n",author];
    
    ((UILabel*)[cell viewWithTag:102]).text = [[NSString alloc]initWithFormat:@"%@%@",author,bookResult[indexPath.row][@"pubInform"]];
    
    ((UIImageView*)[cell viewWithTag:103]).image = nil;
    if(bookResult[indexPath.row][@"image"]) {
            NSURL* url = [[NSURL alloc]initWithString:bookResult[indexPath.row][@"image"]];
            NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
            
            NSURLSession* session = [NSURLSession sharedSession];
            NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ((UIImageView*)[cell viewWithTag:103]).image = [[UIImage alloc]initWithData:data];
                });
            }];
            [task resume];
    }
    
    return cell;
}

#pragma mark - table view 

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    //處理上拉自動更新
    if(indexPath.row >= maxSegment*10 - 5) {
        if(!threadLock) {
            [self downloadDataFromServer:maxSegment + 1];
        }
        
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    id des = [segue destinationViewController];
    [des setValue:bookResult[indexPath.row] forKey:@"searchResultData"];
}


@end
