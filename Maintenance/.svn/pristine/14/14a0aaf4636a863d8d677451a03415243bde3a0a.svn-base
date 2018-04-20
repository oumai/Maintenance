//
//  HTTPTool+BATSearchRequest.m
//  HealthBAT_Pro
//
//  Created by KM on 16/8/302016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool+BATSearchRequest.h"
#import "BATSearchBaseModel.h"
#import "SVProgressHUD.h"

@implementation HTTPTool (BATSearchRequest)


+ (void)requestWithSearchURLString:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError * error))failure
{

    URLString = [NSString stringWithFormat:@"%@%@",SEARCH_URL,URLString];
    [HTTPTool sharedHTTPTool].requestSerializerType = RequestSerializerTypeHTTP;

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
            NSError * tmpError = [[NSError alloc] initWithDomain:@"CONNECT_FAILURE" code:-3 userInfo:@{NSLocalizedDescriptionKey:@"啊哦，无法连线上网",NSLocalizedFailureReasonErrorKey:@"未知",NSLocalizedRecoverySuggestionErrorKey:@"未知"}];

            failure(tmpError);
        }
        
    }];
}




@end
