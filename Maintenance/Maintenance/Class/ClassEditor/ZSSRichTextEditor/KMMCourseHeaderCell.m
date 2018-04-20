//
//  KMMCourseHeaderCell.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/13.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMCourseHeaderCell.h"

@implementation KMMCourseHeaderCell

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        UIImageView *img = [[UIImageView alloc]init];
        img.image = [UIImage imageNamed:@"icon-bq"];
        [self.contentView addSubview:img];
        
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        UILabel *lb = [[UILabel alloc]init];
        lb.textColor = UIColorFromHEX(0X010101, 1);
        lb.font = [UIFont systemFontOfSize:15];
        lb.text = @"请选择课程分类";
        [self.contentView addSubview:lb];
        
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(img.mas_right).offset(10);
        }];
        
        [self setBottomBorderWithColor:BASE_BACKGROUND_COLOR width:300 height:0];
    }
    return self;
}

@end
