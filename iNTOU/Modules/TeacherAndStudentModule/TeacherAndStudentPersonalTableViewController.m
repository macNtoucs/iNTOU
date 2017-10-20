//
//  TeacherAndStudentPersonalTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/10/16.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "TeacherAndStudentPersonalTableViewController.h"

@interface TeacherAndStudentPersonalTableViewController ()

@end

@implementation TeacherAndStudentPersonalTableViewController
@synthesize stidTarget;

static NSDictionary* tagName;
static NSArray* tagOrder;
static NSDictionary* conditionCode;

-(instancetype)initWithCoder:(NSCoder *)c {
    self = [super initWithCoder:c];
    if(self) {
        if(!tagName)
            tagName = @{@"CH_NAME":@"姓名",@"STNO":@"學號",@"SEX":@"性別",@"CPHONE":@"行動電話",@"INNER_EMAIL":@"校內信箱",@"OUTER_EMAIL":@"校外信箱",@"AUTOBI":@"自傳"};
        if(!tagOrder)
            tagOrder = @[@"CH_NAME",@"STNO",@"SEX",@"CPHONE",@"INNER_EMAIL",@"OUTER_EMAIL",@"AUTOBI"];
        if(!conditionCode)
            conditionCode = @{@"SEX":@{@"1":@"男",@"2":@"女"}};
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    moodle = [Moodle sharedInstance];
    [self downloadDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadDataFromServer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* urlString = [[NSString alloc]initWithFormat:@"http://140.121.91.62:8080/NTOUAPI/GetStudentInfo?stid=%@&password=%@",moodle.account,moodle.password];
        
        if(stidTarget)
            urlString = [urlString stringByAppendingFormat:@"&stidTarget=%@",stidTarget];
        
        NSURL* url = [[NSURL alloc]initWithString:urlString];
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(data)
            {
                personalData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
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
    if(!personalData)
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
    return [tagOrder count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalCells" forIndexPath:indexPath];
    
    ((UILabel*)[cell viewWithTag:101]).text = tagName[tagOrder[indexPath.row]];
    [((UITextView*)[cell viewWithTag:102]) setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    if(!personalData[tagOrder[indexPath.row]])
        ((UITextView*)[cell viewWithTag:102]).text = @"無";
    else if(conditionCode[tagOrder[indexPath.row]] && conditionCode[tagOrder[indexPath.row]][personalData[tagOrder[indexPath.row]]])
        ((UITextView*)[cell viewWithTag:102]).text = conditionCode[tagOrder[indexPath.row]][personalData[tagOrder[indexPath.row]]];
    else
        ((UITextView*)[cell viewWithTag:102]).text = personalData[tagOrder[indexPath.row]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
