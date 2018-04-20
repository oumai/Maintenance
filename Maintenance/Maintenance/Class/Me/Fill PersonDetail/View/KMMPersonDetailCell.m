//
//  KMMPersonDetailCell.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMPersonDetailCell.h"

@interface KMMPersonDetailCell()<UITextFieldDelegate>

@end

@implementation KMMPersonDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
    
    self.titleLb.font = [UIFont systemFontOfSize:14];
    self.titleLb.textAlignment = NSTextAlignmentLeft;
    
    self.textfiled.delegate = self;
    
    [self.textfiled addTarget:self action:@selector(textfiledDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textfiledDidChanged:(UITextField *)textfiled {
    
    if ([self.delegate respondsToSelector:@selector(KMMPersonDetailCellTextfiledDidChange:)]) {
        [self.delegate KMMPersonDetailCellTextfiledDidChange:textfiled];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
