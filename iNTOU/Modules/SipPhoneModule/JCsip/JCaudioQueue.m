//
//  JCaudioQueue.m
//  JCsip
//
//  Created by Jheng-Chi on 2017/11/2.
//  Copyright © 2017年 Jheng-Chi. All rights reserved.
//

#import "JCaudioQueue.h"

#define NUM_CHANNELS 1
#define SAMPLE_TYPE short
#define SAMPLE_RATE 8000
#define BUFFER_SIZE 320

struct jcMemoryQueue {
    char data[BUFFER_SIZE];
    struct jcMemoryQueue* next;
};

struct jcMemoryQueue* start;
struct jcMemoryQueue* end;

@implementation JCaudioQueue

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
        
        AudioQueueNewOutput(&format, queueCallBack, NULL,CFRunLoopGetCurrent() , NULL, 0, &queue);
    }
    return self;
}

-(void)dealloc {
    AudioQueueDispose(queue, YES);
    
    while (start) {
        struct jcMemoryQueue* detemp = start;
        free(detemp);
        start = start->next;
    }
    
    start = end = NULL;
}

void queueCallBack(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer) {
    memset(inBuffer->mAudioData, 0, inBuffer->mAudioDataByteSize);
    
    if(start) {
        memcpy(inBuffer->mAudioData, start->data, BUFFER_SIZE);
        struct jcMemoryQueue* detemp = start;
        start = start->next;
        if(!start)
            end = start;
        free(detemp);
    }
    
    AudioQueueEnqueueBuffer(inAQ,inBuffer,0,NULL);
}

-(void)addBuffer:(char *)audioData {
    struct jcMemoryQueue* temp;
    temp = malloc(sizeof(struct jcMemoryQueue));
    memcpy(temp->data, audioData, BUFFER_SIZE);
    temp->next = NULL;
    
    if(end) {
        end->next = temp;
        end = temp;
    }
    else
        start = end = temp;
}

-(void)audioQueueStart {
    for(int i = 0 ;i < NUM_buffer ; i++) {
        AudioQueueBufferRef buffer;
        AudioQueueAllocateBuffer(queue, BUFFER_SIZE, &buffer);
        buffer->mAudioDataByteSize = BUFFER_SIZE;
        memset(buffer->mAudioData,0,buffer->mAudioDataByteSize);
        AudioQueueEnqueueBuffer(queue, buffer, 0, NULL);
    }
    
    AudioQueueStart(queue, NULL);
}

-(void)audioQueueStop {
    AudioQueueStop(queue, YES);
}
@end
