//
//  Module.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "Module.h"

@implementation Module

@synthesize displayName,moduleName,viewController;

-(instancetype)init{
    self = [super init];
    
    if(self){
        
    }
    
    return self;
}

-(instancetype)setDisplayName:(NSString*)displayName AndModuleName:(NSString*)moduleName {
    self.displayName = displayName;
    self.moduleName = moduleName;
    
    return self;
}

-(UIViewController*)getViewController {
    //讀取自己的story board，並保留在記憶體中，重複讀取時會拿出記憶體內的那份
    //可以繼承類別並override這方法來客製化
    
    if(!viewController)
        viewController = [[UIStoryboard storyboardWithName:moduleName bundle:nil] instantiateInitialViewController];
    
    return viewController;
}

-(void)clearViewController {
    viewController = nil;
}

@end
