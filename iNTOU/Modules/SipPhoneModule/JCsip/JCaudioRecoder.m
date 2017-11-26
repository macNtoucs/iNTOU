//
//  JCaudioRecoder.m
//  JCsip
//
//  Created by Jheng-Chi on 2017/11/10.
//  Copyright © 2017年 Jheng-Chi. All rights reserved.
//

#import "JCaudioRecoder.h"

#define NUM_CHANNELS 1
#define NUM_buffer 3
#define BUFFER_SIZE 320
#define SAMPLE_TYPE short
#define SAMPLE_RATE 8000

@implementation JCaudioRecoder
@synthesize delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        AudioStreamBasicDescription format;
        format.mSampleRate       = SAMPLE_RATE;
        format.mFormatID         = kAudioFormatLinearPCM;
        format.mFormatFlags      = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
        format.mBitsPerChannel   = 8 * sizeof(SAMPLE_TYPE);
        format.mChannelsPerFrame = NUM_CHANNELS;
        format.mBytesPerFrame    = sizeof(SAMPLE_TYPE) * NUM_CHANNELS;
        format.mFramesPerPacket  = 1;
        format.mBytesPerPacket   = format.mBytesPerFrame * format.mFramesPerPacket;
        format.mReserved         = 0;
        
        AudioQueueNewInput(&format, recoderCallBack, (__bridge void * _Nullable)(self), CFRunLoopGetCurrent(), NULL, 0, &queue);
    }
    return self;
}

-(void)dealloc {
    AudioQueueDispose(queue, YES);
}

void recoderCallBack(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime, UInt32 inNumberPacketDescriptions, const AudioStreamPacketDescription *inPacketDescs) {
    JCaudioRecoder* jcAudioRecoder = (__bridge JCaudioRecoder *)(inUserData);
    [jcAudioRecoder.delegate didReceivePCMcode:inBuffer->mAudioData TimeStamp:(int)inStartTime->mSampleTime];
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

-(void)audioQueueStart {
    for(int i = 0 ;i < NUM_buffer ; i++) {
        AudioQueueBufferRef buffer;
        AudioQueueAllocateBuffer(queue, BUFFER_SIZE, &buffer);
        buffer->mAudioDataByteSize = BUFFER_SIZE;
        AudioQueueEnqueueBuffer(queue, buffer, 0, NULL);
    }
    
    AudioQueueStart(queue, NULL);
}

-(void)audioQueueStop {
    AudioQueueStop(queue, YES);
}

@end
