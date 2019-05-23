//
//  TrafficBusTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/17.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TrafficBusTableViewController.h"


@interface TrafficBusTableViewController ()

@end

@implementation TrafficBusTableViewController
@synthesize busSearchBar,tapRecognizer;

static NSArray* city;
static NSArray* cityName;

//紀錄第一次點擊searchBar
bool click=true;

-(instancetype)initWithCoder:(NSCoder *)c {
    self = [super initWithCoder:c];
    if(self) {
        if(!city)
            city = @[@"K",@"T",@"N"];
        if(!cityName)
            cityName = @[@"基隆",@"臺北",@"新北"];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    click=true;
    usuallyUse = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TrafficBusUsuallyUse"] mutableCopy];
    if(!usuallyUse)
        usuallyUse = [NSMutableArray new];
    
    //借用city[0] 為了cellForRowAtIndexPath的重用性
    searchResult = [NSMutableDictionary new];
    searchResult[city[0]] = usuallyUse;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearHistory:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TrafficBusUsuallyUse"];
    usuallyUse = [NSMutableArray new];
    if([busSearchBar.text isEqualToString:@""])
    {
        searchResult[city[0]] = usuallyUse;
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([busSearchBar.text isEqualToString:@""])
        return 1;
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if([busSearchBar.text isEqualToString:@""])
        return @"歷史紀錄";
    return cityName[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchResult[city[section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrafficBusCells" forIndexPath:indexPath];
    
    ((UILabel*)[cell viewWithTag:101]).text = searchResult[city[indexPath.section]][indexPath.row][@"nameZh"];
    
    if(searchResult[city[indexPath.section]][indexPath.row][@"Id"])
        ((UILabel*)[cell viewWithTag:102]).text = [[NSString alloc] initWithFormat:@"%@->%@",searchResult[city[indexPath.section]][indexPath.row][@"departureZh"],searchResult[city[indexPath.section]][indexPath.row][@"destinationZh"]];
    else
        ((UILabel*)[cell viewWithTag:102]).text = @"站牌";
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
    return index;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if([busSearchBar.text isEqualToString:@""])
        return nil;
    return cityName;
}

#pragma mark - TableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(searchResult[city[indexPath.section]][indexPath.row][@"Id"])
        [self performSegueWithIdentifier:@"Route" sender:indexPath];
    else
        [self performSegueWithIdentifier:@"Stop" sender:indexPath];

    if(![busSearchBar.text isEqualToString:@""])
        if(![usuallyUse containsObject:searchResult[city[indexPath.section]][indexPath.row] ])
        {
            NSMutableDictionary* saveTarget = [searchResult[city[indexPath.section]][indexPath.row] mutableCopy];
            [saveTarget setObject:city[indexPath.section] forKey:@"city"];
            [usuallyUse insertObject:[saveTarget copy] atIndex:0];
            [[NSUserDefaults standardUserDefaults] setObject:usuallyUse forKey:@"TrafficBusUsuallyUse"];
        }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id page = [segue destinationViewController];
    NSIndexPath* indexPath = sender;
    
    [page setValue:searchResult[city[indexPath.section]][indexPath.row][@"nameZh"] forKey:@"name"];
    
    //在歷史紀錄中，是會有city值的
    if(searchResult[city[indexPath.section]][indexPath.row][@"city"])
        [page setValue:searchResult[city[indexPath.section]][indexPath.row][@"city"] forKey:@"city"];
    else
        [page setValue:city[indexPath.section] forKey:@"city"];
    
    if(searchResult[city[indexPath.section]][indexPath.row][@"Id"])
    {
        [page setValue:searchResult[city[indexPath.section]][indexPath.row][@"Id"] forKey:@"routeId"];
        [page setValue:searchResult[city[indexPath.section]][indexPath.row][@"departureZh"] forKey:@"departureZh"];
        [page setValue:searchResult[city[indexPath.section]][indexPath.row][@"destinationZh"] forKey:@"destinationZh"];
    }
    
}


#pragma mark - search bar

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    
    if(![searchText isEqualToString:@""])
    {
        searchResult = [NSMutableDictionary new];
        
        for(int i=0;i<[city count];i++)
        {
            NSString* urlString = [[NSString alloc]initWithFormat:@"http://140.121.91.62/TrafficAPI_ver2.0/Bus/SearchBus.php?search=%@&city=%@",searchText,city[i]];
            urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURLRequest* request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
            
            NSURLSession* session = [NSURLSession sharedSession];
            NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if(data)
                {
                    NSDictionary* temp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if([searchText isEqualToString:self->busSearchBar.text])
                        {
                            self->searchResult[city[i]] = [temp[@"searchResult"] copy];
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
    }
    else
    {
        searchResult[city[0]] = usuallyUse;
        [self.tableView reloadData];
    }
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if(click)
    {
        [searchBar setText:@"104"];
        [self searchBar:searchBar textDidChange:[searchBar text]];
        [searchBar resignFirstResponder];
        click=false;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
