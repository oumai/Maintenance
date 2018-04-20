//
//  AppDelegate.m
//  Maintenance
//
//  Created by KM on 17/5/312017.
//  Copyright © 2017年 KM. All rights reserved.
//

//Controller
#import "AppDelegate.h"

#import "JQFMDB.h"
#import "KMMGetURLFileLengthTool.h"
#import "UploadTable.h"

#import "KMMLoginViewController.h"
#import "CYTabBarController.h"
#import "KMMeViewController.h"
#import "KMMHomeViewController.h"
//VCSetting
#import "AppDelegate+KMMViewControllerSetting.h"
#import "HTTPTool+BATDomainAPI.h"//获取域名
//第三方
#import "SVProgressHUD.h"
#import "IQKeyboardManager.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import <objc/message.h>

#define CompletionHandlerName       "completionHandler"

#import "KMMTabBarController.h"

@interface AppDelegate ()<CYTabBarDelegate>



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self requestImagePickerAuthorization];
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    //获取最新的域名
    [HTTPTool getDomain];
    //第三方ui控件设置
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];//设置HUD的Style
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];//设置HUD和文本的颜色
    [SVProgressHUD setBackgroundColor:UIColorFromRGB(0, 0, 0, 0.3)];//设置HUD的背景颜色
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bat_logout) name:@"LOGIN_FAILURE" object:nil];
    
    //设置VC
    [self bat_settingVC];
    [self bat_VCDissmiss];
    [self cancelTableViewAdjust];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    

    if (LOGIN_STATION) {
        
        if (Audist_STATION) {
            KMMTabBarController *tabbar = [[KMMTabBarController alloc]init];
            self.window.rootViewController = tabbar;
            
        }else {
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[KMMLoginViewController new]];
            self.window.rootViewController = nav;
        }
        
    }else {
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[KMMLoginViewController new]];
        self.window.rootViewController = nav;
    }
    
    KMMGetURLFileLengthTool *netTool = [KMMGetURLFileLengthTool shareInstance];
    [netTool getNetSateWithResultBlock:^(NSString *netSateString) {
        
        if([netSateString isEqualToString:@"phoneNet"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NetStateChange" object:@{@"NetState":@"phoneNet"}];
            
            [[NSUserDefaults standardUserDefaults] setValue:@"phoneNet" forKey:@"NetState"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else if([netSateString isEqualToString:@"NoNet"]) {
            
             [[NSUserDefaults standardUserDefaults] setValue:@"NoNet" forKey:@"NetState"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"NetStateChange" object:@{@"NetState":@"NoNet"}];
            
        }else if([netSateString isEqualToString:@"WIFI"]) {
            
             [[NSUserDefaults standardUserDefaults] setValue:@"WIFI" forKey:@"NetState"];
             [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NetStateChange" object:@{@"NetState":@"WIFI"}];
        }
    }];
    
    return YES;
}

- (void)requestImagePickerAuthorization {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ||
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusNotDetermined) { // 未授权
            if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
              //  [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
            } else {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) {
                    //    [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
                    } else if (status == PHAuthorizationStatusDenied) {
                    //    [self executeCallback:callback status:WTAuthorizationStatusDenied];
                    } else if (status == PHAuthorizationStatusRestricted) {
                      //  [self executeCallback:callback status:WTAuthorizationStatusRestricted];
                    }
                }];
            }
            
        } else if (authStatus == ALAuthorizationStatusAuthorized) {
         //   [self executeCallback:callback status:WTAuthorizationStatusAuthorized];
        } else if (authStatus == ALAuthorizationStatusDenied) {
         //   [self executeCallback:callback status:WTAuthorizationStatusDenied];
        } else if (authStatus == ALAuthorizationStatusRestricted) {
         //   [self executeCallback:callback status:WTAuthorizationStatusRestricted];
        }
    } else {
     //   [self executeCallback:callback status:WTAuthorizationStatusNotSupport];
    }
}


//退出登录
- (void)bat_logout {
    
    DDLogDebug(@"退出登录");
    SET_LOGIN_STATION(NO);
    
    //清除本地数据
    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"] error:nil];
    
    //清楚token
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    
    //界面跳转
 //   CYTabBarController *rootTabBar = (CYTabBarController *)self.window.rootViewController;
//    for (UINavigationController * nav in rootTabBar.viewControllers) {
//        
//        [nav popToRootViewControllerAnimated:YES];
//    }
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[KMMLoginViewController new]];
    
    [self bk_performBlock:^(id obj) {
        
        SET_LOGIN_STATION(NO);
        [SVProgressHUD showSuccessWithStatus:@"退出登录"];
    } afterDelay:0.5];
    
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[BATLoginViewController new]];
    //    [rootTabBar presentViewController:nav animated:YES completion:nil];
    //    [self performSelector:@selector(backHome) withObject:nil afterDelay:1];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void (^)())completionHandler
{
    return objc_getAssociatedObject(self, CompletionHandlerName);
}
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
   // NSLog(@"%s", __FUNCTION__);
    objc_setAssociatedObject(self, CompletionHandlerName, completionHandler, OBJC_ASSOCIATION_COPY);
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    
    NSArray *arr =  [[JQFMDB shareDatabase] jq_lookupTable:@"upLoadTable" dicOrModel:[UploadTable new] whereFormat:@""];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowTips"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"uploadStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableArray *tableData = [NSMutableArray array];
    [tableData addObjectsFromArray:arr];
    
    for (UploadTable *table in tableData) {
        table.upload_status = 0;
        table.isCanStart = YES;
        
        if ([[JQFMDB shareDatabase] jq_updateTable:@"upLoadTable" dicOrModel:table whereFormat:[NSString stringWithFormat:@"where upload_file_token = '%@'",table.upload_file_token]]) {
            NSLog(@"更改成功");
            
        }else {
            NSLog(@"更改失败");
        }
    }
}


@end
