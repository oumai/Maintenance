//
//  KMMCompletTitleCell.m
//  Maintenance
//
//  Created by kmcompany on 2017/7/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMCompletTitleCell.h"

@interface KMMCompletTitleCell()<UITextFieldDelegate>

@end

@implementation KMMCompletTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        WEAK_SELF(self);
        
        self.titleLb = [[UILabel alloc]init];
        self.titleLb.font = [UIFont systemFontOfSize:15];
        self.titleLb.textColor = UIColorFromHEX(0X333333, 1);
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(70);
            
        }];
        
        self.yyTextView = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, SCREEN_WIDTH-90, 43)];
        self.yyTextView.delegate = self;
        [self.yyTextView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
       // self.yyTextView.textContainerInset =  UIEdgeInsetsMake(10,0,0,0);
        self.yyTextView.font = [UIFont systemFontOfSize:15];
        self.yyTextView.textColor = UIColorFromHEX(0X333333, 1);
        [self.contentView addSubview:self.yyTextView];
        
        [self setBottomBorderWithColor:BASE_BACKGROUND_COLOR width:SCREEN_WIDTH height:0];
        
    }
    return self;
}

- (void)setPathRow:(NSIndexPath *)pathRow {

    _pathRow = pathRow;
    self.yyTextView.tag = pathRow.row;
}


- (void)textFieldDidChange:(UITextField *)textView {

    if ([self.delegate respondsToSelector:@selector(KMMCompletTitleCellWithContent:)]) {
        [self.delegate KMMCompletTitleCellWithContent:textView];
    }

}

@end
