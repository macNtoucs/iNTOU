//
//  JCsocket.m
//  JCsip
//
//  Created by Jheng-Chi on 2017/10/27.
//  Copyright © 2017年 Jheng-Chi. All rights reserved.
//

#import "JCsocket.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

void receiveSocket(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info);

@implementation JCsocket
@synthesize delegate,myUDP,addr;

+ (JCsocket*)initWithIP:(NSString*)ip AndPort:(int)port {
    JCsocket* jcSocket = [JCsocket new];
    CFSocketContext context = {0,(__bridge void *)(jcSocket),NULL,NULL,NULL};
    
    jcSocket.myUDP = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_DGRAM, IPPROTO_UDP, kCFSocketDataCallBack | kCFSocketConnectCallBack | kCFSocketWriteCallBack, receiveSocket, &context);
    
    struct sockaddr_in ipAddress;
    ipAddress.sin_len = sizeof(ipAddress);
    ipAddress.sin_family = AF_INET;
    ipAddress.sin_port = htons(port);
    inet_pton(AF_INET, [ip UTF8String], &ipAddress.sin_addr);
    
    jcSocket.addr = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&ipAddress, sizeof(ipAddress));
    
    if(CFSocketIsValid(jcSocket.myUDP))
    {
        CFRunLoopSourceRef socketsource = CFSocketCreateRunLoopSource(kCFAllocatorDefault,jcSocket.myUDP,0);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), socketsource, kCFRunLoopCommonModes);
    }
    
    return jcSocket;
}

-(void)dealloc {
    CFSocketInvalidate(myUDP);
}

-(void)sendString:(NSString *)string {
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    CFDataRef data_cf = CFDataCreate(kCFAllocatorDefault, [data bytes], [data length]);
    CFSocketSendData(myUDP,addr,data_cf,10);
    CFRelease(data_cf);
}

-(void)sendData:(NSData *)data{
    CFDataRef data_cf = CFDataCreate(kCFAllocatorDefault, [data bytes], [data length]);
    CFSocketSendData(myUDP,addr,data_cf,10);
    CFRelease(data_cf);
}

@end

void receiveSocket(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
    if(type == kCFSocketDataCallBack) {
        JCsocket* jcSocket = (__bridge JCsocket *)info;
        if(data)
            [jcSocket.delegate didReceiveData:data From:jcSocket];
    }
}
