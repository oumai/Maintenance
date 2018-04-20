//
//  KMMPerson.h
//  Maintenance
//
//  Created by kmcompany on 2017/5/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class KMMPersonData;

@interface KMMPerson : NSObject

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) KMMPersonData *Data;

@end

@interface KMMPersonData : NSObject

@property (nonatomic,strong) NSString *ID;

@property (nonatomic,strong) NSString *Mobile;

@property (nonatomic,strong) NSString *NickName;

@property (nonatomic,strong) NSString *TrueName;

@property (nonatomic,strong) NSString *AccountType; //用户类型，0普通/学生，1讲师

@property (nonatomic,strong) NSString *HasProfile;

@property (nonatomic,strong) NSString *Email;

@property (nonatomic,strong) NSString *AuditState;  //讲师审核状态，0未申请，1已申请审核中，2审核通过，3审核未通过

@property (nonatomic,strong) NSString *Token;

@property (nonatomic,strong) NSString *IdNo; //身份证

@property (nonatomic, copy) NSString *RealName; //中文姓名

@property (nonatomic, copy) NSString *Sex; //性别

@property(nonatomic,assign) NSInteger HospitalId; //医院id

@property (nonatomic,strong) NSString *HospitalName; //医院名称

@property(nonatomic,assign) NSInteger DeptId; //科室id

@property (nonatomic,strong) NSString *DeptName; //科室

@property (nonatomic,strong) NSString *TitleType; //职称编码

@property (nonatomic,strong) NSString *TitleName; //职称名字

@property (nonatomic,strong) NSString *ProType; //擅长课程编码

@property (nonatomic,strong) NSString *Profession; //擅长课程

@property (nonatomic, copy) NSString *Photo; //头像照片




@end
