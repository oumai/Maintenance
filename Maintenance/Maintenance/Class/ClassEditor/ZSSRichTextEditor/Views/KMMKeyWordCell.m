//
//  KMMKeyWordCell.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/13.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMKeyWordCell.h"

@implementation KMMKeyWordCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = BASE_BACKGROUND_COLOR.CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 5.f;
        
        [self.contentView addSubview:self.keyLabel];
        WEAK_SELF(self);
        [self.keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
     //   [self setBottomBorderWithColor:BASE_BACKGROUND_COLOR width:300 height:0];
    }
    return self;
}

- (UILabel *)keyLabel {
    if (!_keyLabel) {
         _keyLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _keyLabel;
}

@end
