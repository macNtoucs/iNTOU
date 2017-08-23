//
//  Library.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/26.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "Library.h"

@implementation Library
@synthesize account,password;

+(Library*)sharedInstance {
    static Library *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [Library new];
        [sharedInstance load];
    });

    return sharedInstance;
}

-(NSData*)sendToAPIType:(NSString*)type andpostString:(NSString*)postString {
    //通用的送出資料函式
    NSString* urlString = [[NSString alloc]initWithFormat:@"http://140.121.100.103:8080/NTOULibraryAPI/%@",type];
    NSURL* url = [[NSURL alloc]initWithString:urlString];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSData* __block returnValue = nil;
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        returnValue = data;
        NSLog(@"%@",returnValue);
        dispatch_semaphore_signal(semaphore);
    }];
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return returnValue;
}

-(Boolean)checkLogin {
    if(account)
        return true;
    return false;
}

-(void)loginAccount:(NSString*)account_temp AndPassword:(NSString*)password_temp {
    NSData* resultData = [self sendToAPIType:@"login.do" andpostString:[[NSString alloc] initWithFormat:@"account=%@&password=%@",account_temp,password_temp]];
    NSString* result = [[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
    
    if([result rangeOfString:@"Login success"].location != NSNotFound) {
        account = account_temp;
        password = password_temp;
        [self save];
    }
}

-(void)logout {
    [self clear];
    [self remove];
}

-(NSArray*)getReadingHistory:(int)segment {
    
    NSData* result = [self sendToAPIType:@"getReadingHistory.do" andpostString:[[NSString alloc] initWithFormat:@"account=%@&password=%@&segment=%d",account,password,segment]];
    
    NSArray* resultArray = nil;
    
    if(result) {
        resultArray = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
    }
    
    return resultArray;
     
}

-(NSArray*)getCurrentHolds {
    NSData* result = [self sendToAPIType:@"getCurrentHolds.do" andpostString:[[NSString alloc] initWithFormat:@"account=%@&password=%@",account,password]];
    
    NSArray* resultArray = nil;
    
    if(result) {
        resultArray = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
    }
    
    return resultArray;
}

-(NSArray*)getCurrentBorrowedBooks {
    NSData* result = [self sendToAPIType:@"getCurrentBorrowedBooks.do" andpostString:[[NSString alloc] initWithFormat:@"account=%@&password=%@",account,password]];
    
    NSArray* resultArray = nil;
    
    if(result) {
        resultArray = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
    }
    
    return resultArray;
}

#pragma mark - low layer

-(void)load {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    account = [defaults objectForKey:@"Library_account"];
    password = [defaults objectForKey:@"Library_password"];
}

-(void)save {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:account forKey:@"Library_account"];
    [defaults setObject:password forKey:@"Library_password"];
}

-(void)clear {
    account = nil;
    password = nil;
}

-(void)remove {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"Library_account"];
    [defaults removeObjectForKey:@"Library_password"];
}

@end
