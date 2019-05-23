//
//  TrafficExpressTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/3/15.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TrafficExpressTableViewController.h"

@interface TrafficExpressTableViewController ()

@end

@implementation TrafficExpressTableViewController
@synthesize expressSearchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    usuallyUse = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TrafficExpressUsuallyUse"] mutableCopy];
    if(!usuallyUse)
        usuallyUse = [NSMutableArray new];
    
    searchResult = usuallyUse;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearHistory:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TrafficExpressUsuallyUse"];
    usuallyUse = [NSMutableArray new];
    if([expressSearchBar.text isEqualToString:@""])
    {
        searchResult = usuallyUse;
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {  
    return [searchResult count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([expressSearchBar.text isEqualToString:@""])
        return @"歷史紀錄";
    return @"經台北客運";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrafficExpressCells" forIndexPath:indexPath];
    
    ((UILabel*)[cell viewWithTag:101]).text = searchResult[indexPath.row][@"nameZh"];
    
    return cell;
}

#pragma mark - TableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"Express" sender:indexPath];
    
    if(![expressSearchBar.text isEqualToString:@""])
        if(![usuallyUse containsObject:searchResult[indexPath.row]])
        {
            [usuallyUse insertObject:searchResult[indexPath.row] atIndex:0];
            [[NSUserDefaults standardUserDefaults] setObject:usuallyUse forKey:@"TrafficExpressUsuallyUse"];
        }
}

#pragma mark - search bar

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    
    if(![searchText isEqualToString:@""])
    {
        NSString* urlString = [[NSString alloc]initWithFormat:@"http://140.121.91.62/TrafficAPI_ver2.0/Bus/SearchExpress.php?search=%@",searchText];
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            self->searchResult = nil;
            if(data)
            {
                NSDictionary* temp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([searchText isEqualToString:self->expressSearchBar.text])
                    {
                        self->searchResult = [temp[@"searchResult"] copy];
                        [self.tableView reloadData];
                    }
                });
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    if(!self->messageTag)
                    {
                        self->messageTag = true;
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"無法取得連線！" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
                            self->messageTag = false;
                        }];
                        [alert addAction:cancel];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                });
            }
        }];
        [task resume];
    }
    else
    {
        searchResult = usuallyUse;
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id page = [segue destinationViewController];
    NSIndexPath* indexPath = sender;
    
    [page setValue:searchResult[indexPath.row][@"nameZh"] forKey:@"ExpressName"];
}


@end
