//
//  KMMCompletContentCell.m
//  Maintenance
//
//  Created by kmcompany on 2017/7/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMCompletContentCell.h"

@interface KMMCompletContentCell()<YYTextViewDelegate>

@end

@implementation KMMCompletContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        WEAK_SELF(self);
        
        self.titleLb = [[UILabel alloc]init];
        self.titleLb.font = [UIFont systemFontOfSize:15];
        self.titleLb.textColor = UIColorFromHEX(0X333333, 1);
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.top.equalTo(self.contentView).offset(10);
            make.width.mas_equalTo(70);
            
        }];
        
        self.yyTextView = [[YYTextView alloc]initWithFrame:CGRectMake(90, 0, SCREEN_WIDTH-90, 124)];
        self.yyTextView.delegate = self;
        self.yyTextView.font = [UIFont systemFontOfSize:15];
        self.yyTextView.textColor = UIColorFromHEX(0X333333, 1);
        self.yyTextView.textContainerInset =  UIEdgeInsetsMake(10,0,0,0);
        
        [self.contentView addSubview:self.yyTextView];
        
        [self setBottomBorderWithColor:BASE_BACKGROUND_COLOR width:SCREEN_WIDTH height:0];
    }
    return self;
}

- (void)textViewDidChange:(YYTextView *)textView {

    if ([self.delegate respondsToSelector:@selector(KMMCompletContentCellWithContent:)]) {
        [self.delegate KMMCompletContentCellWithContent:textView];
    }
}


@end
