//
//  KMMCourseFooterCell.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/13.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMCourseFooterCell.h"

@implementation KMMCourseFooterCell

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = BASE_BACKGROUND_COLOR;
       
        self.leftBtn = [[UIButton alloc]init];
        [self.leftBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
        [self.leftBtn setTitle:@"保存到草稿" forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.leftBtn.backgroundColor = [UIColor whiteColor];
          [self.contentView addSubview:self.leftBtn];
        self.leftBtn.tag = 0;
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.bottom.equalTo(self.contentView).offset(0);
            make.top.equalTo(self.contentView.mas_top).offset(1);
            make.height.mas_equalTo(41.5);
            make.width.mas_equalTo(150);
            
        }];
        
        [self.leftBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
       
        
        self.RightBtn = [[UIButton alloc]init];
        self.RightBtn.backgroundColor = [UIColor whiteColor];
        [self.RightBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
        [self.RightBtn setTitle:@"直接发布" forState:UIControlStateNormal];
        self.RightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.RightBtn.tag = 1;
         [self.contentView addSubview:self.RightBtn];
        [self.RightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView.mas_top).offset(1);
            make.left.equalTo(self.leftBtn.mas_right).offset(1);
            make.bottom.equalTo(self.contentView).offset(0);
            make.width.mas_equalTo(149);
            make.height.mas_equalTo(41.5);
            
        }];
        
        [self.RightBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)clickAction:(UIButton *)btn {
    
    if (btn.tag == 0) {
        if (self.clickBlock) {
            self.clickBlock(btn.tag,self.RightBtn);
            return;
        }
    }

    if (btn.tag == 1) {
        if (self.clickBlock) {
            self.clickBlock(btn.tag,self.leftBtn);
        }
    }
    
    
}

@end
