//
//  KMMEnumsModel.h
//  Maintenance
//
//  Created by kmcompany on 2017/6/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EnumsArr;

@interface KMMEnumsModel : NSObject

@property (nonatomic,strong) NSMutableArray <EnumsArr *> *Data;

@end

@interface EnumsArr : NSObject

@property (nonatomic,copy) NSString *Name;

@property (nonatomic,copy) NSString *Text;

@property (nonatomic,copy) NSString *Code;

@property (nonatomic,assign) BOOL isSelect;


@end
