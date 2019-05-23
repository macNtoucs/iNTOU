//
//  TeacherAndStudentGradeListTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/10/16.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TeacherAndStudentGradeListTableViewController.h"

@interface TeacherAndStudentGradeListTableViewController ()

@end

@implementation TeacherAndStudentGradeListTableViewController
@synthesize semester,stidTarget;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    moodle = [Moodle sharedInstance];
    
    self.title = [[NSString alloc] initWithFormat:@"%@學年",semester];
    
    [self downloadDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadDataFromServer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* urlString = [[NSString alloc]initWithFormat:@"http://140.121.91.62:8080/SCLAB/GetStudentSemesterGrade?stid=%@&password=%@&semester=%@",self->moodle.account,self->moodle.password,self->semester];
        
        if(self->stidTarget)
            urlString = [urlString stringByAppendingFormat:@"&stidTarget=%@",self->stidTarget];
        
        NSURL* url = [[NSURL alloc]initWithString:urlString];
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(data)
            {
                self->gradeData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
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

    if(!gradeData||!gradeData[@"ClassList"])
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundView = [self loadingViewWithText:@"下載資料中"];
        return 0;
    }
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewStylePlain;
    
    if(gradeData[@"GradeInfo"])
        return 2;
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case 0:
            return [gradeData[@"ClassList"] count];
            break;
        case 1:
            return 3;
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeList" forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            if(gradeData[@"ClassList"][indexPath.row][@"CRD"])
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ - %@",gradeData[@"ClassList"][indexPath.row][@"CH_LESSON"],gradeData[@"ClassList"][indexPath.row][@"CRD"]];
            else
                cell.textLabel.text = gradeData[@"ClassList"][indexPath.row][@"CH_LESSON"];
            
                cell.detailTextLabel.text = gradeData[@"ClassList"][indexPath.row][@"SMS_FMARK"];
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"通過學分/總學分";
                    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@/%@",gradeData[@"GradeInfo"][@"PASS_CRD"],gradeData[@"GradeInfo"][@"CRD_TOTAL"]];
                    break;
                case 1:
                    cell.textLabel.text = @"班級排名";
                    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@/%@",gradeData[@"GradeInfo"][@"CLASS_RANK"],gradeData[@"GradeInfo"][@"CLASS_SORT_DENO"]];
                    break;
                case 2:
                    cell.textLabel.text = @"系排名";
                    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@/%@",gradeData[@"GradeInfo"][@"FACULTY_RANK"],gradeData[@"GradeInfo"][@"FACULTY_SORT_DENO"]];
                    break;
                    
                default:
                    break;
            }
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return [[NSString alloc] initWithFormat:@"%@課程 - 學分 - 總成績",semester];
            break;
        case 1:
            return [[NSString alloc] initWithFormat:@"%@排名成績資訊",semester];
            break;
            
        default:
            return nil;
            break;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
