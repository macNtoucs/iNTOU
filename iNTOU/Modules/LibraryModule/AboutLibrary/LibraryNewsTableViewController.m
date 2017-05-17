//
//  LibraryNewsTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/5.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "LibraryNewsTableViewController.h"
#import <SafariServices/SafariServices.h>

@interface LibraryNewsTableViewController () {
    NSMutableArray* cellData;
    NSMutableDictionary* news;
    NSMutableString* parserTemp;
}

@end

@implementation LibraryNewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(!libraryNewsData) {
        UILabel* messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.height)];
        messageLabel.text = @"連線中！";
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
    
    if([libraryNewsData count] != 0) {
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
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [libraryNewsData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryModuleNewsCells" forIndexPath:indexPath];

    ((UILabel*)[cell viewWithTag:101]).text = libraryNewsData[indexPath.row][@"news_title"];
    ((UILabel*)[cell viewWithTag:102]).text = libraryNewsData[indexPath.row][@"news_date"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFSafariViewController* safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:libraryNewsData[indexPath.row][@"news_url"]]];
    [self presentViewController:safari animated:YES completion:nil];
}


-(void)downloadDataFromServer {
    [refresh beginRefreshing];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* urlString = @"http://lib.ntou.edu.tw/mobil_client/lib_news_xml.php";
        NSURL* url = [[NSURL alloc]initWithString:urlString];
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(data) {
                NSXMLParser* parser = [[NSXMLParser alloc]initWithData:data];
                parser.delegate = self;
                [parser parse];
            }
            dispatch_semaphore_signal(semaphore);
        }];
        [task resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [refresh endRefreshing];
        });
    });
}

#pragma <NSXMLParserDelegate>

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    cellData = [NSMutableArray new];
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    if([elementName isEqualToString:@"news"]) {
        news = [NSMutableDictionary new];
    }
    parserTemp = [NSMutableString new];
}

- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string {
    [parserTemp appendString:string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"news"]) {
        [cellData addObject:[news copy]];
    }
    [news setObject:parserTemp forKey:elementName];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    libraryNewsData = [cellData copy];
}


@end
