//
//  JCsip.m
//  JCsip
//
//  Created by Jheng-Chi on 2017/10/26.
//  Copyright © 2017年 Jheng-Chi. All rights reserved.
//

#import "JCsip.h"

#define udp_timeout_second 1

@implementation JCsip
@synthesize delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        jcSipAccount = [JCsipAccount new];
        jcSipAccount.account = @"601";
        
        jcSocket = [JCsocket initWithIP:@"140.121.99.170" AndPort:5060];
        jcSocket.delegate = self;
        
        jcG729 = [JCG729 new];
        
        udp_rtp_in_queue = dispatch_queue_create("udp_rtp_in_queue", NULL);
        udp_rtp_out_queue = dispatch_queue_create("udp_rtp_out_queue", NULL);
    }
    return self;
}

//add timeout in the function
-(void)jcsocket_sendString:(NSString*)string {
    timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerFireMethod:) userInfo:string repeats:YES];
    if(timeoutTimer) {
        timeoutTimes = 0;
        [[NSRunLoop currentRunLoop] addTimer:timeoutTimer forMode:NSDefaultRunLoopMode];
        [timeoutTimer fire];
    }
    else {
        [jcSocket sendString:string];
    }
}

- (void)timerFireMethod:(NSTimer *)timer {
    [jcSocket sendString:timer.userInfo];
    timeoutTimes++;
    if(timeoutTimes >= 10)
        [timer invalidate];
}

-(void)registerNtou {
    [delegate changeStatue:JCSipConditionCalling];
    [self jcsocket_sendString:[jcSipAccount getRegisterString]];
}

-(void)makeACall {
    [self jcsocket_sendString:[jcSipAccount getInviteString]];
}

-(void)makeACallACK {
    [jcSocket sendString:[jcSipAccount getInviteACKString]];

    seq = 0;
    SSRC = arc4random_uniform(2147483647);
    
    dispatch_async(udp_rtp_in_queue, ^{
        rtpSocket = [JCsocket initWithIP:@"140.121.99.170" AndPort:port];
        rtpSocket.delegate = self;
        jcAudioQueue = [JCaudioQueue new];
        [jcAudioQueue audioQueueStart];
        udp_rtp_in_queue_runLoopRef = CFRunLoopGetCurrent();
        CFRunLoopRun();
    });
    
    dispatch_async(udp_rtp_out_queue, ^{
        jcAudioRecoder = [JCaudioRecoder new];
        jcAudioRecoder.delegate = self;
        [jcAudioRecoder audioQueueStart];
        udp_rtp_out_queue_runLoopRef = CFRunLoopGetCurrent();
        CFRunLoopRun();
    });
    [delegate changeStatue:JCSipConditionSessionWork];
}

-(void)sendDtmf:(NSString*)dtmf {
     [self jcsocket_sendString:[jcSipAccount getInfo:dtmf]];
}

-(void)hangup {
    [self disableAudio];
    [self jcsocket_sendString:[jcSipAccount getByeString]];
    [delegate changeStatue:JCSipConditionWaiting];
}

-(void)disableAudio {
    CFRunLoopStop(udp_rtp_out_queue_runLoopRef);
    dispatch_async(udp_rtp_out_queue, ^{
        [jcAudioRecoder audioQueueStop];
        jcAudioRecoder = nil;
    });
    
    CFRunLoopStop(udp_rtp_in_queue_runLoopRef);
    dispatch_async(udp_rtp_in_queue, ^{
        rtpSocket = nil;
        [jcAudioQueue audioQueueStop];
        jcAudioQueue = nil;
    });
}

-(void)getAuthentication:(NSString*)text {
    NSRange range = [text rangeOfString:@"nonce=\""];
    if(range.location != NSNotFound) {
        range.location += 7;
        range.length = text.length - range.location;
        NSRange range2 = [text rangeOfString:@"\"" options:0 range:range];
        jcSipAccount.nonce = [text substringWithRange:NSMakeRange(range.location, range2.location - range.location)];
    }
}

