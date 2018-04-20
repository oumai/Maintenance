//
//  KMMNetTipsView.m
//  Maintenance
//
//  Created by kmcompany on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMNetTipsView.h"

@implementation KMMNetTipsView
- (IBAction)playAction:(id)sender {
    
    if (self.playBlock) {
        self.playBlock();
    }
    
    
}

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.backgroundColor = [UIColor blackColor];
    self.messageLb.textColor = [UIColor whiteColor];
    
    self.timeLb.textColor = [UIColor whiteColor];
    self.sizeLb.textColor = [UIColor whiteColor];
    
    self.clickBtn.clipsToBounds = YES;
    self.clickBtn.layer.cornerRadius = 5;
    [self.clickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.clickBtn.layer.borderWidth = 1;
    self.clickBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
}

@end
