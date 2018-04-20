//
//  BATLoginViewController.m
//  Maintenance
//
//  Created by kmcompany on 2017/5/31.
//  Copyright © 2017年 KM. All rights reserved.
//

//Controller
#import "KMMLoginViewController.h"
#import "KMMRegisterViewController.h"
#import "KMMForgottenViewController.h"
#import "KMMDataVerificationController.h"
#import "KMMFillPersonDetailController.h"
#import "KMMTabBarController.h"

#import "CYTabBarController.h"
#import "KMMeViewController.h"
#import "KMMHomeViewController.h"

#import "Tools.h"
//model
#import "KMMPerson.h"

//cell
#import "KMMLoginCell.h"


@interface KMMLoginViewController ()<UITableViewDelegate,UITableViewDataSource,KMMLoginCellDelegate>

@property (nonatomic,strong) UITableView *loginTab;


@property (nonatomic,strong) NSString *phoneString;
@end

@implementation KMMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self pageLayout];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)pageLayout {
    self.phoneString = [[NSUserDefaults standardUserDefaults] valueForKey:@"LOGIN_NAME"];
    [self.view addSubview:self.loginTab];
    [self.loginTab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    KMMLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMLoginCell"];
    cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.row == 0) {
        cell.textfiled.placeholder = @"手机号";
        cell.eyeImage.hidden = YES;
        cell.headImage.image = [UIImage imageNamed:@"icon-nor-sjh"];
        cell.textfiled.secureTextEntry = NO;
        cell.textfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.textfiled.keyboardType = UIKeyboardTypeNumberPad;


        if (self.phoneString != nil) {
            cell.textfiled.text = self.phoneString;
        }
        
        if (![self.phoneString isEqualToString:@""]) {
            cell.textfiled.text = self.phoneString;
        }
        [cell.textfiled mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.right.equalTo(cell.contentView.mas_right).offset(-20);
        }];
        
    }else {
        cell.eyeImage.hidden = NO;
        cell.headImage.image = [UIImage imageNamed:@"icon-nor-mm"];
        cell.textfiled.placeholder = @"密码";
        cell.textfiled.secureTextEntry = YES;
        cell.textfiled.clearButtonMode = UITextFieldViewModeNever;
        cell.textfiled.keyboardType = UIKeyboardTypeDefault;
        [cell.textfiled mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(cell.contentView.mas_right).offset(-45);
        }];
        
    }
    return cell;
}

#pragma makr - KMMLoginCellDelegate
- (void)KMMLoginCellDelegateEyeAction:(BOOL)isShowPassword rowPaht:(NSIndexPath *)RowPaht {

    KMMLoginCell * passwordCell = (KMMLoginCell *)[self.loginTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    passwordCell.textfiled.secureTextEntry = isShowPassword;
    
}

#pragma mark - FootterView
- (UIView *)footerView {

    UIView *footerWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    footerWhiteView.backgroundColor = [UIColor whiteColor];
    
    UIButton *loginBtn = [[UIButton alloc]init];
    loginBtn.clipsToBounds = YES;
    loginBtn.layer.cornerRadius = 5;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.backgroundColor = BASE_COLOR;
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [footerWhiteView addSubview:loginBtn];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(footerWhiteView.mas_top).offset(25);
        make.left.equalTo(footerWhiteView.mas_left).offset(10);
        make.right.equalTo(footerWhiteView.mas_right).offset(-10);
        make.height.mas_equalTo(45);
    }];
    
    UIButton *registerBtn = [[UIButton alloc]init];
    registerBtn.clipsToBounds = YES;
    registerBtn.layer.cornerRadius = 5;
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [registerBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    registerBtn.backgroundColor = UIColorFromHEX(0Xf5f5f5, 1);
    [registerBtn setTitleColor:UIColorFromHEX(0X333333, 1) forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [footerWhiteView addSubview:registerBtn];
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(loginBtn.mas_bottom).offset(10);
        make.left.equalTo(footerWhiteView.mas_left).offset(10);
        make.right.equalTo(footerWhiteView.mas_right).offset(-10);
        make.height.mas_equalTo(45);
    }];
    
    UIButton *forgottenBtn = [[UIButton alloc]init];
    [forgottenBtn setTitleColor:UIColorFromHEX(0X999999, 1) forState:UIControlStateNormal];
//    [forgottenBtn sizeToFit];
    forgottenBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [forgottenBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    forgottenBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    forgottenBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [forgottenBtn addTarget:self action:@selector(forgottenAction) forControlEvents:UIControlEventTouchUpInside];
    [footerWhiteView addSubview:forgottenBtn];
    
    [forgottenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(registerBtn.mas_bottom).offset(10);
        make.right.equalTo(footerWhiteView.mas_right).offset(-10);
        
        
    }];
    
    return footerWhiteView;
    
}

