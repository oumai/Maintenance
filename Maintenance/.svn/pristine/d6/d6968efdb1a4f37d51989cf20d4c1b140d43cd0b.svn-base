
//
//  HTTPTool+BATMallRequest.m
//  HealthBAT_Pro
//
//  Created by KM on 16/10/272016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool+BATMallRequest.h"
#import "BATSearchBaseModel.h"
#import "SVProgressHUD.h"

@implementation HTTPTool (BATMallRequest)

+ (void)requestWithMallURLString:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError * error))failure {


    URLString = [NSString stringWithFormat:@"%@%@",MALL_URL,URLString];
    [HTTPTool baseRequestWithURLString:URLString HTTPHeader:nil parameters:parameters type:kPOST success:^(id responseObject) {

        BATSearchBaseModel *searchBaseModel = [BATSearchBaseModel mj_objectWithKeyValues:responseObject];

        if (![searchBaseModel.resultCode isEqualToString:@"0"]) {
            //失败
            if (failure) {
                NSError * error = [[NSError alloc] initWithDomain:@"CONNECT_FAILURE" code:-2 userInfo:@{NSLocalizedDescriptionKey:@"服务端返回异常",NSLocalizedFailureReasonErrorKey:@"未知",NSLocalizedRecoverySuggestionErrorKey:@"未知"}];
                failure(error);
            }
            return ;
        }

        //成功
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
