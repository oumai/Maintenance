//
//  KMMClearMemoryCell.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/5.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMClearMemoryCell.h"

@implementation KMMClearMemoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLb.textColor = UIColorFromHEX(0X333333, 1);
    self.menoryLb.textColor = UIColorFromHEX(0X999999, 1);
    [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
