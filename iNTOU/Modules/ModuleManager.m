//
//  ModuleManager.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "ModuleManager.h"
#import <UIKit/UIKit.h>

@implementation ModuleManager
@synthesize modulesArray;

-(instancetype)init {
    self = [super init];
    
    if(self) {
        
        NSMutableArray* modulesArrayTemp = [NSMutableArray new];
        
        //-------------在這下方加入新的module------------------
        //需要有對應moduleName的storyboard 不然會出錯
        //icon 為 Assets.xcassets 內同名的檔案
        [modulesArrayTemp addObject:[Module setDisplayName:@"最新消息" AndModuleName:@"NewsModule"]];
        [modulesArrayTemp addObject:[Module setDisplayName:@"校園導覽" AndModuleName:@"GuideModule"]];
        [modulesArrayTemp addObject:[Module setDisplayName:@"交通資訊" AndModuleName:@"TrafficModule"]];
        [modulesArrayTemp addObject:[Module setDisplayName:@"生活圈" AndModuleName:@"LifeModule"]];
        [modulesArrayTemp addObject:[Module setDisplayName:@"個人課程" AndModuleName:@"StellarModule"]];
        [modulesArrayTemp addObject:[Module setDisplayName:@"圖書館" AndModuleName:@"LibraryModule"]];
        [modulesArrayTemp addObject:[Module setDisplayName:@"行事曆" AndModuleName:@"CalendarModule"]];
        [modulesArrayTemp addObject:[Module setDisplayName:@"緊急連絡" AndModuleName:@"EmergencyModule"]];
        [modulesArrayTemp addObject:[Module setDisplayName:@"網路電話" AndModuleName:@"SipPhoneModule"]];
        [modulesArrayTemp addObject:[Module setDisplayName:@"設定" AndModuleName:@"SettingModule"]];
        [modulesArrayTemp addObject:[Module setDisplayName:@"關於" AndModuleName:@"AboutModule"]];
        [modulesArrayTemp addObject:[Module setDisplayName:@"其他連結" AndModuleName:@"OtherLinkModule"]];
        
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
