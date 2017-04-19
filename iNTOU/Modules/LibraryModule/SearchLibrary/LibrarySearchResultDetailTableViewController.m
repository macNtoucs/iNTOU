//
//  LibrarySearchResultDetailTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/9.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "LibrarySearchResultDetailTableViewController.h"

@interface LibrarySearchResultDetailTableViewController ()

@end

@implementation LibrarySearchResultDetailTableViewController
@synthesize searchResultData;

static NSArray* type;
static NSDictionary* typeName;

-(instancetype)initWithCoder:(NSCoder *)c {
    self = [super initWithCoder:c];
    if(self) {
        if(!type)
            type = @[@"title",@"author",@"pubInform",@"ISBN"];
        if(!typeName)
            typeName = @{@"title":@"書名：",@"author":@"作者：",@"pubInform":@"出版項：",@"ISBN":@"ISBN："};
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [type count];
            break;
        case 1:
            return [searchResultData[@"realBookDetail"] count];
            break;
        case 2:
            return [searchResultData[@"electricBookDetail"] count];
            break;
            
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryModuleSearchResultDetailCells1" forIndexPath:indexPath];
            ((UILabel*)[cell viewWithTag:101]).text = typeName[type[indexPath.row]];
            ((UILabel*)[cell viewWithTag:102]).text = searchResultData[type[indexPath.row]];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryModuleSearchResultDetailCells2" forIndexPath:indexPath];
            ((UILabel*)[cell viewWithTag:101]).text = searchResultData[@"realBookDetail"][indexPath.row][@"location"];
            ((UILabel*)[cell viewWithTag:102]).text = searchResultData[@"realBookDetail"][indexPath.row][@"number"];
            ((UILabel*)[cell viewWithTag:103]).text = searchResultData[@"realBookDetail"][indexPath.row][@"barcode"];
            ((UILabel*)[cell viewWithTag:104]).text = searchResultData[@"realBookDetail"][indexPath.row][@"status"];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryModuleSearchResultDetailCells3" forIndexPath:indexPath];
            ((UILabel*)[cell viewWithTag:101]).text = searchResultData[@"electricBookDetail"][indexPath.row][@"subtitle"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"書籍資訊";
            break;
        case 1:
            if([searchResultData[@"realBookDetail"] count])
                return @"預約（暫時關閉功能）";
            break;
        case 2:
            if([searchResultData[@"electricBookDetail"] count])
                return @"電子書籍";
            break;
    }
    return nil;
}

#pragma mark - table view

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 2)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:searchResultData[@"electricBookDetail"][indexPath.row][@"url"]]];
}



@end
