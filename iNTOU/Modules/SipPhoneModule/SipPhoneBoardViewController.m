//
//  SipPhoneBoardViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/5/1.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "SipPhoneBoardViewController.h"

@interface SipPhoneBoardViewController ()

@end

@implementation SipPhoneBoardViewController

//為了在c function內能call objc function 需要一個類似於self的指標
id thisObj;

static char* diagBoard;

-(instancetype)initWithCoder:(NSCoder *)c {
    self = [super initWithCoder:c];
    if(self) {
        if(!diagBoard)
            diagBoard = "123456789*0#";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    thisObj = self;
    m_current_call = PJSUA_INVALID_ID;
    
    for(int i=0;i<12;i++)
        [((UIButton*)[self.view viewWithTag:101 + i]) addTarget:self action:@selector(pressedBoardButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self pjsuaStart];
    [self addNTOUAccount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pressedBoardButton:(UIButton*)sender {
    [self sendDtmf:diagBoard[sender.tag - 101] toCurrent_call:m_current_call];
}

#pragma mark - pjsip

- (void)pjsuaStart{
    pj_status_t status;
    
    status = pjsua_create(); // create pjsua
    
    pjsua_config ua_cfg; //setup config default
    pjsua_config_default(&ua_cfg);
    pjsua_logging_config log_cfg;
    pjsua_logging_config_default(&log_cfg);
    pjsua_media_config media_cfg;
    pjsua_media_config_default(&media_cfg);
    
    ua_cfg.cb.on_call_media_state = &on_call_media_state; //connect function
    ua_cfg.cb.on_stream_destroyed = &on_stream_destroyed;
    
    status = pjsua_init(&ua_cfg,&log_cfg,&media_cfg); //after setting config ,init it
    
    pjsua_transport_config transport_config; //set udp
    pjsua_transport_config_default(&transport_config);
    transport_config.port = 44987;
    status = pjsua_transport_create(PJSIP_TRANSPORT_UDP,&transport_config,NULL);
    
    pjsua_transport_config_default(&transport_config);
    
    status = pjsua_start(); //start pjsua
    
    pjmedia_codec_g722_deinit();  //deinit for NTOU server , or it would be lag or disconnecting for calling to NTOU, only use PCMU codec
    pjmedia_codec_ilbc_deinit();
    pjmedia_codec_speex_deinit();
    pjmedia_codec_gsm_deinit();
    
}

-(void)sendDtmf:(char)dtmf toCurrent_call:(int)current_call {
    if(m_current_call != PJSUA_INVALID_ID) {
        char dtmf_string[2];
        dtmf_string[0] = dtmf;
        dtmf_string[1] = '\0';
        pj_str_t diag = pj_str(dtmf_string);
        pj_status_t dtmfStatus = pjsua_call_dial_dtmf(current_call,&diag);
        if(dtmfStatus == PJ_SUCCESS)
        {
            [sendDtmfString appendString:[NSString stringWithFormat:@"%c" , dtmf]];
            self.statusLabel.text = [sendDtmfString copy];
        }
        else
        {
            self.statusLabel.text = @"傳送分機號碼失敗！";

        }
    }
}

-(void)addNTOUAccount {
    pjsua_acc_config acc;
    
    pjsua_acc_config_default(&acc);
    acc.id = pj_str("<sip:601@140.121.99.170>");
    acc.reg_uri = pj_str("sip:140.121.99.170");
    acc.cred_count = 1;
    acc.cred_info[0].realm = pj_str("*");
    acc.cred_info[0].scheme = pj_str("digest");
    acc.cred_info[0].username = pj_str("602");
    acc.cred_info[0].data_type = 0;
    acc.cred_info[0].data = pj_str("12345678");
    
    pjsua_acc_add(&acc, PJ_TRUE, &m_acc_id);
    
}

-(IBAction)callToNtou {
    if(pjsua_acc_is_valid(m_acc_id))
    {
        if(m_current_call == PJSUA_INVALID_ID) {
            pj_str_t NtouUri = pj_str("sip:16877@140.121.99.170"); //海大server
            
            pj_status_t callStatus = pjsua_call_make_call(m_acc_id,&NtouUri,0,0,0,&m_current_call);
            
            if(callStatus == PJ_SUCCESS)
            {
                self.statusLabel.text = @"輸入分機號碼";
                
                sendDtmfString = [NSMutableString new];
                
                pjsua_call_info ci;
                pjsua_call_get_info(m_current_call, &ci);
            }
            else
            {
                self.statusLabel.text = @"無法成功撥打！";
            }
        }
    }
}

-(IBAction)hangup {
    pjsua_call_hangup_all();
    m_current_call = PJSUA_INVALID_ID;
    
    self.statusLabel.text = @"請先點選撥打撥號至海洋大學";
}



void on_call_media_state(pjsua_call_id call_id) // a special c-function called by pjsua, go to pjsip Documentations see more function like this
{
    pjsua_call_info ci;
    pjsua_call_get_info(call_id, &ci);
    
    if (ci.media_status == PJSUA_CALL_MEDIA_ACTIVE) { // when answering the phone,open sound outbound
        pjsua_conf_connect(ci.conf_slot, 0);
        pjsua_conf_connect(0, ci.conf_slot);
    }
    
}

void on_stream_destroyed(pjsua_call_id call_id, pjmedia_stream *strm, unsigned stream_idx)
{
    [thisObj hangup];
}

@end
