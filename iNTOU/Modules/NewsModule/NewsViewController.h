//
//  NewsViewController.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    NSArray* classData; //API內各大類別的資料
    NSArray* cellsData; //裝入cell的資料
    UIRefreshControl* refresh;
}


@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBarWidth;

@property (strong,nonatomic)NSArray* buttons;
@property (nonatomic)int selected;

@end
