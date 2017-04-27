//
//  LibrarySearchViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/2/8.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "LibrarySearchViewController.h"

@interface LibrarySearchViewController ()

@end

@implementation LibrarySearchViewController
@synthesize searchTextField,tapRecognizer,searchScrollView;

static NSArray* type;

-(instancetype)initWithCoder:(NSCoder *)c {
    self = [super initWithCoder:c];
    if(self) {
        if(!type)
            type = @[@"關鍵字",@"ISBN"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [tapRecognizer addTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem * barCodeButton = [[UIBarButtonItem alloc]initWithTitle:@"條碼掃描" style:UIBarButtonItemStylePlain target:self action:@selector(barCodeButton)];
    self.tabBarController.navigationItem.rightBarButtonItem = barCodeButton;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)barCodeButton {
    [self performSegueWithIdentifier:@"barCode" sender:nil];
}

-(void)dismissKeyboard {
    [searchTextField resignFirstResponder];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    searchScrollView.contentInset = contentInsets;
    searchScrollView.scrollIndicatorInsets = contentInsets;
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    searchScrollView.contentInset = contentInsets;
    searchScrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Text Field

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self performSegueWithIdentifier:@"SearchAction" sender:nil];
    return YES;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id view = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"SearchAction"])
    {
        if([searchTextField.text intValue]%100000000000>0)
            [view setValue:@"i" forKey:@"type"];
        else
            [view setValue:@"X" forKey:@"type"];
        [view setValue:searchTextField.text forKey:@"searchKey"];
    }
}


@end
