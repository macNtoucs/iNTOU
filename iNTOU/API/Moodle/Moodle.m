//
//  Moodle.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/26.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "Moodle.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation Moodle
@synthesize account,password,token;

static Moodle* globalPointer = nil;

+(Moodle*)sharedInstance {
    static Moodle *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [Moodle new];
        [sharedInstance load];
    });

    return sharedInstance;
}

-(id) sendToAPIType:(NSString*)type andDictionary:(NSDictionary*)dictionary {
    //通用的送出資料函式
    NSString* urlString = [[NSString alloc]initWithFormat:@"http://140.121.100.103:8080/iNTOU/%@",type];
    NSURL* url = [[NSURL alloc]initWithString:urlString];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [[NSString alloc] initWithFormat:@"json=%@",[[NSString alloc] initWithData: [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil] encoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    id __block returnValue = NULL;
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(data) {
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            returnValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }
        
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

-(NSDictionary*) loginAccount:(NSString*)account_temp AndPassword:(NSString*)password_temp {
    NSString* account_encrypted;
    NSString* password_encrypted;
    NSString* DESKey_string;
    
    do {
        long long unsigned a = rand()%10000+10000;
        long long unsigned b = rand()%10000+10000;
        long long unsigned msec = ( a * b ) + 1430000000000;
        long long unsigned DESKey = msec%100000000;
        DESKey_string = [NSString stringWithFormat:@"%lld",DESKey];
        
        account_encrypted = [self DESencrypt:account_temp Key:DESKey_string];
        password_encrypted = [self DESencrypt:password_temp Key:DESKey_string];
    }
    while ([self checkIsStringIncludePulseSymbol:account_encrypted] || [self checkIsStringIncludePulseSymbol:password_encrypted]);
    
    
    NSDictionary* dictionary = @{@"username":account_encrypted,@"password":password_encrypted,@"now":DESKey_string};
    
    NSDictionary* result;
    result = [self sendToAPIType:@"login.do" andDictionary:dictionary];
    
    if(result) {
        if([result[@"result"] intValue] == 1 ) {
            account = account_temp;
            password = password_temp;
            token = result[@"token"];
            [self save];
        }
        else {
            NSLog(@"\n%@\n%@",account_temp,password_temp);
            NSLog(@"\n%@\n%@",account_encrypted,password_encrypted);
        }
    }
    return result;
}

-(NSDictionary*)getCourse {
    NSDictionary* dictionary = @{@"stid":token};
    NSDictionary* result = [self sendToAPIType:@"getCourse.do" andDictionary:dictionary];
    
    return result;
}

-(NSDictionary*)getCourseInfoWithCosid:(NSString*)cosid Clsid:(NSString*)clsid {
    NSDictionary* dictionary = @{@"stid":token,@"cosid":cosid,@"clsid":clsid};
    NSDictionary* result = [self sendToAPIType:@"CourseInfo.do" andDictionary:dictionary];
    
    return result;
}

-(NSDictionary*)getMoodleInfoWithClosid:(NSString*)cosid Clsid:(NSString*)clsid {
    NSDictionary* dictionary = @{@"stid":token,@"list":@[@{@"cosid":cosid,@"clsid":clsid}]};
    NSDictionary* result = [self sendToAPIType:@"getMoodleInfo.do" andDictionary:dictionary];
    
    return result;
}

-(NSDictionary*)getgetGradeWithClosid:(NSString*)cosid Clsid:(NSString*)clsid {
    NSDictionary* dictionary = @{@"stid":token,@"cosid":cosid,@"clsid":clsid};
    NSDictionary* result = [self sendToAPIType:@"getGrade.do" andDictionary:dictionary];
    
    return result;
}

-(NSDictionary*)MoodleInfoWithModule:(NSString*)module Mid:(NSString*)mid Closid:(NSString*)cosid Clsid:(NSString*)clsid {
    NSDictionary* dictionary = @{@"stid":token,@"module":module,@"mid":mid,@"cosid":cosid,@"clsid":clsid};
    NSDictionary* result = [self sendToAPIType:@"MoodleInfo.do" andDictionary:dictionary];
    
    return result;
}

-(NSDictionary*)getMoodleIDWithClosid:(NSString*)cosid Clsid:(NSString*)clsid {
    NSDictionary* dictionary = @{@"stid":token,@"cosid":cosid,@"clsid":clsid};
    NSDictionary* result = [self sendToAPIType:@"getMoodleID.do" andDictionary:dictionary];
    
    return result;
}

+(NSArray*)getDirWithMoodleId:(NSString*)moodleId Type:(NSString*)type {
    NSString* urlString = @"http://moodle.ntou.edu.tw/m/filestring.php";
    NSURL* url = [[NSURL alloc]initWithString:urlString];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [[NSString alloc] initWithFormat:@"dir=/%@/%@",moodleId,type];
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSArray* __block result;
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(data) {
            NSScanner* newScanner = [NSScanner scannerWithString:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
            NSString *bodyText;
            while (![newScanner isAtEnd]) {
                [newScanner scanUpToString:@"<body>" intoString:NULL];
                [newScanner scanString:@"<body>" intoString:NULL];
                [newScanner scanUpToString:@"</body>" intoString:&bodyText];
            }
            bodyText = [bodyText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                NSMutableArray* resultTemp = [[NSMutableArray alloc]initWithArray:[bodyText componentsSeparatedByString: @";"]];
                [resultTemp removeLastObject];
                result = [resultTemp copy];
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return result;
}


-(void)logout {
    [self clear];
    [self remove];
}

#pragma mark - low layer

-(void)load {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    account = [defaults objectForKey:@"Moodle_account"];
    password = [defaults objectForKey:@"Moodle_password"];
    token = [defaults objectForKey:@"Moodle_token"];
}

-(void)save {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:account forKey:@"Moodle_account"];
    [defaults setObject:password forKey:@"Moodle_password"];
    [defaults setObject:token forKey:@"Moodle_token"];
}

-(void)clear {
    account = nil;
    password = nil;
    token = nil;
}

-(void)remove {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"Moodle_account"];
    [defaults removeObjectForKey:@"Moodle_password"];
    [defaults removeObjectForKey:@"Moodle_token"];
}

-(Boolean)checkIsStringIncludePulseSymbol:(NSString*)string {
    NSString * plusSymbol = @"+";
    NSRange range = [string rangeOfString:plusSymbol];
    if(range.location != NSNotFound)
        return true;
    else
        return false;
}

-(NSString*)DESencrypt:(NSString*)PlainText Key:(NSString*)key {
    //DES加密
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    Byte iv[] = {1,2,3,4,5,6,7,8};
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [PlainText UTF8String], [PlainText length],
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        return [[NSString alloc] initWithData:[data base64EncodedDataWithOptions:0] encoding:NSUTF8StringEncoding];
    }
    return nil;
}


@end
