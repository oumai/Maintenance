//
//  KMMClassToolView.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/8.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMClassToolView.h"
#import "UIButton+ImageTitleSpacing.h"
@implementation KMMClassToolView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        UIButton *deleBtn = [[UIButton alloc]init];
        deleBtn.tag = 2;
        [self addSubview:deleBtn];
        
        [deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(45);
        }];
        deleBtn.titleLabel.font = [UIFont systemFontOfSize:11];
//        [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleBtn setTitleColor:UIColorFromHEX(0X999999, 1) forState:UIControlStateNormal];
        [deleBtn setTitleColor:BASE_COLOR forState:UIControlStateHighlighted];
        [deleBtn setImage:[UIImage imageNamed:@"icon-nor-sc"] forState:UIControlStateNormal];
        [deleBtn setImage:[UIImage imageNamed:@"icon-pre-sc"] forState:UIControlStateHighlighted];
       // [deleBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
        [deleBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *editBtn = [[UIButton alloc]init];
        editBtn.tag = 1;
        [self addSubview:editBtn];
        
        [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(deleBtn.mas_left).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(45);
        }];
        editBtn.titleLabel.font = [UIFont systemFontOfSize:11];
         [editBtn setTitleColor:BASE_COLOR forState:UIControlStateHighlighted];
//        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:UIColorFromHEX(0X999999, 1) forState:UIControlStateNormal];
        [editBtn setImage:[UIImage imageNamed:@"icon-nor-bj"] forState:UIControlStateNormal];
        [editBtn setImage:[UIImage imageNamed:@"icon-pre-bj"] forState:UIControlStateHighlighted];
     //   [editBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
        [editBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *savebtn = [[UIButton alloc]init];
        savebtn.tag = 0;
        [self addSubview:savebtn];
        
        [savebtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(editBtn.mas_left).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(45);
        }];
        savebtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [savebtn setTitleColor:BASE_COLOR forState:UIControlStateHighlighted];
//        [savebtn setTitle:@"提交审核" forState:UIControlStateNormal];
        [savebtn setTitleColor:UIColorFromHEX(0X999999, 1) forState:UIControlStateNormal];
        [savebtn setImage:[UIImage imageNamed:@"icon-nor-tjfhh"] forState:UIControlStateNormal];
        [savebtn setImage:[UIImage imageNamed:@"icon-nor-tjfhh"] forState:UIControlStateHighlighted];
     //   [savebtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
        [savebtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)clickAction:(UIButton *)btn {

//    for (id object in self.subviews) {
//        if ([object isKindOfClass:[UIButton class]]) {
//            UIButton *btn = (UIButton *)object;
//            btn.selected = NO;
//        }
//    }
//    if (btn.isSelected) {
//        btn.selected = NO;
//    }else {
//        btn.selected = YES;
//    }
    
    if (self.ToolsViewBlock) {
        self.ToolsViewBlock(btn.tag);
    }

}

@end
