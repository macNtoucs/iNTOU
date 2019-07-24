//
//  TeacherAndStudentListTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/10/16.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TeacherAndStudentListTableViewController.h"

@interface TeacherAndStudentListTableViewController ()

@end

@implementation TeacherAndStudentListTableViewController
@synthesize stidTarget,customTitle;

static NSArray* teachFunc;
static NSArray* studentFunc;

-(instancetype)initWithCoder:(NSCoder *)c {
    self = [super initWithCoder:c];
    if(self) {
        if(!teachFunc)
            teachFunc = @[@"查詢學號"];
        if(!studentFunc)
            studentFunc = @[@"個人資料"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    moodle = [Moodle sharedInstance];
    if(customTitle)
         self.title = customTitle;
    else
        self.title = @"導生系統";
    
    //功能暫時停用
    
     refresh =[UIRefreshControl new];
     [refresh addTarget:self action:@selector(checkType) forControlEvents:UIControlEventValueChanged];
     self.tableView.backgroundView = refresh;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"公告"
                                                                   message:@"此功能暫停使用！"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self.navigationController popToRootViewControllerAnimated:YES];
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    //功能暫時停用
    /*
    if([moodle checkLogin])
    {
        if(!typeData)
            [self checkType];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"沒有登入的帳戶，請前往設定登入個人課程！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        [self.tableView reloadData];
    }
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkType {
    listData = nil;
    typeData = nil;
    [self.tableView reloadData];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* urlString = [[NSString alloc]initWithFormat:@"http://140.121.91.62:8080/NTOUAPI/IsTeacher?stid=%@&password=%@",self->moodle.account,self->moodle.password];
        if(self->stidTarget)
            urlString = [urlString stringByAppendingFormat:@"&stidTarget=%@",self->stidTarget];
        
        NSURL* url = [[NSURL alloc]initWithString:urlString];
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(data)
            {
                self->typeData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if(self->typeData[@"IsTeacher"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self downloadDataFromServer];
                    });
                }
                else
                {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"無法取得身份資料！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancel];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentViewController:alert animated:YES completion:nil];
                    });
                }
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

-(void)downloadDataFromServer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* urlString;
        
        if([self->typeData[@"IsTeacher"] isEqualToString:@"1"] && !self->stidTarget)
            urlString = [[NSString alloc]initWithFormat:@"http://140.121.91.62:8080/NTOUAPI/GetTeacherSemesterList?stid=%@&password=%@",self->moodle.account,self->moodle.password];
        else
            urlString = [[NSString alloc]initWithFormat:@"http://140.121.91.62:8080/NTOUAPI/GetStudentSemesterList?stid=%@&password=%@",self->moodle.account,self->moodle.password];
        
        if(self->stidTarget)
            urlString = [urlString stringByAppendingFormat:@"&stidTarget=%@",self->stidTarget];
        NSURL* url = [[NSURL alloc]initWithString:urlString];
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(data)
            {
                self->listData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->refresh endRefreshing];
            });
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
    if(![moodle checkLogin])
    {
        UILabel* label = [UILabel new];
        label.text = @"沒有登入的帳號";
        label.center = self.view.center;
        label.textAlignment = NSTextAlignmentCenter;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundView = label;
        return 0;
    }
    
    if(!typeData || !listData)
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundView = [self loadingViewWithText:@"下載資料中"];
        return 0;
    }
    
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewStylePlain;
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            if(typeData && typeData[@"IsTeacher"])
            {
                if([typeData[@"IsTeacher"] isEqualToString:@"1"])
                    return [teachFunc count];
                else
                    return [studentFunc count];
            }
            else
                return 0;
            break;
        case 1:
            if(listData && listData[@"SemesterList"])
                return [listData[@"SemesterList"] count];
            break;
    }
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCells" forIndexPath:indexPath];
    
    
    switch (indexPath.section) {
        case 0:
            if([typeData[@"IsTeacher"] isEqualToString:@"1"] && !stidTarget)
                cell.textLabel.text = teachFunc[indexPath.row];
            else
                cell.textLabel.text = studentFunc[indexPath.row];
            break;
        case 1:
            cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@學年",listData[@"SemesterList"][indexPath.row]];
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"功能列表";
            break;
        case 1:
            if([typeData[@"IsTeacher"] isEqualToString:@"1"] && !stidTarget)
                return @"學年授課列表";
            else
                return @"學年成績列表";
            break;
            
        default:
            return nil;
            break;
    }
}

#pragma mark - TableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            if([typeData[@"IsTeacher"] isEqualToString:@"1"] && !stidTarget)
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"查詢學號" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.keyboardType = UIKeyboardTypeDefault;
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"送出"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action) {
                                                                     UITextField *textField = [alert.textFields firstObject];
                                                                     TeacherAndStudentListTableViewController* newOne = [self.storyboard instantiateInitialViewController];
                                                                     newOne.stidTarget = textField.text;
                                                                     newOne.customTitle = [[NSString alloc] initWithFormat:@"查詢:%@",textField.text];
                                                                     [self showViewController:newOne sender:nil];
                                                                 }];
                [alert addAction:okAction];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:cancelAction];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
                [self performSegueWithIdentifier:@"Personal" sender:indexPath];
            break;
        case 1:
            if([typeData[@"IsTeacher"] isEqualToString:@"1"] && !stidTarget)
                [self performSegueWithIdentifier:@"ClassList" sender: indexPath];
            else
                [self performSegueWithIdentifier:@"Grade" sender: indexPath];
            break;
            
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath* indexPath = sender;
    id page = [segue destinationViewController];
    switch (indexPath.section)
    {
        case 0:
            break;
        case 1:
            [page setValue:listData[@"SemesterList"][indexPath.row] forKey:@"semester"];
            break;
            
    }
    if(stidTarget)
        [page setValue:stidTarget forKey:@"stidTarget"];
}


@end
