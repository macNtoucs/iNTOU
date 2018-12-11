//
//  StellarViewLayout.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/4/17.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "StellarViewLayout.h"

@implementation StellarViewLayout
@synthesize baseViewHeight,baseViewWidth,delegate;

-(void)prepareLayout {
    NSMutableDictionary* attributeTemp = [NSMutableDictionary new];
    
    for(int section = 0 ; section < self.collectionView.numberOfSections ; section++)
    {
        for(int item = 0 ; item < [self.collectionView numberOfItemsInSection:section] ; item++)
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:item inSection:section];
            UICollectionViewLayoutAttributes* itemAttribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            int length = [delegate cellLengthAtIndexPath:indexPath];
            switch (length) {
                case -1:
                    itemAttribute.frame = CGRectMake(0, 0, 0, 0);
                    break;
                case 0:
                    itemAttribute.frame = CGRectMake(1 + section*baseViewWidth + section, 1 + item*baseViewHeight + item, baseViewWidth, baseViewHeight);
                    break;
                default:
                    itemAttribute.frame = CGRectMake(1 + section*baseViewWidth + section, 1 + item*baseViewHeight + item, baseViewWidth, baseViewHeight*length + length - 1);
                    break;
            }
            
            [attributeTemp setObject:itemAttribute forKey:indexPath];
        }
    }
    
    attributes =  [attributeTemp copy];
}

-(CGSize)collectionViewContentSize {
    return CGSizeMake(baseViewWidth * 7 + 7, baseViewHeight*14 + 14);
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributesInRect = [NSMutableArray new];
    
    for(int section = 0 ; section < self.collectionView.numberOfSections ; section++)
    {
        for(int item = 0 ; item < [self.collectionView numberOfItemsInSection:section] ; item++)
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:item inSection:section];
            if(CGRectIntersectsRect(rect,[attributes[indexPath] frame]))
                [attributesInRect addObject:attributes[indexPath]];
        }
    }
    return [attributesInRect copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return attributes[indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