#pragma mark - 忘记密码点击事件
- (void)forgottenAction {
    
    NSString *phoneStrig = nil;
    
    KMMLoginCell *phoeNumCell = (KMMLoginCell *)[self.loginTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([Tools checkPhoneNumber:phoeNumCell.textfiled.text]) {
        phoneStrig = phoeNumCell.textfiled.text;
    }else {
        phoneStrig = @"";
    }
    
    KMMForgottenViewController *forgottenVC = [[KMMForgottenViewController alloc]init];
    forgottenVC.phoneNum = phoneStrig;
    [self.navigationController pushViewController:forgottenVC animated:YES];
}

//登录事件
- (void)loginAction {
    
    
    KMMLoginCell * phoneCell = (KMMLoginCell *)[self.loginTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *phoneString = phoneCell.textfiled.text;
    if ([phoneString isEqualToString:@""] || phoneString == nil) {
        [self showText:@"请输入手机号码"];
        return;
    }
    
    if (![Tools checkPhoneNumber:phoneString]) {
        [self showText:@"请输入正确的手机号码"];
        return;
    }
    
    KMMLoginCell *passwordCell = (KMMLoginCell *)[self.loginTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *passwordString = passwordCell.textfiled.text;
    
    if ([passwordString isEqualToString:@""] || passwordString == nil) {
        [self showText:@"请输入密码"];
        return;
    }
    
    [self showProgressWithText:@"正在登录"];
    [HTTPTool requestWithURLString:@"/api/account/login" parameters:@{@"Mobile":phoneString,@"Password":passwordString} type:kPOST success:^(id responseObject) {
        
        if ([responseObject[@"ResultCode"] integerValue] == 1) {
            [self dismissProgress];
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该手机号尚未注册！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"重新填写" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                KMMRegisterViewController *fillPerson = [[KMMRegisterViewController alloc]init];
                [self.navigationController pushViewController:fillPerson animated:YES];
            }];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        if ([responseObject[@"ResultCode"] integerValue] == 2) {
            [self showText:@"密码不正确"];
            return;
        }
       
        [self dismissProgress];
        SET_LOGIN_STATION(YES);
        //保存手机号码
         [[NSUserDefaults standardUserDefaults] setValue:phoneString forKey:@"LOGIN_NAME"];
       
        KMMPerson *person = [KMMPerson mj_objectWithKeyValues:responseObject];
        [[NSUserDefaults standardUserDefaults] setObject:person.Data.Token forKey:@"Token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        BOOL audist_station = [person.Data.HasProfile boolValue];
        SET_Audist_STATION(audist_station);
        NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"];
        [NSKeyedArchiver archiveRootObject:person toFile:file];
        
        if ([person.Data.AccountType isEqualToString:@"0"]) {
           
            
            if ([person.Data.AuditState isEqualToString:@"0"]) {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否去填写认证资料?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    KMMFillPersonDetailController *fillPerson = [[KMMFillPersonDetailController alloc]init];
                    fillPerson.isCanEdit = YES;
                    [self.navigationController pushViewController:fillPerson animated:YES];
                }];
                [alert addAction:cancelAction];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            if ([person.Data.AuditState isEqualToString:@"1"] || [person.Data.AuditState isEqualToString:@"3"]) {
                
                KMMDataVerificationController *dataVerVC = [[KMMDataVerificationController alloc]init];
                [self.navigationController pushViewController:dataVerVC animated:YES];
                return;
            }
        }
        
        if ([person.Data.AccountType isEqualToString:@"1"]) {
            if ([person.Data.HasProfile isEqualToString:@"0"]) {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否去填写认证资料?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    KMMFillPersonDetailController *fillPerson = [[KMMFillPersonDetailController alloc]init];
                    fillPerson.isCanEdit = YES;
                    [self.navigationController pushViewController:fillPerson animated:YES];
                }];
                [alert addAction:cancelAction];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            if ([person.Data.HasProfile isEqualToString:@"1"]) {
                [self showSuccessWithText:@"登录成功"];
//                CYTabBarController * tabbar = [[CYTabBarController alloc]init];
//                /**
//                 *  配置外观
//                 */
//                [CYTabBarConfig shared].selectedTextColor = BASE_COLOR;
//                //    [CYTabBarConfig shared].textColor = [UIColor redColor];
//                //    [CYTabBarConfig shared].backgroundColor = [UIColor greenColor];
//                [CYTabBarConfig shared].selectIndex = 0;
//                
//                UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:[KMMHomeViewController new]];
//                [tabbar addChildController:nav1 title:@"课程" imageName:@"icon-nor-kc" selectedImageName:@"icon-pre-kc"];
//                UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:[KMMeViewController new]];
//                [tabbar addChildController:nav2 title:@"我的" imageName:@"icon-nor-Center" selectedImageName:@"icon-pre-wd"];
//                [tabbar addCenterController:nil bulge:YES title:@"" imageName:@"icon-fb" selectedImageName:@"icon-fb"];
                
                KMMTabBarController *tabbar = [[KMMTabBarController alloc]init];
                [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
                
            }
        }
       
        
    } failure:^(NSError *error) {
        [self showErrorWithText:@"网络开小差了\n请检查后重试"];
    }];

}
//注册事件
- (void)registerAction {

    KMMRegisterViewController *registerVC = [[KMMRegisterViewController alloc]init];
 //   UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:registerVC];
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - HeaderView 
- (UIView *)tableHeader {

    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"icon-194"];
    [whiteView addSubview:img];
    

    [img mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.centerY.equalTo(whiteView);
        make.width.height.mas_equalTo(80);
        
    }];
    
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.textColor = UIColorFromHEX(0X282878, 1);
    titleLb.font = [UIFont systemFontOfSize:17];
    titleLb.text = @"养护师讲师版";
    titleLb.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:titleLb];
    
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(img.mas_bottom).offset(5);
        make.left.right.equalTo(whiteView).offset(0);
        
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    [whiteView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.right.left.equalTo(whiteView);
        make.height.mas_equalTo(1);
        
    }];
    
    return whiteView;
}

#pragma mark - lazy Load
- (UITableView *)loginTab {

    if (!_loginTab) {
        _loginTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _loginTab.tableHeaderView = [self tableHeader];
        _loginTab.tableFooterView = [self footerView];
        _loginTab.delegate = self;
        _loginTab.dataSource = self;
        [_loginTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_loginTab registerNib:[UINib nibWithNibName:@"KMMLoginCell" bundle:nil] forCellReuseIdentifier:@"KMMLoginCell"];
        _loginTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _loginTab;
}

@end
