//
//  KMMRegisterViewController.m
//  Maintenance
//
//  Created by kmcompany on 2017/5/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMRegisterViewController.h"
#import "KMMFillPersonDetailController.h"
//CELL
#import "KMMLoginCell.h"
#import "KMMVerificationCell.h"

@interface KMMRegisterViewController ()<UITableViewDelegate,UITableViewDataSource,KMMLoginCellDelegate,KMMVerificationCellDelegate>

@property (nonatomic,strong) UITableView *registerTab;

@property (nonatomic,strong) UIView *showView;

@end

@implementation KMMRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}



- (void)pageLayout {
 
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.registerTab];
    
    WEAK_SELF(self);
    [self.registerTab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    


    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KMMLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMLoginCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.row == 0) {
        cell.textfiled.placeholder = @"手机号";
        cell.eyeImage.hidden = YES;
        cell.headImage.image = [UIImage imageNamed:@"icon-pre-sjh"];
        cell.textfiled.secureTextEntry = NO;
        cell.textfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.textfiled.keyboardType = UIKeyboardTypeNumberPad;
        
        
        [cell.textfiled mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(cell.contentView.mas_right).offset(-20);
        }];
        
    }else if(indexPath.row == 2) {
        cell.eyeImage.hidden = NO;
        cell.headImage.image = [UIImage imageNamed:@"icon-nor-mm"];
        cell.textfiled.placeholder = @"密码";
        cell.textfiled.secureTextEntry = YES;
        cell.textfiled.clearButtonMode = UITextFieldViewModeNever;
        
        
        [cell.textfiled mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(cell.contentView.mas_right).offset(-45);
        }];
        
    }else {
        KMMVerificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMVerificationCell"];
        cell.delegate = self;
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textfiled.keyboardType = UIKeyboardTypeNumberPad;
        return cell;
    }
    return cell;
}

- (void)KMMLoginCellDelegateEyeAction:(BOOL)isShowPassword rowPaht:(NSIndexPath *)RowPaht {

    KMMLoginCell * phoneCell = (KMMLoginCell *)[self.registerTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    phoneCell.textfiled.secureTextEntry = isShowPassword;

}

#pragma mark - KMMVerificationCellDelegate
- (void)KMMVerificationCellVerificationAction:(KMMVerificationCell *)cell {

    KMMLoginCell * phoneCell = (KMMLoginCell *)[self.registerTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *phoneString = phoneCell.textfiled.text;
    if ([phoneString isEqualToString:@""] || phoneString == nil) {
        [self showText:@"请输入手机号码"];
        return;
    }
    
    if (![Tools checkPhoneNumber:phoneString]) {
        [self showText:@"请输入正确的手机号码"];
        return;
    }
    
    
    
    cell.verificationBtn.userInteractionEnabled = NO;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:phoneString forKey:@"mobile"];
    [dict setValue:@"1" forKey:@"valid"];
    
    
    [HTTPTool requestVerificationWithURLString:@"/api/account/postcodemsg" parameters:dict type:kGET success:^(id responseObject) {
         cell.verificationBtn.userInteractionEnabled = YES;
        NSInteger ResultCode = [responseObject[@"ResultCode"] integerValue];
        if (ResultCode == 5) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该手机已被注册" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.view endEditing:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *cancleaction = [UIAlertAction actionWithTitle:@"重新填写" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
               
            }];
            [alert addAction:okAction];
            [alert addAction:cancleaction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }

        
        if (ResultCode != 2 && ResultCode != 0) {
             cell.verificationBtn.userInteractionEnabled = YES;
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"温馨提示" message:responseObject[@"ResultMessage"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alter addAction:action];
            
            [self.navigationController presentViewController:alter animated:YES completion:^{
                
            }];
            
            return;
            
        }

        
        KMMVerificationCell *verifCell = (KMMVerificationCell *)[self.registerTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
        verifCell.verificationBtn.userInteractionEnabled = NO;
        verifCell.verificationBtn.backgroundColor = UIColorFromHEX(0Xf5f5f5, 1);
        [verifCell.verificationBtn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
        
        [Tools countdownWithTime:120 End:^{
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:@"获取验证码"];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 5)];
            verifCell.verificationBtn.titleLabel.attributedText = attributeStr;
            [verifCell.verificationBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
            
            verifCell.verificationBtn.backgroundColor = BASE_COLOR;
            verifCell.verificationBtn.userInteractionEnabled = YES;
        } going:^(NSString *time) {
            
            
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:time];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:BASE_COLOR range:NSMakeRange(6, time.length-7)];
            
            cell.verificationBtn.titleLabel.attributedText = attributeStr;
            [cell.verificationBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
            
            
        }];
        
        
       
        
    } failure:^(NSError *error) {
        cell.verificationBtn.userInteractionEnabled = YES;
    }];

    
    
    
}



