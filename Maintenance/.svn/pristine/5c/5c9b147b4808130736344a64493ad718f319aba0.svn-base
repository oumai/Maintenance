//
//  KMMLoginCell.m
//  Maintenance
//
//  Created by kmcompany on 2017/5/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMLoginCell.h"

@implementation KMMLoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    
    [self.contentView addSubview:lineView];
    
    WEAK_SELF(self);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        STRONG_SELF(self);
        make.bottom.right.left.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(1);
        
    }];
    
    self.textfiled.textColor = UIColorFromHEX(0X333333, 1);
    self.textfiled.font = [UIFont systemFontOfSize:16];
    [self.textfiled addTarget:self action:@selector(textfiledDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.eyeImage setImage:[UIImage imageNamed:@"icon-byj"] forState:UIControlStateNormal];
    [self.eyeImage setImage:[UIImage imageNamed:@"icon-yj"] forState:UIControlStateSelected];
    
    [self.eyeImage addTarget:self action:@selector(changeEyeStation:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)textfiledDidChange:(UITextField *)textField {

    if ([self.delegate respondsToSelector:@selector(KMMloginCellDelegateTextFieldDidChange: withRowPaht:)]) {
        [self.delegate KMMloginCellDelegateTextFieldDidChange:textField withRowPaht:self.path];
    }
}


- (void)changeEyeStation:(UIButton *)sender {
    
    UIButton *btn = (UIButton *)sender;
    if ([self.delegate respondsToSelector:@selector(KMMLoginCellDelegateEyeAction: rowPaht:)]) {
        [self.delegate KMMLoginCellDelegateEyeAction:btn.selected rowPaht:self.path];
    }
     btn.selected = !btn.selected;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
