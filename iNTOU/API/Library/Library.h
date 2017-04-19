//
//  Library.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/26.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Library : NSObject

@property (nonatomic,strong)NSString* account;
@property (nonatomic,strong)NSString* password;

+(Library*)sharedInstance;
-(Boolean)checkLogin;
-(void)loginAccount:(NSString*)account_temp AndPassword:(NSString*)password_temp;
-(void)logout;
-(NSArray*)getReadingHistory:(int)segment;
//-(NSDictionary*)reserveBook;
-(NSArray*)getCurrentHolds;
//-(Boolean)cancelReserveBook:(NSString*)radioValue;
-(NSArray*)getCurrentBorrowedBooks;
//-(NSDictionary*)renewBook:(NSString*)radioValue;

@end
