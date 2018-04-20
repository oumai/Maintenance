//
//  KMMForgottenViewController.m
//  Maintenance
//
//  Created by kmcompany on 2017/5/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMForgottenViewController.h"


//Cell
#import "KMMLoginCell.h"
#import "KMMVerificationCell.h"

@interface KMMForgottenViewController ()<UITableViewDelegate,UITableViewDataSource,KMMVerificationCellDelegate,KMMLoginCellDelegate>

@property (nonatomic,strong) UITableView *forgottenTab;

@end

@implementation KMMForgottenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pageLayout];
}

- (void)viewWillAppear:(BOOL)animated {

    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)pageLayout {
    
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.forgottenTab];
    
    WEAK_SELF(self);
    [self.forgottenTab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KMMLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMLoginCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.path = indexPath;
    cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.row == 0) {
        cell.textfiled.placeholder = @"手机号码";
        cell.eyeImage.hidden = YES;
        cell.headImage.image = [UIImage imageNamed:@"icon-pre-sjh"];
        cell.textfiled.secureTextEntry = NO;
        cell.textfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.textfiled.keyboardType = UIKeyboardTypeNumberPad;
        
        if (self.phoneNum) {
            cell.textfiled.text = self.phoneNum;
        }
        
        [cell.textfiled mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(cell.contentView.mas_right).offset(-20);
        }];
        
    }else if(indexPath.row == 1) {
        KMMVerificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMVerificationCell"];
        cell.delegate = self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textfiled.keyboardType = UIKeyboardTypeNumberPad;
        return cell;
    }else if(indexPath.row == 2) {
        cell.eyeImage.hidden = NO;
        cell.headImage.image = [UIImage imageNamed:@"icon-nor-mm"];
        cell.textfiled.placeholder = @"输入新密码";
        cell.textfiled.secureTextEntry = YES;
        cell.textfiled.clearButtonMode = UITextFieldViewModeNever;
        
        
        [cell.textfiled mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(cell.contentView.mas_right).offset(-45);
        }];
        
    }else{
        cell.eyeImage.hidden = NO;
        cell.headImage.image = [UIImage imageNamed:@"icon-nor-mm"];
        cell.textfiled.placeholder = @"再次输入新密码";
        cell.textfiled.secureTextEntry = YES;
        cell.textfiled.clearButtonMode = UITextFieldViewModeNever;
        
        
        [cell.textfiled mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(cell.contentView.mas_right).offset(-45);
        }];
    }
    return cell;
}

#pragma mark - CellDelegate
//闭眼回调时间
- (void)KMMLoginCellDelegateEyeAction:(BOOL)isShowPassword rowPaht:(NSIndexPath *)RowPaht{
    
   KMMLoginCell *cell = (KMMLoginCell *)[self.forgottenTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:RowPaht.row inSection:0]];
    
    cell.textfiled.secureTextEntry = isShowPassword;
    
}

- (void)KMMloginCellDelegateTextFieldDidChange:(UITextField *)textField withRowPaht:(NSIndexPath *)path {

    if (path.row == 2) {
        if (textField.text.length>16) {
            [self showText:@"密码为6-16的数字或字母组合"];
            textField.text = [textField.text substringToIndex:16];
        }
    }
    
    if (path.row == 3) {
        if (textField.text.length>16) {
            [self showText:@"密码为6-16的数字或字母组合"];
            textField.text = [textField.text substringToIndex:16];
        }
    }
    
}

//验证码回调事件
- (void)KMMVerificationCellVerificationAction:(KMMVerificationCell *)cell {
    
    
    KMMLoginCell * phoneCell = (KMMLoginCell *)[self.forgottenTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
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
    [dict setValue:@"2" forKey:@"valid"];
    
    
    [HTTPTool requestVerificationWithURLString:@"/api/account/postcodemsg" parameters:dict type:kGET success:^(id responseObject) {
        cell.verificationBtn.userInteractionEnabled = YES;
        NSInteger ResultCode = [responseObject[@"ResultCode"] integerValue];
        if (ResultCode == 6) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该手机号尚未注册!" preferredStyle:UIAlertControllerStyleAlert];
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
        
        
        KMMVerificationCell *verifCell = (KMMVerificationCell *)[self.forgottenTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
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
        [self showErrorWithText:@"网络开小差了\n请检查后重试"];
        cell.verificationBtn.userInteractionEnabled = YES;
    }];

}

#pragma mark - lazy Load
- (UITableView *)forgottenTab {
    
    if (!_forgottenTab) {
        _forgottenTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _forgottenTab.tableFooterView = [self footerView];
        _forgottenTab.delegate = self;
        _forgottenTab.dataSource = self;
        [_forgottenTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_forgottenTab registerNib:[UINib nibWithNibName:@"KMMLoginCell" bundle:nil] forCellReuseIdentifier:@"KMMLoginCell"];
        [_forgottenTab registerNib:[UINib nibWithNibName:@"KMMVerificationCell" bundle:nil] forCellReuseIdentifier:@"KMMVerificationCell"];
        _forgottenTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _forgottenTab;
}

- (UIView *)footerView {

    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *commitBtn = [[UIButton alloc]init];
    [commitBtn setTitle:@"保存修改" forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.clipsToBounds = YES;
    commitBtn.layer.cornerRadius = 5;
    commitBtn.backgroundColor = BASE_COLOR;
    [commitBtn addTarget:self action:@selector(commitPassWord) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:commitBtn];
    
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(footerView.mas_top).offset(25);
        make.left.equalTo(footerView.mas_left).offset(10);
        make.right.equalTo(footerView.mas_right).offset(-10);
        make.height.mas_equalTo(40);
        
    }];
    return footerView;
}

#pragma mark -提交密码
- (void)commitPassWord {
    
    KMMLoginCell *firstCell = (KMMLoginCell *)[self.forgottenTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

     KMMLoginCell *phoeNumCell = (KMMLoginCell *)[self.forgottenTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
     KMMLoginCell *password = (KMMLoginCell *)[self.forgottenTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    KMMVerificationCell *verificationCell = (KMMVerificationCell *)[self.forgottenTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if (firstCell.textfiled.text == nil || [firstCell.textfiled.text isEqualToString:@""]) {
        [self showText:@"请输入手机号码"];
        return;
    }
    
    
    
    if (verificationCell.textfiled.text == nil || [verificationCell.textfiled.text isEqualToString:@""]) {
        [self showText:@"请输入验证码"];
        return;
    }
    
    if (phoeNumCell.textfiled.text.length<6) {
        [self showText:@"密码不能少于6位的数字或字母组合"];
        return;
    }
    
    if (password.textfiled.text.length<6) {
        [self showText:@"密码不能少于6位的数字或字母组合"];
        return;
    }
    
    if (phoeNumCell.textfiled.text == nil || [phoeNumCell.textfiled.text isEqualToString:@""]) {
        [self showText:@"请输入密码"];
        return;
    }
    
    if (password.textfiled.text == nil || [password.textfiled.text isEqualToString:@""]) {
        [self showText:@"请输入密码"];
        return;
    }
    
    if (![phoeNumCell.textfiled.text isEqualToString:password.textfiled.text]) {
        [self showText:@"两次密码不一致，请重新输入!"];
        return;
    }
    
    [HTTPTool requestWithURLString:@"/api/account/resetpassword" parameters:@{@"mobile":firstCell.textfiled.text,@"password":password.textfiled.text,@"Verifycode":verificationCell.textfiled.text} type:kPOST success:^(id responseObject) {
        [self showText:@"修改成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        [self showText:@"修改失败"];
    }];
}




@end
