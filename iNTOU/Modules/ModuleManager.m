//
//  ModuleManager.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "ModuleManager.h"
#import <UIKit/UIKit.h>
#import "TronClassModule.h"

@implementation ModuleManager
@synthesize modulesArray;

-(instancetype)init {
    self = [super init];
    
    if(self) {
        
        NSMutableArray* modulesArrayTemp = [NSMutableArray new];
        
        //-------------在這下方加入新的module------------------
        //需要有對應moduleName的storyboard 不然會出錯
        //icon 為 Assets.xcassets 內同名的檔案
        [modulesArrayTemp addObject:[[Module new] setDisplayName:@"最新消息" AndModuleName:@"NewsModule" AndReuse:true]];
        [modulesArrayTemp addObject:[[Module new] setDisplayName:@"校園導覽" AndModuleName:@"GuideModule" AndReuse:true]];
        [modulesArrayTemp addObject:[[Module new] setDisplayName:@"交通資訊" AndModuleName:@"TrafficModule" AndReuse:true]];
        [modulesArrayTemp addObject:[[Module new] setDisplayName:@"生活圈" AndModuleName:@"LifeModule" AndReuse:true]];
        [modulesArrayTemp addObject:[[Module new] setDisplayName:@"個人課程" AndModuleName:@"StellarModule" AndReuse:true]];
        [modulesArrayTemp addObject:[[Module new] setDisplayName:@"導生系統" AndModuleName:@"TeacherAndStudentModule" AndReuse:true]];
        [modulesArrayTemp addObject:[[TronClassModule new] setDisplayName:@"TronClass" AndModuleName:@"TronClassModule" AndReuse:false]];
        [modulesArrayTemp addObject:[[Module new] setDisplayName:@"圖書館" AndModuleName:@"LibraryModule" AndReuse:true]];
        [modulesArrayTemp addObject:[[Module new] setDisplayName:@"行事曆" AndModuleName:@"CalendarModule" AndReuse:true]];
        [modulesArrayTemp addObject:[[Module new] setDisplayName:@"網路電話" AndModuleName:@"SipPhoneModule" AndReuse:false]];
        [modulesArrayTemp addObject:[[Module new] setDisplayName:@"緊急連絡" AndModuleName:@"EmergencyModule" AndReuse:true]];
        [modulesArrayTemp addObject:[[Module new] setDisplayName:@"設定" AndModuleName:@"SettingModule" AndReuse:true]];
        [modulesArrayTemp addObject:[[Module new] setDisplayName:@"關於" AndModuleName:@"AboutModule" AndReuse:true]];
        [modulesArrayTemp addObject:[[Module new] setDisplayName:@"其他連結" AndModuleName:@"OtherLinkModule" AndReuse:true]];
        
        modulesArray = [modulesArrayTemp copy];
    }
    
    return self;
}

-(Module*)moduleAtIndexPath:(NSIndexPath*)indexPath {
    return modulesArray[indexPath.row];
}

-(NSString*)displayNameAtIndexPath:(NSIndexPath*)indexPath {
    return [modulesArray[indexPath.row] displayName];
}

-(NSString*)moduleNameAtIndexPath:(NSIndexPath*)indexPath {
    return [modulesArray[indexPath.row] moduleName];
}

@end
