//
//  BATTopicReplyModel.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TopicReplyData,secondReplyData;

@interface BATTopicRecordModel : NSObject

@property (nonatomic,strong) NSString *RecordsCount;

@property (nonatomic,strong) NSString *ResultCode;

@property (nonatomic,strong) NSString *ResultMessage;

@property (nonatomic,strong) NSMutableArray<TopicReplyData *> *Data;

@end

/**
 AuthorId = 592fd73a1a4c650f3049c8bf;
 Body = sdfsdfsdf;
 CourseId = 5966e1491a4c651260c82b09;
 CreatedTime = "2017-07-14 15:48:22";
 Id = 596877461a4c6500486c7f33;
 IsSetStar = 0;
 NickName = "\U5c0f\U62a4\U58eb93636939";
 ParentId = "<null>";
 PhotoPath = "<null>";
 SecondCourseReply =             (
 );
 StarNum = 0;
 */

@interface TopicReplyData : NSObject

@property (nonatomic,strong) NSString *AuthorId;

@property (nonatomic,strong) NSString *Body;

@property (nonatomic,strong) NSString *CourseId;

@property (nonatomic,strong) NSString *CreatedTime;

@property (nonatomic,strong) NSString *Id;

@property (nonatomic,assign) BOOL IsSetStar;

@property (nonatomic,strong) NSString *NickName;

@property (nonatomic,strong) NSString *ParentId;

@property (nonatomic,strong) NSString *PhotoPath;

@property (nonatomic,assign) NSInteger StarNum;

@property (nonatomic,strong) NSMutableArray<secondReplyData *> *SecondCourseReply;

@property (nonatomic, assign) double          commentTableViewHeight;



@end

@interface secondReplyData : NSObject

@property (nonatomic,strong) NSString *AuthorId;

@property (nonatomic,strong) NSString *Body;

@property (nonatomic,strong) NSString *CourseId;

@property (nonatomic,strong) NSString *CreatedTime;

@property (nonatomic,strong) NSString *Id;

@property (nonatomic,strong) NSString *IsSetStar;

@property (nonatomic,strong) NSString *NickName;

@property (nonatomic,strong) NSString *ParentId;

@property (nonatomic,strong) NSString *PhotoPath;

@property (nonatomic,assign) NSInteger StarNum;

@property (nonatomic,strong) NSString *ReplyUserName;

@property (nonatomic, assign) double          commentHeight;

@end
