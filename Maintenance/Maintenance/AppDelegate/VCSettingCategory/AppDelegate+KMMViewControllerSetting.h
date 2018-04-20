//
//  AppDelegate+KMMViewControllerSetting.h
//  Maintenance
//
//  Created by kmcompany on 2017/6/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (KMMViewControllerSetting)

/**
 *  设置VC颜色等
 */
- (void)bat_settingVC;
/**
 *  VC消失时执行方法
 */
- (void)bat_VCDissmiss;

- (void)cancelTableViewAdjust;

@end
