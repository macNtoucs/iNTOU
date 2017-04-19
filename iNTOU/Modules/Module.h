//
//  Module.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Module : NSObject

@property (nonatomic,strong)UIViewController* viewController; //保存起來的viewController

@property (nonatomic,strong)NSString* displayName; //用來顯示在螢幕上的名字
@property (nonatomic,strong)NSString* moduleName; //這會讀取相同名字的storyboard和image(顯示在displayName上方的圖案)


-(instancetype)init;
+(instancetype)setDisplayName:(NSString*)displayName AndModuleName:(NSString*)moduleName; //用在moduleManager上做初始化
-(UIViewController*)getViewController; //取得storyboard的初始view controller
-(void)clearViewController;

@end
