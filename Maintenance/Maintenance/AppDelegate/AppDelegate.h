//
//  AppDelegate.h
//  Maintenance
//
//  Created by KM on 17/5/312017.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, copy) void (^backgroundCompletionHandler)(void);

@end

