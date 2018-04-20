//
//  KMMVideoImageCell.m
//  Maintenance
//
//  Created by kmcompany on 2017/7/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMVideoImageCell.h"

@implementation KMMVideoImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        WEAK_SELF(self);
        
        
        self.backView = [[UIView alloc]init];
        [self.contentView addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.edges.equalTo(self.contentView);
            
        }];
        
        
        self.posterImage = [[UIImageView alloc]init];
        [self.backView addSubview:self.posterImage];
        [self.posterImage mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.left.top.equalTo(self.backView).offset(2);
            make.right.equalTo(self.backView.mas_right).offset(-2);
            make.bottom.equalTo(self.backView.mas_bottom).offset(-2);
        }];
    
    }
    
    return self;
}

- (void)setModel:(KMMImageInfoModel *)model {

    _model = model;
    self.posterImage.image = model.VideoImage;
    if (model.isSelect) {
        self.backView.backgroundColor = UIColorFromRGB(40, 42, 116, 1);
    }else {
        self.backView.backgroundColor = [UIColor whiteColor];
    }
}

@end
