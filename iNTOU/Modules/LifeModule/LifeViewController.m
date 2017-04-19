//
//  LifeViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/24.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "LifeViewController.h"
#import "LifeStreetViewController.h"

@interface LifeViewController ()

@end

@implementation LifeViewController

-(void)setupPages {
    
    LifeStreetViewController* page0 = [self.storyboard instantiateViewControllerWithIdentifier:@"LifeStreet"];
    LifeStreetViewController* page1 = [self.storyboard instantiateViewControllerWithIdentifier:@"LifeStreet"];
    LifeStreetViewController* page2 = [self.storyboard instantiateViewControllerWithIdentifier:@"LifeStreet"];
    LifeStreetViewController* page3 = [self.storyboard instantiateViewControllerWithIdentifier:@"LifeStreet"];
    LifeStreetViewController* page4 = [self.storyboard instantiateViewControllerWithIdentifier:@"LifeStreet"];
    
    page0.streetName = @"祥豐街";
    page1.streetName = @"中正路";
    page2.streetName = @"北寧路";
    page3.streetName = @"新豐街";
    page4.streetName = @"深溪路";
    
    pages = @[page0,page1,page2,page3,page4];
    
    for(LifeStreetViewController* page in pages) {
        NSPredicate* filter = [NSPredicate predicateWithFormat:@"SELF['street'] == %@",page.streetName];
        page.streetData = [lifeData[@"store"] filteredArrayUsingPredicate:filter];
    }
    
    //一個符號配三個數字 (原點x,原點y,初始編號)
    //S符號數字另外標記 EX:S01、S02、S87
    NSDictionary *st0 = @{@"L":@[@40,@235,@0]};
    NSDictionary *st1 = @{@"L":@[@70,@212,@26],@"R":@[@452,@212,@26],@"S0":@[@70,@946,@0],@"S1":@[@540,@1459,@0],@"S2":@[@240,@1459,@0]};
    NSDictionary *st2 = @{@"R":@[@350,@255,@66]};
    NSDictionary *st3 = @{@"L":@[@40,@117,@86],@"R":@[@379,@117,@86]};
    NSDictionary *st4 = @{@"L":@[@30,@160,@131],@"R":@[@380,@160,@131]};
    
    NSArray* streetInfos = @[st0,st1,st2,st3,st4];
    
    for(int i=0;i<(int)[pages count];i++)
        ((LifeStreetViewController*)pages[i]).streetInfo = streetInfos[i];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lifeData = [[NSUserDefaults standardUserDefaults] objectForKey:@"LifeModule"];
    if(!lifeData)
        lifeData = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LifeModule" ofType:@"plist"]];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.dataSource = self;
    self.delegate = self;
    
    [self setupPages];
    [self setViewControllers:@[pages[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self downloadDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadDataFromServer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* urlString = @"http://140.121.100.103:8080/CircleServlet/CircleServlet.do";
        NSURL* url = [[NSURL alloc]initWithString:urlString];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        [request setHTTPMethod:@"POST"];
        NSString *postString = @"version=0&dataType=json";
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSession* session = [NSURLSession sharedSession];
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(data) {
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                //版本不符合
                if(![json[@"version"] isEqualToString:lifeData[@"version"]]) {
                    
                    //更新本地檔案
                    [[NSUserDefaults standardUserDefaults]setObject:json forKey:@"CalendarModule"];
                    
                    //跳出更新視窗
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"偵測到更新"
                                                                                       message:@"有新版本的生活圈！"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {
                                                                                  lifeData = json;
                                                                                  [self setupPages];
                                                                                  [self setViewControllers:@[pages[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
                                                                              }];
                        
                        [alert addAction:defaultAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    });
                }
                
            }
            dispatch_semaphore_signal(semaphore);
        }];
        [task resume];
        dispatch_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
}

#pragma mark - UIPageViewControllerDataSource

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [pages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if(viewController == nil)
        return pages[0];
    
    NSInteger idx = [pages indexOfObject:viewController];
    if(idx == 0)
        return nil;
    
    return pages[idx - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    
    if(viewController == nil)
        return pages[0];
    
    NSInteger idx = [pages indexOfObject:viewController];
    if(idx == [pages count] - 1)
        return nil;
    
    return pages[idx + 1];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
}


@end
