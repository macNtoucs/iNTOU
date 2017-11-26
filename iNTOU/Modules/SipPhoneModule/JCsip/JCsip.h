//
//  JCsip.h
//  JCsip
//
//  Created by Jheng-Chi on 2017/10/26.
//  Copyright © 2017年 Jheng-Chi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCsocket.h"
#import "JCsipAccount.h"
#import "JCaudioQueue.h"
#import "JCG729.h"
#import "JCaudioRecoder.h"


enum JCSipConditionCode {
    JCSipConditionWaiting, //閒置
    JCSipConditionCalling, //撥號
    JCSipConditionSessionWork, //通話
    JCSipConditionAllAccountBusy //server壅塞
};

@protocol JCSipDelegate

-(void)changeStatue:(enum JCSipConditionCode)code; //通知狀態改變

@end

@interface JCsip : NSObject <JCsocketDelegate,JCRecoderDelegate>{
    JCsocket* jcSocket;
    JCsocket* rtpSocket;
    JCsipAccount* jcSipAccount;
    JCG729* jcG729;
    JCaudioQueue* jcAudioQueue;
    JCaudioRecoder* jcAudioRecoder;
    int port; //學校server 開啟的port
    unsigned short seq; //封包序號
    int SSRC; // rtp內的識別碼
    
    dispatch_queue_t udp_rtp_in_queue; //輸入的線程
    dispatch_queue_t udp_rtp_out_queue; //輸出的線程
    CFRunLoopRef udp_rtp_in_queue_runLoopRef; //輸入的線程runloop
    CFRunLoopRef udp_rtp_out_queue_runLoopRef; //輸出的線程runloop
}

-(void)registerNtou;
-(void)hangup;
-(void)sendDtmf:(NSString*)dtmf;

@property(strong,nonatomic)id<JCSipDelegate> delegate;

@end