#pragma - mark JCsocket

-(void)didReceiveData:(const void *)data From:(JCsocket *)socket {
    NSData* data1 = (__bridge NSData*) data;
    if(socket == jcSocket)
    {
        if(timeoutTimer)
            [timeoutTimer invalidate];
        NSString* string = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
        NSLog(@"%@",string);
        int conditionCode = 0;
        if(string.length > 11)
            conditionCode = [[string substringWithRange:NSMakeRange(8, 3)] intValue];
        NSRange range;
        switch (conditionCode) {
            case 200:
                //找出封包內m=audio後 學校開啟的port
                range = [string rangeOfString:@"m=audio "];
                if(range.location != NSNotFound)
                {
                    range = [string rangeOfString:@"To"];
                    range.length = string.length - range.location;
                    range = [string rangeOfString:@"tag=" options:0 range:range];
                    range.location += 4;
                    range.length = string.length - range.location;
                    NSRange range2 = [string rangeOfString:@"\r" options:0 range:range];
                    jcSipAccount.ntouTag = [string substringWithRange:NSMakeRange(range.location, range2.location - range.location)];
                    range = [string rangeOfString:@"m=audio "];
                    range.location += 8;
                    range.length = string.length - range.location;
                    range2 = [string rangeOfString:@" " options:0 range:range];
                    port = [[string substringWithRange:NSMakeRange(range.location, range2.location - range.location)] intValue];
                    [self makeACallACK];
                }
                break;
            case 407:
                //認證失敗
                [self getAuthentication:string];
                [self makeACall];
                break;
            case 404:
                if([jcSipAccount.account intValue] < 605) {
                    jcSipAccount.account = [[NSString alloc]initWithFormat:@"%d",[jcSipAccount.account intValue] + 1];
                    [self registerNtou];
                }
                else
                    NSLog(@"All account busy");
                break;
            default:
                break;
        }
        
        if(string.length > 3) // get bye
        {
            NSString* bye = [string substringToIndex:3];
            if([bye isEqualToString:@"BYE"])
            {
                [self disableAudio];
                [delegate changeStatue:JCSipConditionWaiting];
                range = [string rangeOfString:@"CSeq: "];
                NSString* string2 = [string substringFromIndex:range.location+6];
                range = [string2 rangeOfString:@" "];
                string2 = [string2 substringToIndex:range.location];
                int seq = [string2 intValue];
                [self jcsocket_sendString:[jcSipAccount getByeACK:seq]];
            }
        }
    }
    else if (socket == rtpSocket) {
        const char* source;
        source = [data1 bytes];
        char code[20];
        char decode[320];
    
        memcpy(code, &(source[12]), 20);
        [jcG729 decoderWith:code Out:decode];
        [jcG729 decoderWith:&code[10] Out:&decode[160]];
    
        [jcAudioQueue addBuffer:decode];
    }
    
}

#pragma - mark JCaudioRecoder

-(void)didReceivePCMcode:(const char *)data TimeStamp:(int)timeStamp {
    char g729_code[20];

    [jcG729 encoderWith:data Out:g729_code];
    [jcG729 encoderWith:&data[160] Out:&g729_code[10]];

    unsigned char a[32];
    a[0] = 0x80;a[1] = 0x12;a[2] = ((char*)&seq)[1];a[3] = ((char*)&seq)[0];
    a[4] = ((char*)&timeStamp)[3];a[5] = ((char*)&timeStamp)[2];a[6] = ((char*)&timeStamp)[1];a[7] = ((char*)&timeStamp)[0];
    a[8] = ((char*)&SSRC)[3];a[9] = ((char*)&SSRC)[2];a[10] = ((char*)&SSRC)[1];a[11] = ((char*)&SSRC)[0];
    for(int i = 12 ; i < 32 ; i ++)
        a[i] = g729_code[i - 12];
    [rtpSocket sendData:[NSData dataWithBytes:a length:32]];
    seq++;
}

@end
