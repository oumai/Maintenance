//
//  AppDelegate+KMMViewControllerSetting.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "AppDelegate+KMMViewControllerSetting.h"
#import "Aspects.h"
#import "SVProgressHUD.h"
@implementation AppDelegate (KMMViewControllerSetting)

- (void)bat_settingVC {
    [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
        UIViewController * vc = aspectInfo.instance;
        
        if (vc == nil) {
            return ;
        }
        
        if ([aspectInfo.instance isKindOfClass:NSClassFromString(@"UIInputWindowController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIWindow")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UINavigationController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UITabBarController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UINavigationController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UICompatibilityInputViewController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIApplicationRotationFollowingControllerNoTouches")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIApplicationRotationFollowingController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIAlertController")]) {
            //屏蔽一些系统界面
            
            return ;
        }
        
        //背景色
        vc.view.backgroundColor = BASE_BACKGROUND_COLOR;
        
        //返回按钮
        if (vc.navigationController.viewControllers.count> 1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 20, 40);
            WEAK_SELF(vc);
            [btn bk_whenTapped:^{
                STRONG_SELF(vc);
                [vc.navigationController popViewControllerAnimated:YES];
                [vc dismissViewControllerAnimated:YES completion:nil];
            }];
            [btn setImage:[UIImage imageNamed:@"icon-fh"] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            vc.navigationItem.leftBarButtonItem = backItem;
            
            vc.hidesBottomBarWhenPushed = YES;
        }
        
        //导航条标题
        [vc.navigationController.navigationBar setTitleTextAttributes:@{
                                                                        NSForegroundColorAttributeName:UIColorFromHEX(0x333333, 1),
                                                                        NSFontAttributeName:stringFont(20)
                                                                        }];
        
        //导航条背景色
        [vc.navigationController.navigationBar setBackgroundImage:[Tools imageFromColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        vc.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:BASE_LINECOLOR];
        
        [vc.navigationController.navigationBar setTintColor:UIColorFromHEX(0x333333, 1)];

    } error:NULL];
}

- (void)cancelTableViewAdjust {
    
    [UITableView aspect_hookSelector:@selector(initWithFrame:style:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        
        UITableView * tableView = aspectInfo.instance;
        
        if (tableView == nil) {
            return ;
        }
        
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    } error:nil];
}

- (void)bat_VCDissmiss {
    
    [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
        
        UIViewController * vc = aspectInfo.instance;
        if (vc == nil) {
            return ;
        }
        
        if ([aspectInfo.instance isKindOfClass:NSClassFromString(@"UIInputWindowController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIWindow")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UINavigationController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UITabBarController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UINavigationController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UICompatibilityInputViewController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIApplicationRotationFollowingControllerNoTouches")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIApplicationRotationFollowingController")] ||
            [aspectInfo.instance isKindOfClass:NSClassFromString(@"UIAlertController")]) {
            //屏蔽一些系统界面
            
            return ;
        }
        
        [SVProgressHUD dismiss];
        [vc.view endEditing:YES];
        
    } error:NULL];
}


@end
