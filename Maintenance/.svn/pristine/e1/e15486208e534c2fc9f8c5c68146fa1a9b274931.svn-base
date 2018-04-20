//
//  KMMFeedFooterCell.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/7.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMFeedFooterCell.h"

@implementation KMMFeedFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.clickBtn.backgroundColor = BASE_COLOR;
    self.clickBtn.clipsToBounds = YES;
    self.clickBtn.layer.cornerRadius = 5;
    
    self.oneLb.textColor = UIColorFromHEX(0X666666, 1);
    self.threeLb.textColor = UIColorFromHEX(0X666666, 1);
    self.twoLb.textColor = UIColorFromHEX(0X666666, 1);

    
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"客服邮箱: service@kmhealthcloud.com"];
    
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                                      value:BASE_COLOR
         
                                      range:NSMakeRange(5, AttributedStr.string.length - 5)];
    
    self.twoLb.attributedText = AttributedStr;
    
    NSMutableAttributedString *AttributedStrTwo = [[NSMutableAttributedString alloc]initWithString:@"电话: 4008886158转1 (工作日9:30-17:30)"];
    
    [AttributedStrTwo addAttribute:NSForegroundColorAttributeName
     
                          value:BASE_COLOR
     
                          range:NSMakeRange(3, 13)];
    
    self.threeLb.attributedText = AttributedStrTwo;

    
}
- (IBAction)clickAction:(id)sender {
    
    if (self.clickBtnBlock) {
        self.clickBtnBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
