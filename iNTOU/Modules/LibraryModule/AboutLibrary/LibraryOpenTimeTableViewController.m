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
    self.tableView.backgroundView = refresh;
    
    [self downloadDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadDataFromServer {
    [refresh beginRefreshing];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* urlString = @"http://lib.ntou.edu.tw/mobil_client/lib_open_xml.php";
        NSURL* url = [[NSURL alloc]initWithString:urlString];
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            libraryOpenTimeData = nil;
            if(data) {
                NSXMLParser* parser = [[NSXMLParser alloc]initWithData:data];
                parser.delegate = self;
                [parser parse];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [refresh endRefreshing];
                [self jumpToToday];
            });
        }];
        [task resume];
    });
}

-(void)jumpToToday {
    if(libraryOpenTimeData) {
        NSDate* now  = [NSDate new];
        int i;
        for(i = 0 ; i < [libraryOpenTimeData count] ; i++ ) {
            NSRange range;
            range = [libraryOpenTimeData[i][@"tagTitle"] rangeOfString:@"學期"];
            if(range.location == NSNotFound)
                range = [libraryOpenTimeData[i][@"tagTitle"] rangeOfString:@"時間"];
            if(range.location != NSNotFound) {
                NSString* dateString = [libraryOpenTimeData[i][@"tagTitle"] substringFromIndex:range.location + 2];
                range = [dateString rangeOfString:@"~"];
                dateString = [dateString substringToIndex:range.location];
                
                NSDateFormatter* formatter = [NSDateFormatter new];
                [formatter setDateFormat:@"yyyy/MM/dd"];
                range = [dateString rangeOfString:@"年"];
                int year = [[dateString substringToIndex:range.location] intValue] + 1911;
                dateString = [dateString substringFromIndex:range.location + 1];
                range = [dateString rangeOfString:@"月"];
                int month = [[dateString substringToIndex:range.location] intValue];
                dateString = [dateString substringFromIndex:range.location + 1];
                range = [dateString rangeOfString:@"日"];
                int date = [[dateString substringToIndex:range.location] intValue];
                dateString = [[NSString alloc] initWithFormat:@"%d/%d/%d",year,month,date];
                NSDate* tagDate = [formatter dateFromString:dateString];
                
                if([tagDate compare:now] == NSOrderedDescending)
                    break;
            }
        }
        i --;
        if(i<0)
            i=0;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(!libraryOpenTimeData) {
        UILabel* messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.height)];
        messageLabel.text = @"無法連線！下拉重新整理！";
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }

    if([libraryOpenTimeData count]) {
        self.tableView.backgroundView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return [libraryOpenTimeData count];
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
