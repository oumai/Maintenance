//
//  KMMSubContentCell.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/12.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMSubContentCell.h"

@interface KMMSubContentCell()<YYTextViewDelegate>

@end

@implementation KMMSubContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      //  WEAK_SELF(self);
        [self.contentView addSubview:self.yyText];
//        [self.yyText mas_makeConstraints:^(MASConstraintMaker *make) {
//            STRONG_SELF(self);
//            make.left.equalTo(self.contentView.mas_left).offset(10);
//            make.top.equalTo(self.contentView.mas_top).offset(10);
//            make.height.mas_equalTo(65);
//            
//        }];
        
        [self setBottomBorderWithColor:BASE_BACKGROUND_COLOR width:SCREEN_WIDTH height:0];
        
    }
    return self;
}

- (YYTextView *)yyText {

    if (!_yyText) {
        _yyText = [[YYTextView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 65)];
        _yyText.placeholderText = @"请输入简介";
        _yyText.placeholderFont = [UIFont systemFontOfSize:15];
    }
    return _yyText;
}

- (void)textViewDidChange:(YYTextView *)textView {
    
    
//    float textViewHeight =  [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)].height;
//    CGRect frame = textView.frame;
//    frame.size.height = textViewHeight;
//    textView.frame = frame;
    
    
    
}

@end
