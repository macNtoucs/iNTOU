//
//  AcademicInformation.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/10/18.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AcademicInformation : NSObject

@property (nonatomic,strong)NSString* account;
@property (nonatomic,strong)NSString* password;

+(AcademicInformation*)sharedInstance;
-(Boolean)checkLogin;
-(void)loginAccount:(NSString*)account_temp AndPassword:(NSString*)password_temp;
-(void)logout;

@end
