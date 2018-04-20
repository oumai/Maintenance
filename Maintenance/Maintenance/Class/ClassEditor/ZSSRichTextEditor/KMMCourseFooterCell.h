//
//  KMMCourseFooterCell.h
//  Maintenance
//
//  Created by kmcompany on 2017/6/13.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMMCourseFooterCell : UICollectionViewCell

@property (nonatomic,strong) void (^clickBlock)(NSInteger tag,UIButton *btn);

@property (nonatomic,strong) UIButton *leftBtn;

@property (nonatomic,strong) UIButton *RightBtn;


@end
