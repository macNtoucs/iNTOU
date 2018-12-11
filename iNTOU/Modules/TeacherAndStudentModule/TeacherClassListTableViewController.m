//
//  TeacherClassListTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/10/16.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TeacherClassListTableViewController.h"

@interface TeacherClassListTableViewController ()

@end

@implementation TeacherClassListTableViewController
@synthesize semester;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    moodle = [Moodle sharedInstance];
    
    self.title = [[NSString alloc] initWithFormat:@"%@學年授課列表",semester];
    
    [self downloadDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadDataFromServer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* urlString = [[NSString alloc]initWithFormat:@"http://140.121.91.62:8080/NTOUAPI/GetTeacherSemesterClassList?stid=%@&password=%@&semester=%@",moodle.account,moodle.password,semester];
        NSURL* url = [[NSURL alloc]initWithString:urlString];
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(data)
            {
                classListData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
            else
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"無法連線到伺服器！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:alert animated:YES completion:nil];
                });
            }
        }];
        [task resume];
    });
    
}

-(UIView*)loadingViewWithText:(NSString*)text {
    UIView* viewToShow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];
    indicator.center = viewToShow.center;
    [viewToShow addSubview:indicator];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, viewToShow.center.y + indicator.bounds.size.height/2 + 3, self.view.bounds.size.width, 17.0)];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    [viewToShow addSubview:label];
    return viewToShow;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(!classListData)
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundView = [self loadingViewWithText:@"下載資料中"];
        return 0;
    }
    
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewStylePlain;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [classListData[@"SemesterClassList"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassListCells" forIndexPath:indexPath];
    
    if(classListData[@"SemesterClassList"][indexPath.row][@"CLASSNO"])
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ - %@班",classListData[@"SemesterClassList"][indexPath.row][@"CH_LESSON"],classListData[@"SemesterClassList"][indexPath.row][@"CLASSNO"]];
    else
        cell.textLabel.text = classListData[@"SemesterClassList"][indexPath.row][@"CH_LESSON"];
    
    return cell;
}


#pragma mark - TableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ClassStudentList" sender: indexPath];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath* indexPath = sender;
    id page = [segue destinationViewController];
    [page setValue:classListData[@"SemesterClassList"][indexPath.row] forKey:@"classInfo"];
    [page setValue:semester forKey:@"semester"];
}


@end
