//
//  StellarCollectionViewLayout.m
//  iNTOU
//
//  Created by Jheng-Chi on 2017/1/27.
//  Copyright © 2017年 Lab414. All rights reserved.
//

#import "StellarCollectionViewLayout.h"

@implementation StellarCollectionViewLayout
@synthesize stellarData;

static NSArray * weekday;
static NSArray * weekTag;

-(instancetype)initWithCoder:(NSCoder *)c {
    self = [super initWithCoder:c];
    if(self) {
        if(!weekday)
            weekday = @[@"",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
        if(!weekTag)
            weekTag = @[@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun"];
    }
    return self;
}

#define View_Width self.collectionView.bounds.size.width
#define View_Height self.collectionView.bounds.size.height
#define Cells_Section 8
#define Cells_Row 16
#define Cell_Width ((View_Width - (Cells_Section + 1)) / Cells_Section)
#define Cell_Height ((View_Height - (Cells_Row + 1)) / (Cells_Row - 0.5))

- (CGSize)collectionViewContentSize {
    return CGSizeMake(cell_Width * Cells_Section,cell_Height * (Cells_Row - 0.5) + (Cells_Row + 1));
}

- (void)prepareLayout {
    [super prepareLayout];
    
    if(Cell_Width < 60)
        cell_Width = 60;
    else
        cell_Width = Cell_Width;
    
    if(Cell_Height < 39)
        cell_Height = 39;
    else
        cell_Height = Cell_Height;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* elementsInRect = [NSMutableArray array];
    
    for(NSUInteger i = 0; i < [self.collectionView numberOfSections]; i++)
    {
        for(NSUInteger j = 0; j < [self.collectionView numberOfItemsInSection:i]; j++)
        {
            CGRect cellFrame;
            if(j == 0)
                cellFrame = CGRectMake(cell_Width * i + (i+1),0,cell_Width,cell_Height/2);
            else if(i == 0)
                cellFrame = CGRectMake(cell_Width * i + (i+1),cell_Height * (j-1) + cell_Height/2 + j,cell_Width,cell_Height);
            else {
                cellFrame = CGRectMake(cell_Width * i + (i+1),cell_Height * (j-1) + cell_Height/2 + j,cell_Width,cell_Height);
                
                NSArray* list = stellarData[@"list"];
                NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF['day'] == %@",weekTag[i - 1]];
                NSArray* dayTemp = [list filteredArrayUsingPredicate:filter];
                if([dayTemp count] > 0) {
                    NSArray* dayCourse = dayTemp[0][@"course"];
                    filter = [NSPredicate predicateWithFormat:@"SELF['time'] == %d",j];
                    NSArray* classOri = [dayCourse filteredArrayUsingPredicate:filter];
                    if([classOri count] > 0) {
                        filter = [NSPredicate predicateWithFormat:@"SELF['time'] == %d",j - 1];
                        NSArray* classPre = [dayCourse filteredArrayUsingPredicate:filter];
                        if([classPre count] > 0) {
                            if([classOri[0][@"name"] isEqualToString:classPre[0][@"name"]]) {
                                cellFrame = CGRectMake(0,0,0,0);
                            }
                        }
                        else {
                            int cellSize = 1;
                            filter = [NSPredicate predicateWithFormat:@"SELF['name'] == %@",classOri[0][@"name"]];
                            NSArray* sameNameClass = [dayCourse filteredArrayUsingPredicate:filter];
                            filter = [NSPredicate predicateWithFormat:@"SELF['time'] == %d",j + cellSize];
                            NSArray* nextTemp = [sameNameClass filteredArrayUsingPredicate:filter];
                            while([nextTemp count] > 0) {
                                cellSize++;
                                filter = [NSPredicate predicateWithFormat:@"SELF['time'] == %d",j + cellSize];
                                nextTemp = [sameNameClass filteredArrayUsingPredicate:filter];
                            }
                            cellFrame = CGRectMake(cell_Width * i + (i+1),cell_Height * (j-1) + cell_Height/2 + j,cell_Width,cell_Height*cellSize + (cellSize-1));
                        }
                    }
                }
            }
            
            
            //see if the collection view needs this cell
            if(CGRectIntersectsRect(cellFrame, rect))
            {
                //create the attributes object
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                
                //set the frame for this attributes object
                attr.frame = cellFrame;
                [elementsInRect addObject:attr];
            }
        }
    }

    
    return elementsInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}


@end
