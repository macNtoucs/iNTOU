//
//  NewsClassData.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsClassData : NSObject <NSXMLParserDelegate> {
    NSMutableArray* dataTemp;
    NSMutableDictionary* dataElemetTemp;
    NSMutableString* parseStringTemp;
}

@property (strong,nonatomic)NSString* classType;
@property (atomic)Boolean threadLock;
@property (strong,nonatomic)NSArray* classData;
@property (atomic)int MaxPage;
@property (strong,nonatomic)NSString* status;

-(void)downloadDataFromServer:(int)page;
-(BOOL)parse:(NSData*)nsData;

@end
