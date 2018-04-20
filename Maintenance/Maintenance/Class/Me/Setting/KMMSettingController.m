//
//  KMMSettingController.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/5.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMSettingController.h"
#import "KMMAboutUsController.h"
#import "KMMLoginViewController.h"
#import "CYTabBarController.h"

//Cell
#import "KMMClearMemoryCell.h"


@interface KMMSettingController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *settingTab;

@property (nonatomic,strong) NSString *sizeString;


@end

@implementation KMMSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
}

- (void)pageLayout {
   
    self.title = @"设置";
    self.sizeString = [NSString stringWithFormat:@"%.2fMB",[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
    [self.view addSubview:self.settingTab];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    KMMClearMemoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMClearMemoryCell"];
    if (indexPath.row == 0) {
        cell.titleLb.text = @"清除缓存";
        cell.menoryLb.hidden = NO;
        if (self.sizeString) {
            cell.menoryLb.text = self.sizeString;
        }else {
            cell.menoryLb.text = @"正在计算...";
        }
        
    }else {
        cell.titleLb.text = @"关于我们";
        cell.menoryLb.hidden = YES;
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    sectionView.backgroundColor = BASE_BACKGROUND_COLOR;
    
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否清除缓存" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self showProgress];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [self dismissProgress];
            }];
            self.sizeString = [NSString stringWithFormat:@"%.2fMB",[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
            [self.settingTab reloadData];
        }];
        
        UIAlertAction *comfirlAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];

        [alterVC addAction:cancleAction];
        [alterVC addAction:comfirlAction];
        
        [self.navigationController presentViewController:alterVC animated:YES completion:nil];
    }else {
        KMMAboutUsController *abousVC = [KMMAboutUsController new];
        [self.navigationController pushViewController:abousVC animated:YES];
    }
    
   
}

#pragma mark - Lazy Load
- (UITableView *)settingTab {

    if (!_settingTab) {
        _settingTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _settingTab.tableFooterView = [self tableFooterView];
        _settingTab.delegate = self;
        _settingTab.dataSource  = self;
        [_settingTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_settingTab registerNib:[UINib nibWithNibName:@"KMMClearMemoryCell" bundle:nil] forCellReuseIdentifier:@"KMMClearMemoryCell"];
    }
    return _settingTab;
}

- (UIView *)tableFooterView {

    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
   
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = BASE_COLOR;
    [btn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(10);
        make.right.equalTo(backView.mas_right).offset(-10);
        make.height.mas_equalTo(40);
        make.top.equalTo(backView.mas_top).offset(50);
    }];
    return backView;
}

- (void)logoutAction {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
       
        
        [HTTPTool requestWithURLString:@"/api/account/signout" parameters:nil type:kGET success:^(id responseObject) {
            
//            SET_Audist_STATION(NO);
            SET_LOGIN_STATION(NO);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutAction" object:nil];
            
           //清除本地数据
          //  [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"] error:nil];
         //   [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"] error:nil];
            
            //清楚token
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowTips"];
            [[NSUserDefaults standardUserDefaults] synchronize];
          
            
//            CYTabBarController *tabarVC = (CYTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//            for (UINavigationController * nav in tabarVC.viewControllers) {
//                
//                [nav popToRootViewControllerAnimated:NO];
//            }
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[KMMLoginViewController new]];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            [self bk_performBlock:^(id obj) {
                
                [self showSuccessWithText:@"退出登录"];
            } afterDelay:0.5];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
   
}

@end
