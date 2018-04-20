//
//  KMMWebIntroduceView.m
//  Maintenance
//
//  Created by kmcompany on 2017/7/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMWebIntroduceView.h"

@implementation KMMWebIntroduceView

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.upLabel.textColor = UIColorFromHEX(0X666666, 1);
    self.downLabel.textColor = UIColorFromHEX(0X666666, 1);
    
    
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"在电脑浏览器中打开养护师网站:\nwww.yanghushi.net"];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:BASE_COLOR
     
                          range:NSMakeRange(15, AttributedStr.string.length - 15)];
    
    self.upLabel.attributedText = AttributedStr;
    
    NSMutableAttributedString *AttributedStrTwo = [[NSMutableAttributedString alloc]initWithString:@"通过网站成功上传的课程\n会同步更新至养护师讲师版APP"];
    
    [AttributedStrTwo addAttribute:NSForegroundColorAttributeName
     
                             value:BASE_COLOR
     
                             range:NSMakeRange(13, 4)];
    
    self.downLabel.attributedText = AttributedStrTwo;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
