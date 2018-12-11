//
//  JCsocket.h
//  JCsip
//
//  Created by Jheng-Chi on 2017/10/27.
//  Copyright © 2017年 Jheng-Chi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JCsocket;
@protocol JCsocketDelegate

-(void)didReceiveData:(const void *)data From:(JCsocket*)socket;

@end

@interface JCsocket : NSObject

+ (JCsocket*)initWithIP:(NSString*)ip AndPort:(int)port;

-(void)sendString:(NSString*)string;
-(void)sendData:(NSData*)data;
@property (strong,nonatomic)id<JCsocketDelegate> delegate;
@property (nonatomic)CFSocketRef myUDP;
@property (nonatomic)CFDataRef addr;

@end


