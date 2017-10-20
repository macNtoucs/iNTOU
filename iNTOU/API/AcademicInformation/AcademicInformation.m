//
//  AcademicInformation.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/10/18.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "AcademicInformation.h"

@implementation AcademicInformation
@synthesize account,password;

+(AcademicInformation*)sharedInstance {
    static AcademicInformation *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [AcademicInformation new];
        [sharedInstance load];
    });
    
    return sharedInstance;
}

-(Boolean)checkLogin {
    if(account)
        return true;
    return false;
}

-(void)loginAccount:(NSString*)account_temp AndPassword:(NSString*)password_temp {
    NSString* urlString = [[NSString alloc]initWithFormat:@"https://ais.ntou.edu.tw/SCSPhotoQuery.aspx?ACNT=%@&PWD=%@&STNO=00357028",account_temp,password_temp];
    NSLog(@"%@",urlString);
    NSURL* url = [[NSURL alloc]initWithString:urlString];
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLSession* session = [NSURLSession sharedSession];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data)
        {
            NSString* apiWeb = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSRange range = [apiWeb rangeOfString:@"name="];
            if (range.location != NSNotFound) {
                account = account_temp;
                password = password_temp;
                [self save];
            }
            else
                [self clear];
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [task resume];
    dispatch_wait(semaphore, DISPATCH_TIME_FOREVER);
}

-(void)logout {
    [self clear];
    [self remove];
}

#pragma mark - low layer

-(void)load {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    account = [defaults objectForKey:@"AcademicInformation_account"];
    password = [defaults objectForKey:@"AcademicInformation_password"];
}

-(void)save {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:account forKey:@"AcademicInformation_account"];
    [defaults setObject:password forKey:@"AcademicInformation_password"];
}

-(void)clear {
    account = nil;
    password = nil;
}

-(void)remove {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"AcademicInformation_account"];
    [defaults removeObjectForKey:@"AcademicInformation_password"];
}

@end
