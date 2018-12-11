//
//  JCsipAccount.m
//  JCsip
//
//  Created by Jheng-Chi on 2017/11/2.
//  Copyright © 2017年 Jheng-Chi. All rights reserved.
//

#import "JCsipAccount.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation JCsipAccount
@synthesize account,nonce,ntouTag;

- (instancetype)init
{
    self = [super init];
    if (self) {
        ip = @"192.168.0.1";
    }
    return self;
}

-(NSString*)getRegisterString {
    tag = (long long int)[[NSDate date] timeIntervalSince1970];
    
    NSMutableString* text = [NSMutableString new];
    [text appendString:@"REGISTER sip:140.121.99.170 SIP/2.0\r\n"];
    [text appendFormat:@"Via: SIP/2.0/UDP %@:8787;branch=z9hG4bK%lld\r\n",ip,tag];
    [text appendFormat:@"From: %@ <sip:%@@140.121.99.170>;tag=%lld\r\n",account,account,tag];
    [text appendFormat:@"To: %@ <sip:%@@140.121.99.170>\r\n",account,account];
    [text appendFormat:@"Contact: \"%@\" <sip:%@@%@:8787>\r\n",account,account,ip];
    [text appendFormat:@"Call-ID: 005000-%lld@%@\r\n",tag,ip];
    [text appendString:@"CSeq: 0 REGISTER\r\n"];
    [text appendString:@"Expires: 60\r\n"];
    [text appendString:@"Max-Forwards: 70\r\n"];
    [text appendString:@"Content-Length: 0\r\n\r\n"];
    
    return text;
}

-(NSString*)getInviteString {
    tag = (long long int)[[NSDate date] timeIntervalSince1970];
    NSMutableString* text = [NSMutableString new];
    NSString* ha1 = [self md5:[[NSString alloc]initWithFormat:@"%@:OTS:12345678",account]];
    NSString* ha2 = [self md5:@"INVITE:sip:1687@140.121.99.170"];
    NSString* inviteResponse = [self md5:[[NSString alloc]initWithFormat:@"%@:%@:00000001:e7fe6eia:auth:%@",ha1,nonce,ha2]];
    [text appendString:@"INVITE sip:1687@140.121.99.170;user=phone SIP/2.0\r\n"];
    [text appendFormat:@"Via: SIP/2.0/UDP %@:8787;branch=z9hG4bK%lld\r\n",ip,tag];
    [text appendFormat:@"From: %@ <sip:%@@140.121.99.170>;tag=%lld\r\n",account,account,tag];
    [text appendString:@"To: 1687 <sip:1687@140.121.99.170:5060>\r\n"];
    [text appendFormat:@"Contact: \"%@\" <sip:%@@%@:8787>\r\n",account,account,ip];
    [text appendFormat:@"Call-ID: 005000-%lld@%@\r\n",tag,ip];
    [text appendString:@"CSeq: 1 INVITE\r\n"];
    [text appendFormat:@"Authorization: Digest username=\"%@\", realm=\"OTS\", nonce=\"%@\", uri=\"sip:1687@140.121.99.170\", ",account,nonce];
    [text appendFormat:@"response=\"%@\", opaque=\"1234\", algorithm=MD5, cnonce=\"e7fe6eia\", qop=\"auth\", nc=00000001\r\n",inviteResponse];
    [text appendString:@"Max-Forwards: 70\r\n"];
    [text appendString:@"Content-Type: application/sdp\r\n"];
    [text appendString:@"Content-Length: 123\r\n\r\n"];
    
    [text appendString:@"v=0\r\n"];
    [text appendFormat:@"o=%@ 0 0 IN IP4 %@\r\n",account,ip];
    [text appendString:@"s=ots\r\n"];
    [text appendFormat:@"c=IN IP4 %@\r\n",ip];
    [text appendString:@"t=0 0\r\n"];
    [text appendString:@"m=audio 5032 RTP/AVP 18\r\n"];
    [text appendString:@"a=rtpmap:18 G729/8000/1\r\n\r\n"];
    
    return text;
}

