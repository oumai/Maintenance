//
//  BATMyFindEqualCellFlowLayout.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyFindEqualCellFlowLayout.h"


@interface BATMyFindEqualCellFlowLayout()
@property (nonatomic, strong) NSMutableArray *itemAttributes;
@end

@implementation BATMyFindEqualCellFlowLayout
- (id)init
{
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = 20;
        self.minimumLineSpacing = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
        
    }
    
    return self;
}

#pragma mark - Methods to Override
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //使用系统帮我们计算好的结果。
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    //第0个cell没有上一个cell，所以从1开始
    for(int i = 1; i < [attributes count]; ++i) {
        //这里 UICollectionViewLayoutAttributes 的排列总是按照 indexPath的顺序来的。
        UICollectionViewLayoutAttributes *curAttr = attributes[i];
        UICollectionViewLayoutAttributes *preAttr = attributes[i-1];
        
        NSInteger origin = CGRectGetMaxX(preAttr.frame);
        //根据  maximumInteritemSpacing 计算出的新的 x 位置
        CGFloat targetX = origin + _maximumInteritemSpacing;
        if (targetX>300) {
            targetX = 299;
        }
        // 只有系统计算的间距大于  maximumInteritemSpacing 时才进行调整
        if (CGRectGetMinX(curAttr.frame) > targetX) {
            // 换行时不用调整
            if (targetX + CGRectGetWidth(curAttr.frame) < self.collectionViewContentSize.width) {
                CGRect frame = curAttr.frame;
                frame.origin.x = targetX;
                curAttr.frame = frame;
            }
        }
    }
    
  //  UICollectionViewLayoutAttributes *layoutAttributes = attributes.lastObject;
 //    [[NSNotificationCenter defaultCenter] postNotificationName:@"SENDHEIGHT" object:@(layoutAttributes.frame.origin.y + 42.5)];
    
    return attributes;
}



@end