//注册操作
- (void)registerAction {
    [self.view endEditing:YES];
    KMMLoginCell * phoneCell = (KMMLoginCell *)[self.registerTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *phoneString = phoneCell.textfiled.text;
    if ([phoneString isEqualToString:@""] || phoneString == nil) {
        [self showText:@"请输入手机号码"];
        return;
    }
    
    if (![Tools checkPhoneNumber:phoneString]) {
        [self showText:@"请输入正确的手机号码"];
        return;
    }
    
    
    KMMVerificationCell *verificationCell = (KMMVerificationCell *)[self.registerTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *verifString = verificationCell.textfiled.text;
    if ([verifString isEqualToString:@""] || verifString == nil) {
        [self showText:@"请输入验证码"];
        return;
    }
    
    KMMLoginCell * passwordCell = (KMMLoginCell *)[self.registerTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *passWord = passwordCell.textfiled.text;
    if ([passWord isEqualToString:@""] || passWord == nil) {
        [self showText:@"请输入密码"];
        return;
    }
    
    if (passWord.length <6 || passWord.length>16) {
        
        
        [self showText:@"密码为6到16位数字或字母组合"];
        return;
    }

    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:phoneString forKey:@"Phone"];
    [dict setValue:passWord forKey:@"Password"];
    [dict setValue:verifString forKey:@"Code"];
    
    
    [self showProgressWithText:@"注册中"];
    [HTTPTool requestWithURLString:@"/api/account/register" parameters:dict type:kPOST success:^(id responseObject) {
        
        if ([responseObject[@"ResultCode"] integerValue] == 4) {
            [self showText:@"请输入正确的验证码"];
            return;
        }
        
        if ([responseObject[@"ResultCode"] integerValue] == 3) {
            [self showText:@"验证码已经过期"];
            return;
        }
        
        if ([responseObject[@"ResultCode"] integerValue] == 5) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:responseObject[@"ResultMessage"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"重新填写" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                KMMLoginViewController *fillPerson = [[KMMLoginViewController alloc]init];
                [self.navigationController pushViewController:fillPerson animated:YES];
            }];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        [self showSuccessWithText:@"注册成功"];
        NSDictionary *dict = responseObject[@"Data"];
        NSString *token = dict[@"Token"];
        SET_LOGIN_STATION(YES);
        [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"Token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        [[UIApplication sharedApplication].keyWindow addSubview:self.successView];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"恭喜您注册成功!\n接下来请进行身份实名认证" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            KMMFillPersonDetailController *fillPerson = [[KMMFillPersonDetailController alloc]init];
            fillPerson.isCanEdit = YES;
            [self.navigationController pushViewController:fillPerson animated:YES];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];


    } failure:^(NSError *error) {
        [self showErrorWithText:@"网络开小差了\n请检查后重试"];
    }];
    

}

//判断时候同时包含数字跟字母
- (BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
   
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    
    return result;
}

//返回操作
- (void)popAction {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma makr - KMMLoginCellDelegate
- (void)KMMLoginCellDelegateEyeAction:(BOOL)isShowPassword {
    
    KMMLoginCell * passwordCell = (KMMLoginCell *)[self.registerTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    passwordCell.textfiled.secureTextEntry = isShowPassword;
    
}

#pragma mark - lazy Load
- (UITableView *)registerTab {
    
    if (!_registerTab) {
        _registerTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _registerTab.tableHeaderView = [self tableHeader];
        _registerTab.tableFooterView = [self footerView];
        _registerTab.delegate = self;
        _registerTab.dataSource = self;
        [_registerTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_registerTab registerNib:[UINib nibWithNibName:@"KMMLoginCell" bundle:nil] forCellReuseIdentifier:@"KMMLoginCell"];
        [_registerTab registerNib:[UINib nibWithNibName:@"KMMVerificationCell" bundle:nil] forCellReuseIdentifier:@"KMMVerificationCell"];
        _registerTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _registerTab;
}


#pragma mark - HeaderView
- (UIView *)tableHeader {
    
    UIView *whiteVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 168)];
    whiteVeiw.backgroundColor = [UIColor whiteColor];
    
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"icon-194"];
    [whiteVeiw addSubview:img];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.centerY.equalTo(whiteVeiw);
        make.width.height.mas_equalTo(80);
//        make.height.mas_equalTo(44);
        
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    [whiteVeiw addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.right.left.equalTo(whiteVeiw).offset(0);
        make.height.mas_equalTo(1);
        
    }];
    return whiteVeiw;
}

#pragma mark - FooterView
- (UIView *)footerView {
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *registerBtn = [[UIButton alloc]init];
    registerBtn.clipsToBounds = YES;
    registerBtn.layer.cornerRadius = 5;
    registerBtn.backgroundColor = BASE_COLOR;
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [footerView addSubview:registerBtn];
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(footerView.mas_top).offset(20);
        make.left.equalTo(footerView.mas_left).offset(10);
        make.right.equalTo(footerView.mas_right).offset(-10);
        make.height.mas_equalTo(50);
        
    }];
    
    UIButton *readyBtn = [[UIButton alloc]init];
    [readyBtn setTitle:@"已有账号登录" forState:UIControlStateNormal];
    readyBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [readyBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
    [readyBtn sizeToFit];
    [footerView addSubview:readyBtn];
    
    [readyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(registerBtn.mas_bottom).offset(10);
        make.left.right.equalTo(footerView).offset(0);
    }];
    
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    
    [readyBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}



@end
