//
//  TeacherClassStudentListTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/10/16.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TeacherClassStudentListTableViewController.h"

@interface TeacherClassStudentListTableViewController ()

@end

@implementation TeacherClassStudentListTableViewController
@synthesize semester,classInfo,studentSearchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    moodle = [Moodle sharedInstance];
    academicInformation = [AcademicInformation sharedInstance];
    
    if(classInfo[@"CLASSNO"])
        self.title = [[NSString alloc] initWithFormat:@"%@ - %@班",classInfo[@"CH_LESSON"],classInfo[@"CLASSNO"]];
    else
        self.title = classInfo[@"CH_LESSON"];
    
    studentSearchBar.delegate = self;
    imageCache = [NSCache new];
    threadLock = [NSMutableDictionary new];
    threadNum = 0;
    [self downloadDataFromServer];
    
    if(![academicInformation checkLogin])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否登入教學務系統以獲取學生大頭貼？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* login = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showLoginView:nil];
            });
        }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [alert addAction:login];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)showLoginView:(id)sender {
    UIStoryboard* setting = [UIStoryboard storyboardWithName:@"SettingModule" bundle:nil];
    UIViewController* loginView = [setting instantiateViewControllerWithIdentifier:@"AcademicInformation"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginView];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backPressed:)];
    
    loginView.navigationItem.leftBarButtonItem = backButton;
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)backPressed:(id)sender {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadDataFromServer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* urlString = [[NSString alloc]initWithFormat:@"http://140.121.91.62:8080/NTOUAPI/GetTeacherSemesterClassStudentList?stid=%@&password=%@&semester=%@&cosid=%@",self->moodle.account,self->moodle.password,self->semester,self->classInfo[@"COSID"]];
        if(self->classInfo[@"CLASSNO"])
            urlString = [urlString stringByAppendingFormat:@"&classno=%@",self->classInfo[@"CLASSNO"]];
        NSURL* url = [[NSURL alloc]initWithString:urlString];
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(data)
            {
                self->classStudentListData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                self->showData = self->classStudentListData[@"SemesterClassStudentList"];
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

-(void)downloadImageUrl:(NSString*)stid {
    threadLock[stid] = @"1"; // lock
    threadNum ++;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* urlString = [[NSString alloc]initWithFormat:@"https://ais.ntou.edu.tw/SCSPhotoQuery.aspx?ACNT=%@&PWD=%@&STNO=%@",self->academicInformation.account,self->academicInformation.password,stid];
        NSURL* url = [[NSURL alloc]initWithString:urlString];
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(data)
            {
                NSString* apiWeb = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSRange range = [apiWeb rangeOfString:@"name="];
                if (range.location != NSNotFound) {
                    apiWeb = [apiWeb substringFromIndex:range.location + 5];
                    range = [apiWeb rangeOfString:@"\""];
                    apiWeb = [apiWeb substringToIndex:range.location];
                    
                    [self downloadImage:stid AndUrl:apiWeb];
                }
                else {
                    self->threadLock[stid] = @"2"; // this student have no picture
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if([self->threadLock[stid] isEqualToString:@"1"])
                    self->threadLock[stid] = nil;
                self->threadNum --;
                [self.tableView reloadData];
            });
        }];
        [task resume];
    });
}

-(void)downloadImage:(NSString*)stid AndUrl: (NSString*)url {
    NSString* urlString = [[NSString alloc]initWithFormat:@"https://ais.ntou.edu.tw/utility/download.aspx?name=%@",url];
    NSURL* url2 = [[NSURL alloc]initWithString:urlString];
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url2 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:25.0];
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data)
        {
            [self->imageCache setObject:data forKey:stid];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
    [task resume];
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

    if(!classStudentListData)
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

    return [showData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassStudentListCells" forIndexPath:indexPath];
    UIActivityIndicatorView* indicator = ((UIActivityIndicatorView*)[cell viewWithTag:103]);
    UILabel* pictureLabel = ((UILabel*)[cell viewWithTag:104]);
    NSString* STNO = showData[indexPath.row][@"STNO"];
    ((UIImageView*)[cell viewWithTag:102]).image = nil;
    
    pictureLabel.text = @"";
    [indicator stopAnimating];
    [indicator setHidden:YES];
    
    ((UILabel*)[cell viewWithTag:101]).text = [[NSString alloc] initWithFormat:@"%@ - %@",showData[indexPath.row][@"CH_NAME"],STNO];
    if([imageCache objectForKey:STNO]) {
        ((UIImageView*)[cell viewWithTag:102]).image = [[UIImage alloc] initWithData:[imageCache objectForKey:STNO]];
    }
    else {
        if([academicInformation checkLogin])
        {
            ((UIImageView*)[cell viewWithTag:102]).image = nil;
            if(!threadLock[STNO] && threadNum <= 8) {
                [indicator startAnimating];
                [indicator setHidden:NO];
                [self downloadImageUrl:STNO];
            }
            else if([threadLock[STNO] isEqualToString:@"2"]) {
                pictureLabel.text = @"沒有圖片";
            }
            else {
                [indicator startAnimating];
                [indicator setHidden:NO];
            }
        }
        else
            pictureLabel.text = @"沒有帳號";
    }
    
    return cell;
}

#pragma mark - TableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"peekStudent" sender: indexPath];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath* indexPath = sender;
    id page = [segue destinationViewController];
    [page setValue:showData[indexPath.row][@"STNO"] forKey:@"stidTarget"];
    [page setValue:showData[indexPath.row][@"CH_NAME"] forKey:@"customTitle"];
}

#pragma mark - search bar

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    if(![searchText isEqualToString:@""])
    {
        NSPredicate* filter = [NSPredicate predicateWithFormat:@"CH_NAME CONTAINS %@ OR STNO CONTAINS %@",searchText,searchText];
        showData = [classStudentListData[@"SemesterClassStudentList"] filteredArrayUsingPredicate:filter];
        
    }
    else
    {
        showData = classStudentListData[@"SemesterClassStudentList"];
    }
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


@end
