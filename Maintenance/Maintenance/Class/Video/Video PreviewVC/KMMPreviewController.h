//
//  KMMPreviewController.h
//  Maintenance
//
//  Created by kmcompany on 2017/7/13.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlbumVideoInfo.h"

@interface KMMPreviewController : UIViewController

@property (nonatomic,strong) NSString *filePath;

@property (nonatomic,strong) NSString *fileName;

@property (nonatomic,assign) NSInteger time;

@property (nonatomic,strong) NSURL *fileURL;

@property (nonatomic,strong) AlbumVideoInfo *model;

@end
