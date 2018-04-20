//
//  KMMVideoTitleReusableView.m
//  videoTest
//
//  Created by kmcompany on 2017/6/30.
//  Copyright © 2017年 kmcompany. All rights reserved.
//

#import "KMMVideoTitleReusableView.h"

@implementation KMMVideoTitleReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = UIColorFromHEX(0X333333, 1);
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
      
//        UIView * line = [[UIView alloc] init];
//        line.backgroundColor = [UIColor grayColor];
//        [self addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.mas_bottom);
//            make.centerX.equalTo(self.mas_centerX);
//            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 1));
//        }];
        
    }
    return self;
}
@end
