//
//  KMMFillPersonDetailController.h
//  Maintenance
//
//  Created by kmcompany on 2017/6/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMMPerson.h"

@interface KMMFillPersonDetailController : UIViewController

@property (nonatomic,strong) KMMPersonData *personModel;

@property (nonatomic,strong) void (^personBlock)(KMMPersonData *personData);

@property(nonatomic,assign) BOOL isCanEdit;

@property(nonatomic,assign) bool isUpdate;

@end
