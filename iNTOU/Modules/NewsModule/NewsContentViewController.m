//
//  NewsContentViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/23.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "NewsContentViewController.h"
#import <SafariServices/SafariServices.h>

@interface NewsContentViewController ()

@end

@implementation NewsContentViewController
@synthesize data,webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableString* doc = [NSMutableString new];
    //title
    [doc appendString:data[@"title"]];
    [doc appendString:@"</br>"];
    //dpname,promoter
    [doc appendString:[[NSString alloc]initWithFormat:@"發布單位：%@ %@",data[@"dpname"],data[@"promoter"]]];
    [doc appendString:@"</br>"];
    
    //pubDate
    [doc appendString:[[NSString alloc]initWithFormat:@"發布日期：%@",data[@"pubDate"]]];
    [doc appendString:@"</br>"];
    [doc appendString:@"</br>"];
    //body
    NSString* body = data[@"body"];
    body = [body stringByReplacingOccurrencesOfString:@"\n\r" withString:@"</br>"];
    body = [body stringByReplacingOccurrencesOfString:@"\n" withString:@"</br>"];
    body = [body stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    [doc appendString:body];
    [doc appendString:@"</br>"];
    //link
    if(![data[@"link"] isEqualToString:@""])
        [doc appendString:[[NSString alloc] initWithFormat:@"<a href=\"%@\">連結<a></br>",data[@"link"]]];
    
    //Attachment
    for(int i=0;i<[data[@"Attachment_Title"]count];i++) {
        [doc appendString:[[NSString alloc] initWithFormat:@"<a href=\"%@\">%@<a></br>",data[@"Attachment_URL"][i],data[@"Attachment_Title"][i]]];
    }
    
    [webView loadHTMLString:[doc copy] baseURL:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    //開啟瀏覽器
    if(navigationType == UIWebViewNavigationTypeLinkClicked) {
        SFSafariViewController* safari = [[SFSafariViewController alloc]initWithURL:[request URL]];
        [self presentViewController:safari animated:YES completion:nil];
        return NO;
    }
    return YES;
}


@end
