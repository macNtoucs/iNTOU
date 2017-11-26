//
//  JCsipAccount.h
//  JCsip
//
//  Created by Jheng-Chi on 2017/11/2.
//  Copyright © 2017年 Jheng-Chi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCsipAccount : NSObject {
    long long int tag;
    NSString* response;
    int port;
    int CSeq;
    NSString* ip;
}

-(NSString*)getRegisterString;
-(NSString*)getInviteString;
-(NSString*)getInviteACKString;
-(NSString*)getByeString;
-(NSString*)getInfo:(NSString*)dtmf;

@property(strong,nonatomic)NSString* account;
@property(strong,nonatomic)NSString* nonce;
@property(strong,nonatomic)NSString* ntouTag;

@end
