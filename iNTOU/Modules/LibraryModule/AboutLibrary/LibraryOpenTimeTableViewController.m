//
//  LibraryOpenTimeTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/5.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "LibraryOpenTimeTableViewController.h"

@interface LibraryOpenTimeTableViewController () {
    NSMutableArray* tags;
    NSString* tagTitle;
    NSMutableArray* cellDataTemp;
    NSMutableArray* cellDataType;
    NSDictionary* service;
    NSMutableDictionary* tag;
    NSMutableString* xmlParseTemp;
}

@end

@implementation LibraryOpenTimeTableViewController

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

    return [libraryOpenTimeData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [libraryOpenTimeData[section][@"cellData"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return libraryOpenTimeData[section][@"tagTitle"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch ([libraryOpenTimeData[indexPath.section][@"cellDataType"][indexPath.row] intValue]) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryModuleOpenTimeCells0" forIndexPath:indexPath];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryModuleOpenTimeCells1" forIndexPath:indexPath];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryModuleOpenTimeCells2" forIndexPath:indexPath];
            break;
            
        default:
            break;
    }
    
    switch ([libraryOpenTimeData[indexPath.section][@"cellDataType"][indexPath.row] intValue]) {
        case 0:
            cell.textLabel.text = libraryOpenTimeData[indexPath.section][@"cellData"][indexPath.row];
            break;
        case 1:
            cell.textLabel.text = libraryOpenTimeData[indexPath.section][@"cellData"][indexPath.row][@"serviceTitle"];
            cell.detailTextLabel.text = libraryOpenTimeData[indexPath.section][@"cellData"][indexPath.row][@"serviceDetail"];
            break;
        case 2:
            [((UITextView*)[cell viewWithTag:102]) setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            ((UILabel*)[cell viewWithTag:101]).text = @"備註";
            ((UITextView*)[cell viewWithTag:102]).text = libraryOpenTimeData[indexPath.section][@"cellData"][indexPath.row];
            break;
            
        default:
            break;
    }

    return cell;
}


-(void)downloadDataFromServer {
    [refresh beginRefreshing];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* urlString = @"http://lib.ntou.edu.tw/mobil_client/lib_open_xml.php";
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

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    tags = [NSMutableArray new];
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if([elementName isEqualToString:@"tag"]) {
        tag = [NSMutableDictionary new];
        cellDataTemp = [NSMutableArray new];
        cellDataType = [NSMutableArray new];
        tagTitle = [attributeDict[@"value"] copy];
    }
    if([elementName isEqualToString:@"week"]) {
        [cellDataTemp addObject:[attributeDict[@"value"] copy]];
        [cellDataType addObject:@0];
    }
    if([elementName isEqualToString:@"service"]) {
        service = [NSMutableDictionary new];
        [service setValue:[attributeDict[@"value"] copy] forKey:@"serviceTitle"];
    }
    xmlParseTemp = [NSMutableString new];
}

- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string {
    [xmlParseTemp appendString:string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"service"]) {
        [service setValue:[xmlParseTemp copy] forKey:@"serviceDetail"];
        [cellDataTemp addObject:[service copy]];
        [cellDataType addObject:@1];
    }
    if([elementName isEqualToString:@"note"]) {
        [cellDataTemp addObject:[xmlParseTemp copy]];
        [cellDataType addObject:@2];
    }
    if([elementName isEqualToString:@"tag"]) {
        [tag setObject:[tagTitle copy] forKey:@"tagTitle"];
        [tag setObject:[cellDataTemp copy] forKey:@"cellData"];
        [tag setObject:[cellDataType copy] forKey:@"cellDataType"];
        [tags addObject:[tag copy]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    libraryOpenTimeData = [tags copy];
}

@end
