//
//  KMMCustomButton.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/7.
//  Copyright © 2017年 KM. All rights reserved.
//
#define kTitleRatio 10
#import "KMMCustomButton.h"

@implementation KMMCustomButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
//    if (!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero)) {
//        return self.titleRect;
//    }
//    return [super titleRectForContentRect:contentRect];
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleWidth = contentRect.size.width;
    CGFloat titleHeight = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
//    if (!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero)) {
//        return self.imageRect;
//    }
//    return [super imageRectForContentRect:contentRect];
    CGFloat imageX = contentRect.size.width;
    CGFloat imageY = 0;
    CGFloat imageWidth = contentRect.size.width;
    CGFloat imageHeight = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

@end
