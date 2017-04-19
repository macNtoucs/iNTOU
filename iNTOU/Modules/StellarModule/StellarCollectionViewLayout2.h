//
//  StellarCollectionViewLayout.h
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/27.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StellarCollectionViewLayout : UICollectionViewLayout
{
    double view_Width;
    double view_Height;
    double cell_Width;
    double cell_Height;
}

@property (nonatomic,weak)NSDictionary* stellarData;

@end
