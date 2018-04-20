//
//  KMMFeedBackContentCell.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/7.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMFeedBackContentCell.h"

@interface KMMFeedBackContentCell()<UITextViewDelegate>

@end

@implementation KMMFeedBackContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLb.textColor = UIColorFromHEX(0X666666, 1);
    self.textView.backgroundColor = BASE_BACKGROUND_COLOR;
    self.textView.delegate = self;
}

- (void)textViewDidChange:(UITextView *)textView {

    if ([self.delegate respondsToSelector:@selector(KMMFeedBackContentCellTextViewDidChange:)]) {
        [self.delegate KMMFeedBackContentCellTextViewDidChange:textView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
