//
//  NewsClassData.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "NewsClassData.h"

@implementation NewsClassData 
@synthesize classType,threadLock,classData,status,MaxPage;

-(void)downloadDataFromServer:(int)page {
        NSString* urlString = [[NSString alloc]initWithFormat:@"http://140.121.81.93/api/ntou_app.php?page=%d&count=10&class=",page];
        urlString = [urlString stringByAppendingString:classType];
        NSURL* url = [[NSURL alloc]initWithString:urlString];
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        
        NSURLSession* session = [NSURLSession sharedSession];
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSData* __block dataSource;
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dataSource = data;
            dispatch_semaphore_signal(semaphore);
        }];
        [task resume];
        dispatch_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        if(dataSource) {
            NSString* dataSouceString = [[NSString alloc]initWithData:dataSource encoding:NSUTF8StringEncoding];
            dataSouceString = [dataSouceString stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
            dataSouceString = [dataSouceString stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
            dataSource = [dataSouceString dataUsingEncoding:NSUTF8StringEncoding];
            
            if(![self parse:dataSource]) {
                status = @"解析失敗！";
            }
            else {
                if(page == 1) {
                classData = [dataTemp copy];
                
                NSDateFormatter* formatter = [NSDateFormatter new];
                [formatter setDateFormat:@"YYYY年MM月d日 H:m:s"];
                status = [@"最後更新於 " stringByAppendingString:[formatter stringFromDate:[NSDate date]]];
                }
                else {
                    classData = [classData arrayByAddingObjectsFromArray:[dataTemp copy]];
                }
                MaxPage = page;
            }
        }
        else
            status = @"下載失敗！";
        
}


-(BOOL)parse:(NSData *)nsData {
    NSXMLParser* parser = [[NSXMLParser alloc]initWithData:nsData];
    [parser setDelegate:self];
    return [parser parse];
}

#pragma mark - <NSXMLParserDelegate>

//XML開始
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    dataTemp = [NSMutableArray new];
}

//XML標籤開始
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if([elementName isEqualToString:@"notice"]) {
        dataElemetTemp = [NSMutableDictionary new];
        [dataElemetTemp setObject:[NSMutableArray new] forKey:@"Attachment_Title"];
        [dataElemetTemp setObject:[NSMutableArray new] forKey:@"Attachment_URL"];
    }
    parseStringTemp = [NSMutableString new];
    
}

//XML標籤內文
- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string {
    
    [parseStringTemp appendString:string];
}

//XML CDATABlock
- (void)parser:(NSXMLParser *)parser
    foundCDATA:(NSData *)CDATABlock {
    NSString* templateString = [[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    [parseStringTemp appendString:templateString];
}

//XML標籤結束
- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    if(![elementName isEqualToString:@"ntou"])
    {
        NSString* parseString = [parseStringTemp copy];
        
        parseString = [parseString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        parseString = [parseString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        
        if([elementName isEqualToString:@"notice"]) {
            [dataElemetTemp setValue:[dataElemetTemp[@"Attachment_Title"] copy] forKey:@"Attachment_Title"];
            [dataElemetTemp setValue:[dataElemetTemp[@"Attachment_URL"] copy] forKey:@"Attachment_URL"];
            [dataTemp addObject:[dataElemetTemp copy]];
            return;
        }
        
        if([elementName isEqualToString:@"Attachment_Title"] || [elementName isEqualToString:@"Attachment_URL"]) {
            [dataElemetTemp[elementName] addObject: parseString];
            return;
        }
        
        
        if([elementName isEqualToString:@"body"]) {
            parseString = [parseString stringByReplacingOccurrencesOfString:@"[url]" withString:@""];
            parseString = [parseString stringByReplacingOccurrencesOfString:@"[/url]" withString:@""];
        }
        
        if([elementName isEqualToString:@"title"]) {
            parseString = [parseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            parseString = [parseString stringByReplacingOccurrencesOfString:@"　" withString:@""];
        }
        
        if(![elementName isEqualToString:@"notice"])
            [dataElemetTemp setObject:parseString forKey:elementName];
    }
}

//XML結束
- (void)parserDidEndDocument:(NSXMLParser *)parser {
}

@end
