//
//  JCG729.h
//  JCsip
//
//  Created by Jheng-Chi on 2017/11/2.
//  Copyright © 2017年 Jheng-Chi. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "typedef.h"
#include "basic_op.h"
#include "ld8k.h"

@interface JCG729 : NSObject {
    Word16  synth_buf[L_FRAME+M], *synth; /* Synthesis                   */
    Word16  parm[PRM_SIZE+1];             /* Synthesis parameters        */
    Word16  serial[SERIAL_SIZE];          /* Serial stream               */
    Word16  Az_dec[MP1*2], *ptr_Az;       /* Decoded Az for post-filter  */
    Word16  T0_first;                     /* Pitch lag in 1st subframe   */
    Word16  pst_out[L_FRAME];             /* Postfilter output           */
    
    Word16  voicing;                      /* voicing from previous frame */
    Word16  sf_voic;                      /* voicing for subframe        */
    
    Word16 prm[PRM_SIZE];          /* Analysis parameters.                  */
    Word16 serial_o[SERIAL_SIZE];  /* Output bitstream buffer               */
    Word16 syn[L_FRAME];           /* Buffer for synthesis speech           */
}

-(void)decoderWith:(const char*)code Out:(char*)decode; //input 10 byte output 160 byte (pcm 8000hz mono 16bits)
-(void)encoderWith:(const char*)code Out:(char*)encode; //input 160 byte output 10 byte (pcm 8000hz mono 16bits)

@end
