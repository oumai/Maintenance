//
//  KMMAoutUsView.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/5.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMAoutUsView.h"

@implementation KMMAoutUsView

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.mainlb.textColor = UIColorFromHEX(0X666666, 1);
    self.subLb.textColor = UIColorFromHEX(0X666666, 1);
    
    self.versionLb.textColor = UIColorFromHEX(0X666666, 1);
    
    self.mainlb.text = @"养护师,护理考证专业平台。\n作为讲师,你可以发布与管理护理课程,并与全国医护学员进行交流。";
}

@end
