//
//  KMMMailCell.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/7.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMMailCell.h"

@implementation KMMMailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textfield.backgroundColor = BASE_BACKGROUND_COLOR;
    
    [self.textfield addTarget:self action:@selector(textfiledDidChanged:) forControlEvents:UIControlEventEditingChanged];
//    self.textfield.layer.borderWidth = 0.5;
//    self.textfield.layer.borderColor = UIColorFromHEX(0X999999, 1).CGColor;
    
}

- (void)textfiledDidChanged:(UITextField *)textField {

    if ([self.delegate respondsToSelector:@selector(KMMMailCellTextFieldDidChange:)]) {
        [self.delegate KMMMailCellTextFieldDidChange:textField];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
