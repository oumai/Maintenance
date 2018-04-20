//
//  KMMDataVerificationController.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMDataVerificationController.h"
#import "KMMFillPersonDetailController.h"

@interface KMMDataVerificationController ()

@property (nonatomic,strong) KMMPerson *personModel;

@property (nonatomic,strong) UIButton *clickBtn;

@end

@implementation KMMDataVerificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
    

}

- (void)getTeacherDetial {
    

    [HTTPTool requestWithURLString:@"/api/Teacher/Profile" parameters:nil type:kGET success:^(id responseObject) {


        self.clickBtn.enabled = YES;
        self.personModel = [KMMPerson mj_objectWithKeyValues:responseObject];
        if ([self.personModel.Data.Sex isEqualToString:@"1"]) {
            self.personModel.Data.Sex = @"男";
        }else {
            self.personModel.Data.Sex = @"女";
        }
    } failure:^(NSError *error) {
        self.clickBtn.enabled = NO;

    }];
}

- (void)pageLayout {

    self.view.backgroundColor = UIColorFromHEX(0Xf5f5f5, 1);
    self.title = @"资料审核";
    
    UIScrollView *backScroView = [[UIScrollView alloc]init];
    [backScroView setContentSize:CGSizeMake(0, SCREEN_HEIGHT + 100)];
    [self.view addSubview:backScroView];
    
    WEAK_SELF(self);
    [backScroView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.top.equalTo(self.view).offset(0);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    
    
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [backScroView addSubview:grayView];

    
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"img-shz"];
    [grayView addSubview:img];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(grayView.mas_centerX).offset(15);
        make.width.mas_equalTo(183.5);
        make.height.mas_equalTo(186.5);
        make.top.equalTo(grayView.mas_top).offset(59);
    }];
    
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.textColor = UIColorFromHEX(0X333333, 1);
    titleLb.font = [UIFont systemFontOfSize:20];
    titleLb.text = @"资料提交成功!";
    titleLb.textAlignment = NSTextAlignmentCenter;
    [grayView addSubview:titleLb];
    
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(grayView).offset(0);
        make.top.equalTo(img.mas_bottom).offset(55);
    }];
    
    UILabel *subLb = [[UILabel alloc]init];
    subLb.textColor = UIColorFromHEX(0X999999, 1);
    subLb.font = [UIFont systemFontOfSize:15];
    subLb.text = @"管理员会在3个工作日内完成审核,审核结果会短信通知到您的注册手机";
    subLb.numberOfLines = 0;
    [grayView addSubview:subLb];
    
    [subLb mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(titleLb.mas_bottom).offset(30);
        make.left.equalTo(grayView.mas_left).offset(10);
        make.right.equalTo(grayView.mas_right).offset(-10);
        
    }];
    
    self.clickBtn = [[UIButton alloc]init];
    self.clickBtn.enabled = NO;
    [self.clickBtn setTitle:@"重新填写资料" forState:UIControlStateNormal];
    [self.clickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.clickBtn.backgroundColor = BASE_COLOR;
    self.clickBtn.clipsToBounds = YES;
    self.clickBtn.layer.cornerRadius = 5;
    self.clickBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.clickBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:self.clickBtn];
    
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(subLb.mas_bottom).offset(40);
        make.left.equalTo(grayView.mas_left).offset(10);
        make.right.equalTo(grayView.mas_right).offset(-10);
        make.height.mas_equalTo(50);
    }];
    
    
    [self getTeacherDetial];

}


- (void)popAction {
    
    KMMFillPersonDetailController *fillPersonVC = [[KMMFillPersonDetailController alloc]init];
    fillPersonVC.isCanEdit = YES;
    fillPersonVC.personModel = self.personModel.Data;
    fillPersonVC.isUpdate = YES;
    [self.navigationController pushViewController:fillPersonVC animated:YES];

}
@end
