//
//  ModuleManager.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Module.h"

@interface ModuleManager : NSObject

@property (nonatomic,strong)NSArray* modulesArray;


//------方便讀取的方法--------
-(Module*)moduleAtIndexPath:(NSIndexPath*)indexPath;
-(NSString*)displayNameAtIndexPath:(NSIndexPath*)indexPath;
-(NSString*)moduleNameAtIndexPath:(NSIndexPath*)indexPath;

@end
