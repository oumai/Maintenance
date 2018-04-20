//
//  KMMClassCell.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMClassCell.h"
#import "UIButton+ImageTitleSpacing.h"
#import "KMMClassToolView.h"
@implementation KMMClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.classImage.clipsToBounds = YES;
    self.classImage.layer.borderWidth = 1;
    self.classImage.layer.borderColor = UIColorFromHEX(0Xe0e0e0, 1).CGColor;
    self.classImage.layer.cornerRadius = 5;
    
    // Initialization code
    self.classTitle.font = [UIFont systemFontOfSize:15];
    self.classTitle.textColor = UIColorFromHEX(0X333333, 1);
    
    self.typeLb.font = [UIFont systemFontOfSize:13];
    self.typeLb.textColor = UIColorFromHEX(0X999999, 1);
    
    self.classSubTitle.font = [UIFont systemFontOfSize:13];
    self.classSubTitle.textColor = UIColorFromHEX(0X999999, 1);
    
    self.backView = [[KMMClassToolView alloc]init];
    WEAK_SELF(self);
    [self.backView setToolsViewBlock:^(NSInteger tag){
        STRONG_SELF(self);
        if ([self.delegate respondsToSelector:@selector(KMMClassCellDelegateEditClassWithType: pathRow:)]) {
            [self.delegate KMMClassCellDelegateEditClassWithType:tag pathRow:self.pathRow];
        }
    }];
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.bottom.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.classImage.mas_right).offset(0);
        make.height.mas_equalTo(40);
        
    }];
    
    self.reverseBtn = [[UIButton alloc]init];
    [self addSubview:self.reverseBtn];
    
    [self.reverseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(45);
    }];
    self.reverseBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.reverseBtn setTitleColor:BASE_COLOR forState:UIControlStateHighlighted];
//    [self.reverseBtn setTitle:@"撤销审核" forState:UIControlStateNormal];
    [self.reverseBtn setTitleColor:UIColorFromHEX(0X999999, 1) forState:UIControlStateNormal];
    [self.reverseBtn setImage:[UIImage imageNamed:@"icon-nor-cxsh"] forState:UIControlStateNormal];
    [self.reverseBtn setImage:[UIImage imageNamed:@"icon-per-cxsh"] forState:UIControlStateHighlighted];
  //  [self.reverseBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
    [self.reverseBtn addTarget:self action:@selector(reverseBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.undercarriage = [[UIButton alloc]init];
    [self addSubview:self.undercarriage];
    
    [self.undercarriage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(45);
    }];
    self.undercarriage.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.undercarriage setTitleColor:BASE_COLOR forState:UIControlStateHighlighted];
//    [self.undercarriage setTitle:@"下架" forState:UIControlStateNormal];
    [self.undercarriage setTitleColor:UIColorFromHEX(0X999999, 1) forState:UIControlStateNormal];
    [self.undercarriage setImage:[UIImage imageNamed:@"icon-nor-xj"] forState:UIControlStateNormal];
    [self.undercarriage setImage:[UIImage imageNamed:@"icon-per-xj"] forState:UIControlStateHighlighted];
  //  [self.undercarriage layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
    [self.undercarriage addTarget:self action:@selector(undercarriageAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.catagoryLb = [[UILabel alloc]init];
    self.catagoryLb.textAlignment = NSTextAlignmentCenter;
    self.catagoryLb.font = [UIFont systemFontOfSize:13];
    self.catagoryLb.textColor = BASE_COLOR;
    [self.contentView addSubview:self.catagoryLb];
    
    self.catagoryLb.clipsToBounds = YES;
    self.catagoryLb.layer.cornerRadius = 3;
    self.catagoryLb.layer.borderColor = BASE_COLOR.CGColor;
    self.catagoryLb.layer.borderWidth = 1;


    [self.catagoryLb mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.classImage.mas_right).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
//        make.width.mas_equalTo(SCREEN_WIDTH - 255);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(25);
    }];
    
    self.playImage = [[UIImageView alloc]init];
    self.playImage.image = [UIImage imageNamed:@"icon-sppp"];
    [self.classImage addSubview:self.playImage];
    
    [self.playImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        STRONG_SELF(self);
        make.centerX.equalTo(self.classImage.mas_centerX);
        make.centerY.equalTo(self.classImage.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    

    [self setBottomBorderWithColor:BASE_BACKGROUND_COLOR width:SCREEN_WIDTH height:0];
}

- (void)reverseBtnAction {

    if ([self.delegate respondsToSelector:@selector(KMMClassCellDelegateReverseClass:)]) {
        [self.delegate KMMClassCellDelegateReverseClass:self.pathRow];
    }

}

- (void)undercarriageAction {
    

    if ([self.delegate respondsToSelector:@selector(KMMClassCellDelegateundercarriageClass:)]) {
        [self.delegate KMMClassCellDelegateundercarriageClass:self.pathRow];
    }
}


- (void)setClassDataModel:(ClassData *)classDataModel {

    _classDataModel = classDataModel;
    
    
    
    if ([classDataModel.Auditing isEqualToString:@"1"] || [classDataModel.Auditing isEqualToString:@"2"]) {
        
        if ([classDataModel.Auditing isEqualToString:@"1"] ) {
            self.backView.hidden = YES;
            self.undercarriage.hidden = YES;
            self.reverseBtn.hidden = NO;
            self.typeLb.text = @"审核中";
        }
       
        
        if ([classDataModel.Auditing isEqualToString:@"2"]) {
            self.backView.hidden = YES;
            self.reverseBtn.hidden = YES;
            self.undercarriage.hidden = NO;
            self.typeLb.text = @"已发布";
        }
    }else {
        self.reverseBtn.hidden = YES;
        self.undercarriage.hidden = YES;
        self.backView.hidden = NO;
        self.typeLb.text = @"草稿箱";
    }
    
    if ([classDataModel.CourseType integerValue]>13) {
        self.playImage.hidden = NO;
    }else {
        self.playImage.hidden = YES;
    }
    
    
    CGFloat courseCategoryWidth = [Tools calculateWidthWithText:classDataModel.CourseCategoryAlias height:30 font:[UIFont systemFontOfSize:13]];
    [self.catagoryLb mas_updateConstraints:^(MASConstraintMaker *make) {

        make.width.mas_equalTo(courseCategoryWidth+10);
        
    }];
    
    self.catagoryLb.text = classDataModel.CourseCategoryAlias;
    self.classTitle.text = classDataModel.CourseTitle;
    self.classSubTitle.text = classDataModel.CourseDesc;
    [self.classImage sd_setImageWithURL:[NSURL URLWithString:classDataModel.Poster]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
