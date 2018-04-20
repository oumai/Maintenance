//
//  KMMSearchTitleModel.h
//  Maintenance
//
//  Created by kmcompany on 2017/6/5.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ClassTitleData;

@interface KMMSearchTitleModel : NSObject

@property (nonatomic,strong) NSMutableArray <ClassTitleData *> *Data;

@property (nonatomic,copy) NSString *RecordsCount;

@property (nonatomic,copy) NSString *ResultCode;

@property (nonatomic,copy) NSString *ResultMessage;

@end

@interface ClassTitleData : NSObject

@property (nonatomic,copy) NSString *Id;

@property (nonatomic,copy) NSString *Title;

@end
