//
//  KMMUploadTool.h
//  Maintenance
//
//  Created by kmcompany on 2017/7/10.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import "KMMBlockModel.h"
#import "UploadTable.h"

@interface KMMUploadTool : NSObject

@property (nonatomic,strong) NSURLSessionUploadTask *uploadTask;

@property (nonatomic,strong) NSString *filePath;

@property (nonatomic,strong) UploadTable *table;

+ (instancetype)shareInstance;



- (void)startUploadWithModel:(KMMBlockModel *)model filePath:(NSString *)filePath;

@property (nonatomic,strong) void (^UploadFinshBlock)(KMMBlockModel *model);

@property (nonatomic,strong) void (^UploadFailureBlock)(KMMBlockModel *model);


- (void)KMMStopUploadAction;

- (void)getBlockInfoRequestWithToken:(NSString *)token
                             success:(void (^)(KMMBlockModel *model,NSString *token))success
                             failure:(void (^)(NSError * error))failure;

- (void)loadTokenWithFilePaht:(NSString *)filePath tableData:(UploadTable *)table success:(void (^)(NSString *token))success;

@end
