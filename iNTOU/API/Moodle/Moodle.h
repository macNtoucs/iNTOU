//
//  Moodle.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/26.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Moodle : NSObject

@property (nonatomic,strong)NSString* account;
@property (nonatomic,strong)NSString* password;
@property (nonatomic,strong)NSString* token;


+(Moodle*)sharedInstance;
-(Boolean)checkLogin;
-(NSDictionary*)loginAccount:(NSString*)account_temp AndPassword:(NSString*)password_temp;
-(void)logout;
-(NSDictionary*)getCourse;
-(NSDictionary*)getCourseInfoWithCosid:(NSString*)cosid Clsid:(NSString*)clsid;
-(NSDictionary*)getMoodleInfoWithClosid:(NSString*)cosid Clsid:(NSString*)clsid;
-(NSDictionary*)getgetGradeWithClosid:(NSString*)cosid Clsid:(NSString*)clsid;
-(NSDictionary*)MoodleInfoWithModule:(NSString*)module Mid:(NSString*)mid Closid:(NSString*)cosid Clsid:(NSString*)clsid;
-(NSDictionary*)getMoodleIDWithClosid:(NSString*)cosid Clsid:(NSString*)clsid;
+(NSArray*)getDirWithMoodleId:(NSString*)moodleId Type:(NSString*)type;
@end
