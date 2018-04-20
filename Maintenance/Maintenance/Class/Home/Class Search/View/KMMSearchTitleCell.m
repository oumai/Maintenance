//
//  KMMSearchTitleCell.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/5.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMSearchTitleCell.h"

@implementation KMMSearchTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLb.font = [UIFont systemFontOfSize:16];
    self.titleLb.textColor = UIColorFromHEX(0X333333, 1);
    
    [self setBottomBorderWithColor:BASE_BACKGROUND_COLOR width:SCREEN_WIDTH height:0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleModel:(ClassTitleData *)titleModel {

    _titleModel = titleModel;
    self.titleLb.text = titleModel.Title;
    
}

@end
