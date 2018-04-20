//
//  KMMVideoImageChooseController.h
//  Maintenance
//
//  Created by kmcompany on 2017/7/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMMVideoImageChooseController : UIViewController

@property (nonatomic,strong) NSData *data;
@property (nonatomic,strong) NSString *fileName;
@property(nonatomic,assign) NSInteger time;
@property (nonatomic,strong) NSString *fileURL;

@property (nonatomic,assign) BOOL enablePreView;

@property (nonatomic,strong) void (^ImageBlock)(UIImage *image);
@end
