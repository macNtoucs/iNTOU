//
//  StellarViewLayout.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/4/17.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StellarViewLayoutDelegate

@required
-(unsigned int)cellLengthAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface StellarViewLayout : UICollectionViewLayout {
    NSDictionary* attributes;
}

@property (weak,nonatomic)IBOutlet id <StellarViewLayoutDelegate> delegate;
@property (nonatomic) CGFloat baseViewHeight;
@property (nonatomic) CGFloat baseViewWidth;

@end
