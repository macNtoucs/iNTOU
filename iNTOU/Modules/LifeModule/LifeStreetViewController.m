//
//  LifeStreetViewController.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/24.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "LifeStreetViewController.h"
#import "LifeButton.h"
#import "GoogleMapViewController.h"
#import "GoogleMapStreetViewController.h"

@interface LifeStreetViewController ()

@end

@implementation LifeStreetViewController
@synthesize streetName,streetData,streetInfo,streetScrollView,streetImageView,viewWidth,viewHeight,doubleTap;

#define buttonHeight 31
#define buttonWidth 300

- (void)viewDidLoad {
    [super viewDidLoad];
    //載入圖片
    streetImageView.image = [UIImage imageNamed:streetName];
    
    //調整長寬
    viewWidth.constant = streetImageView.image.size.width;
    viewHeight.constant = streetImageView.image.size.height;
    
    [self setZoomScale];
    
    [self loadButtons];
    
    [doubleTap addTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [streetScrollView addGestureRecognizer:doubleTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadButtons {
    NSArray* keys = [streetInfo allKeys];
    for(int i=0;i<[keys count];i++) {
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF['id'] CONTAINS %@",keys[i]];
        NSArray* stores = [streetData filteredArrayUsingPredicate:filter];
        for(int j=0;j<[stores count];j++) {
            int position = [[stores[j][@"id"] substringFromIndex:1] intValue];
            
            if([keys[i] characterAtIndex:0] == 'S')
                position = 0;
            
            LifeButton* store = [LifeButton buttonWithType:UIButtonTypeSystem];
            [store setFrame:CGRectMake([streetInfo[keys[i]][0] intValue], [streetInfo[keys[i]][1] intValue] + buttonHeight*(position - [streetInfo[keys[i]][2] intValue]), buttonWidth, buttonHeight)];
            
            store.buttonData = stores[j];
            
            [store setTitle:stores[j][@"name"] forState:UIControlStateNormal];
            [store setTintColor:[UIColor blackColor]];
            [store.titleLabel setFont: [UIFont systemFontOfSize: 18.0]];
            
            [store addTarget:self action:@selector(handleButtonPressed:) forControlEvents:UIControlEventTouchDown];
            
            UIImageView * btnIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[stores[j][@"type"] stringByReplacingOccurrencesOfString:@"/" withString:@""]]];
            [btnIcon setFrame:CGRectMake(store.frame.origin.x - buttonHeight, store.frame.origin.y, buttonHeight, buttonHeight)];
            
            [streetImageView addSubview:store];
            [streetImageView addSubview:btnIcon];
        }
    }
}

-(void)handleButtonPressed:(LifeButton *)button {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:button.buttonData[@"name"] message:button.buttonData[@"phone"] preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* call = [UIAlertAction actionWithTitle:@"撥打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",button.buttonData[@"phone"]]]];
    }];
    UIAlertAction* map = [UIAlertAction actionWithTitle:@"地圖" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        GoogleMapViewController* googleMap = [GoogleMapViewController new];
        [googleMap setLongitude:[button.buttonData[@"longitude"] doubleValue] andLatitude:[button.buttonData[@"latitude"] doubleValue] andZoom:17];
        googleMap.title = button.buttonData[@"name"];
        [googleMap setMark:button.buttonData[@"name"]];
        
        [self showViewController:googleMap sender:nil];
    }];
    UIAlertAction* streetView = [UIAlertAction actionWithTitle:@"街景" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        GoogleMapStreetViewController* googleStreetView = [GoogleMapStreetViewController new];
        [googleStreetView setLongitude:[button.buttonData[@"longitude"] doubleValue] andLatitude:[button.buttonData[@"latitude"] doubleValue]];
        googleStreetView.title = button.buttonData[@"name"];
        [self showViewController:googleStreetView sender:nil];
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:call];
    [alert addAction:map];
    [alert addAction:streetView];
    [alert addAction: cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)handleDoubleTap:(UITapGestureRecognizer *)gesture {
    double newScale = streetScrollView.zoomScale * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale  inView:streetScrollView withCenter:[gesture locationInView:gesture.view]];
    
    [streetScrollView zoomToRect:zoomRect animated:YES];
}

-(CGRect)zoomRectForScale:(double)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)viewWillLayoutSubviews {
    //旋轉時重設
    [self setZoomScale];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return streetImageView;
}

-(void)setZoomScale {
    //設定zoom的大小
    double zoomScale = MIN(self.view.bounds.size.width / streetImageView.image.size.width, self.view.bounds.size.height / streetImageView.image.size.height);
    
    streetScrollView.minimumZoomScale = zoomScale;
    streetScrollView.maximumZoomScale = zoomScale * 3;
    streetScrollView.zoomScale = zoomScale;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    //設定圖片置中
    double widthRatio = self.view.bounds.size.width / streetImageView.image.size.width;
    double heightRatio = self.view.bounds.size.height / streetImageView.image.size.height;
    
    if(widthRatio > heightRatio)
        scrollView.contentInset = UIEdgeInsetsMake(0,(self.view.bounds.size.width - streetImageView.image.size.width*heightRatio)/2, 0, 0);
    else
        scrollView.contentInset = UIEdgeInsetsMake((self.view.bounds.size.height - streetImageView.image.size.height*widthRatio)/2, 0, 0, 0);
}


@end
