//
//  JCaudioRecoder.h
//  JCsip
//
//  Created by Jheng-Chi on 2017/11/10.
//  Copyright © 2017年 Jheng-Chi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioQueue.h>

@protocol JCRecoderDelegate

-(void)didReceivePCMcode:(const char*)data TimeStamp:(int)timeStamp;

@end

@interface JCaudioRecoder : NSObject {
    AudioQueueRef queue;
}

-(void)audioQueueStart;
-(void)audioQueueStop;
@property (nonatomic,strong)id <JCRecoderDelegate> delegate;

@end
