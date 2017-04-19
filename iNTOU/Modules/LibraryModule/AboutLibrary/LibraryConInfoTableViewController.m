//
//  LibraryConInfoTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/5.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "LibraryConInfoTableViewController.h"

@interface LibraryConInfoTableViewController ()

@end

@implementation LibraryConInfoTableViewController

static NSArray* types;

-(instancetype)initWithCoder:(NSCoder *)c {
    self = [super initWithCoder:c];
    if(self) {
        if(!types)
            types = @[@"電話:",@"FAX:",@"信箱:"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    libraryConInfo = @[@[@"0224622192,1187",@"0224624651",@"lit@mail.ntou.edu.tw"],@[@"0224622192,1171",@"0224631208",@"staff@mail.ntou.edu.tw"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"圖書服務";
            break;
        case 1:
            return @"資訊服務";
            break;
            
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryModuleConInfoCells" forIndexPath:indexPath];
    
    ((UILabel*)[cell viewWithTag:101]).text = types[indexPath.row];
    ((UILabel*)[cell viewWithTag:102]).text = libraryConInfo[indexPath.section][indexPath.row];
    
    return cell;
}




@end
