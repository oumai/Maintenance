//
//  KMMSizeTipsView.m
//  Maintenance
//
//  Created by kmcompany on 2017/7/14.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMSizeTipsView.h"

@implementation KMMSizeTipsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)cancelAction:(id)sender {
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
}
- (IBAction)reloadAction:(id)sender {
    
    if (self.reloadBlock) {
        self.reloadBlock();
    }
    
}

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.blackBackground.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.blackBackground.backgroundColor = [UIColor clearColor];
    
    self.tipsView.clipsToBounds = YES;
    self.tipsView.layer.cornerRadius = 5;
    
    self.titleLb.text = @"文件过大\n上传的视频大小不得超过80M,\n请重新拍摄视频进行上传";
    
    
    
    
}

@end
