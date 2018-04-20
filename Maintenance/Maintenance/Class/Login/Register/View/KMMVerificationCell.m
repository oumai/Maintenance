//
//  KMMVerificationCell.m
//  Maintenance
//
//  Created by kmcompany on 2017/5/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMVerificationCell.h"

@implementation KMMVerificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.verificationBtn.clipsToBounds = YES;
    self.verificationBtn.backgroundColor = BASE_COLOR;
    self.verificationBtn.layer.cornerRadius = 15;
    self.verificationBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.verificationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.verificationBtn addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    
    self.textfiled.textColor = UIColorFromHEX(0X333333, 1);
    self.textfiled.font = [UIFont systemFontOfSize:16];
    
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.right.left.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(1);
        
    }];
}

- (void)getVerificationCode {
    
    if ([self.delegate respondsToSelector:@selector(KMMVerificationCellVerificationAction:)]) {
        [self.delegate KMMVerificationCellVerificationAction:self];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
