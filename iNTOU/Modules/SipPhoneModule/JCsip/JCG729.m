//
//  JCG729.m
//  JCsip
//
//  Created by Jheng-Chi on 2017/11/2.
//  Copyright © 2017年 Jheng-Chi. All rights reserved.
//

#import "JCG729.h"

@implementation JCG729

extern Word16 *new_speech;

- (instancetype)init
{
    self = [super init];
    if (self) {
        /*-----------------------------------------------------------------*
         *           Initialization of decoder                             *
         *-----------------------------------------------------------------*/
        
        for (int i=0; i<M; i++) synth_buf[i] = 0;
        synth = synth_buf + M;
        
        Init_Decod_ld8k();
        Init_Post_Filter();
        Init_Post_Process();
        voicing = 60;
        
        /*--------------------------------------------------------------------------*
         * Initialization of the coder.                                             *
         *--------------------------------------------------------------------------*/
        
        Init_Pre_Process();
        Init_Coder_ld8k();
        for(int i=0; i<PRM_SIZE; i++) prm[i] = (Word16)0;
    }
    return self;
}

-(void)decoderWith:(const char *)code Out:(char *)decode {    
    jc_bin2int((char*)code, &parm[1]);
    
    /* the hardware detects frame erasures by checking if all bits
     are set to zero
     */
    parm[0] = 0;           /* No frame erasure */
    
    /* check parity and put 1 in parm[4] if parity error */
    
    parm[4] = Check_Parity_Pitch(parm[3], parm[4]);
    
    Decod_ld8k(parm, voicing, synth, Az_dec, &T0_first);
    
    /* Postfilter */
    
    voicing = 0;
    ptr_Az = Az_dec;
    for(int i=0; i<L_FRAME; i+=L_SUBFR) {
        Post(T0_first, &synth[i], ptr_Az, &pst_out[i], &sf_voic);
        if (sf_voic != 0) { voicing = sf_voic;}
        ptr_Az += MP1;
    }
    Copy(&synth_buf[L_FRAME], &synth_buf[0], M);
    
    Post_Process(pst_out, L_FRAME);

    memcpy(decode, pst_out, L_FRAME*sizeof(Word16));
    
}

-(void)encoderWith:(const char *)code Out:(char *)encode {
    memcpy(new_speech, code, sizeof(Word16)*80);
    Pre_Process(new_speech, L_FRAME);
    Coder_ld8k(prm, syn);

    memset(encode, 0, 10); //clear bits
    jc_int2bin(prm, encode);
    
}

@end
