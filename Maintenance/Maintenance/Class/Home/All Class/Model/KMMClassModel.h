//
//  KMMClassModel.h
//  Maintenance
//
//  Created by kmcompany on 2017/6/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ClassData;

@interface KMMClassModel : NSObject

@property (nonatomic,strong) NSMutableArray <ClassData *> *Data;

@property (nonatomic,copy) NSString *RecordsCount;

@property (nonatomic,copy) NSString *ResultCode;

@property (nonatomic,copy) NSString *ResultMessage;

@end

@interface ClassData : NSObject

@property (nonatomic,copy) NSString *CourseCategoryAlias;

@property (nonatomic,copy) NSString *Id;

@property (nonatomic,copy) NSString *AccountId;

@property (nonatomic,copy) NSString *TeacherName;

@property (nonatomic,copy) NSString *TeacherDesc;

@property (nonatomic,copy) NSString *CourseCategory;

@property (nonatomic,copy) NSString *CourseTitle;

@property (nonatomic,copy) NSString *CourseDesc;

@property (nonatomic,copy) NSString *CourseType;

@property (nonatomic,copy) NSString *ClassHour;

@property (nonatomic,copy) NSString *Poster;

@property (nonatomic,copy) NSString *AttachmentUrl;

@property (nonatomic,copy) NSString *ReadingNum;

@property (nonatomic,copy) NSString *ReplyNum;

@property (nonatomic,copy) NSString *CollectNum;

@property (nonatomic,copy) NSString *Auditing;

@property (nonatomic,copy) NSString *AuditContent;

@property (nonatomic,copy) NSString *CreatedTime;

@property (nonatomic,copy) NSString *MainContent;

@end