-(NSString*)getInviteACKString {
    NSMutableString* text = [NSMutableString new];
    [text appendString:@"ACK sip:1687@140.121.99.170:5060 SIP/2.0\r\n"];
    [text appendFormat:@"Via: SIP/2.0/UDP %@:8787;branch=z9hG4bK%lld\r\n",ip,tag];
    [text appendFormat:@"From: %@ <sip:%@@140.121.99.170:5060>;tag=%lld\r\n",account,account,tag];
    [text appendFormat:@"To: 1687 <sip:1687@140.121.99.170:5060>;tag=%@\r\n",ntouTag];
    [text appendFormat:@"Contact: <sip:%@@%@:8787>\r\n",account,ip];
    [text appendFormat:@"Call-ID: 005000-%lld@%@\r\n",tag,ip];
    [text appendString:@"CSeq: 1 ACK\r\n"];
    [text appendString:@"Max-Forwards: 70\r\n"];
    [text appendString:@"Content-Type: application/sdp\r\n"];
    [text appendString:@"Content-Length: 123\r\n\r\n"];
    
    [text appendString:@"v=0\r\n"];
    [text appendFormat:@"o=%@ 0 0 IN IP4 %@\r\n",account,ip];
    [text appendString:@"s=ots\r\n"];
    [text appendFormat:@"c=IN IP4 %@\r\n",ip];
    [text appendString:@"t=0 0\r\n"];
    [text appendString:@"m=audio 5032 RTP/AVP 18\r\n"];
    [text appendString:@"a=rtpmap:18 G729/8000/1\r\n\r\n"];
    
    CSeq = 1;
    
    return text;
}

-(NSString*)getByeString {
    CSeq++;
    NSMutableString* text = [NSMutableString new];
    [text appendString:@"BYE sip:1687@140.121.99.170:5060 SIP/2.0\r\n"];
    [text appendFormat:@"Via: SIP/2.0/UDP %@:8787;branch=z9hG4bK%lld\r\n",ip,tag];
    [text appendFormat:@"From: %@ <sip:%@@140.121.99.170:5060>;tag=%lld\r\n",account,account,tag];
    [text appendFormat:@"To: 1687 <sip:1687@140.121.99.170:5060>;tag=%@\r\n",ntouTag];
    [text appendFormat:@"Contact: <sip:%@@%@:8787>\r\n",account,ip];
    [text appendFormat:@"Call-ID: 005000-%lld@%@\r\n",tag,ip];
    [text appendFormat:@"CSeq: %d BYE\r\n",CSeq];
    [text appendString:@"Max-Forwards: 70\r\n"];
    [text appendString:@"Content-Length: 0\r\n\r\n"];
    
    return text;
}

-(NSString*)getByeACK:(int)seq {
    NSMutableString* text = [NSMutableString new];
    [text appendString:@"SIP/2.0 200 OK\r\n"];
    [text appendFormat:@"Via: SIP/2.0/UDP %@:8787;branch=z9hG4bK%lld\r\n",ip,tag];
    [text appendFormat:@"From: %@ <sip:%@@140.121.99.170:5060>;tag=%lld\r\n",account,account,tag];
    [text appendFormat:@"To: 1687 <sip:1687@140.121.99.170:5060>;tag=%@\r\n",ntouTag];
    [text appendFormat:@"Contact: <sip:%@@%@:8787>\r\n",account,ip];
    [text appendFormat:@"Call-ID: 005000-%lld@%@\r\n",tag,ip];
    [text appendFormat:@"CSeq: %d BYE\r\n",seq];
    [text appendString:@"Max-Forwards: 68\r\n"];
    [text appendString:@"Content-Length: 0\r\n\r\n"];
    
    return text;
}

-(NSString*)getInfo:(NSString *)dtmf {
    CSeq++;
    NSMutableString* text = [NSMutableString new];
    [text appendString:@"INFO sip:1687@140.121.99.170:5060 SIP/2.0\r\n"];
    [text appendFormat:@"Via: SIP/2.0/UDP %@:8787;branch=z9hG4bK%lld\r\n",ip,tag];
    [text appendFormat:@"From: %@ <sip:%@@140.121.99.170:5060>;tag=%lld\r\n",account,account,tag];
    [text appendFormat:@"To: 1687 <sip:1687@140.121.99.170:5060>;tag=%@\r\n",ntouTag];
    [text appendFormat:@"Contact: <sip:%@@%@:8787>\r\n",account,ip];
    [text appendFormat:@"Call-ID: 005000-%lld@%@\r\n",tag,ip];
    [text appendFormat:@"CSeq: %d INFO\r\n",CSeq];
    [text appendString:@"Max-Forwards: 70\r\n"];
    [text appendString:@"Content-Type: application/dtmf-relay\r\n"];
    [text appendString:@"Content-Length: 24\r\n\r\n"];
    
    [text appendFormat:@"Signal=%@\r\n",dtmf];
    [text appendString:@"Duration=0\r\n\r\n"];
    
    return text;
}

#pragma mark - tools

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


@end
