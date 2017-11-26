//
//  JCaudioQueue.h
//  JCsip
//
//  Created by Jheng-Chi on 2017/11/2.
//  Copyright © 2017年 Jheng-Chi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioQueue.h>

#define NUM_buffer 3

@interface JCaudioQueue : NSObject {
    AudioQueueRef queue;
    
}

-(void)addBuffer:(char*)audioData;
-(void)audioQueueStart;
-(void)audioQueueStop;

@end
