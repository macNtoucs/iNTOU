//
//  EmergencyTableViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/25.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "EmergencyTableViewController.h"

@interface EmergencyTableViewController () {
    NSString* mailTemp;
}

@end

@implementation EmergencyTableViewController

static NSString* reuseIdentifier = @"EmergencyCells";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    emergencyData = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EmergencyModule" ofType:@"plist"]];
    inner = emergencyData[@"contactInfo"][@"inner"];
    outer = emergencyData[@"contactInfo"][@"outer"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [inner count];
            break;
        case 1:
            return [outer count];
            break;
            
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"校內";
            break;
        case 1:
            return @"校外";
            break;
            
        default:
            return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary* cellData;
    switch ([indexPath section]) {
        case 0:
            cellData = inner[indexPath.row];
            break;
        case 1:
            cellData = outer[indexPath.row];
            break;
        default:
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    ((UILabel*)[cell viewWithTag:101]).text = cellData[@"name"];
    
    if([cellData[@"email"]isEqualToString:@""]) {
        ((UIImageView*)[cell viewWithTag:103]).image = [UIImage imageNamed:@"action_phone"];
        ((UILabel*)[cell viewWithTag:102]).text = cellData[@"phone"];
    }
    else {
        ((UIImageView*)[cell viewWithTag:103]).image = [UIImage imageNamed:@"action_email"];
        ((UILabel*)[cell viewWithTag:102]).text = cellData[@"email"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* targetArray;
    switch ([indexPath section]) {
        case 0:
            targetArray = inner;
            break;
        case 1:
            targetArray = outer;
            break;
        default:
            break;
    }
    
    NSDictionary* target = targetArray[indexPath.row];
    
    //打電話的情況
    if([target[@"email"]isEqualToString:@""]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"即將撥往" message:target[@"phone"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* callAction = [UIAlertAction actionWithTitle:@"撥打" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",target [@"phone"]]]];
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                           handler:nil];
        [alert addAction:callAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    //郵件的情況
    else {
        //相機不能用
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            return;
        //可以取用郵件
        if([MFMailComposeViewController canSendMail])
        {
            mailTemp = target[@"email"];
            UIImagePickerController* imagePicker = [UIImagePickerController new];
            imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }
        //沒有可用帳號
        else
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"未偵測到可用郵件帳號！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* mailAction = [UIAlertAction actionWithTitle:@"前往郵件" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"message:"]];
                                                               }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                                 handler:nil];
            [alert addAction:mailAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        MFMailComposeViewController *mailView = [MFMailComposeViewController new];
        mailView.mailComposeDelegate = self;
        [mailView setToRecipients:[NSArray arrayWithObjects:mailTemp, nil]];
        [mailView setSubject:@"緊急事件"];
        
        [mailView setMessageBody:@"[照片]" isHTML:NO];
        NSData *imageData = UIImagePNGRepresentation(image);
        [mailView addAttachmentData:imageData mimeType:@"image/png" fileName:@"image"];
        mailView.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    
        [self dismissViewControllerAnimated:YES completion:nil];
        [self presentViewController:mailView animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
