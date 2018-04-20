//
//  HTTPTool+BATMainRequest.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/232016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool+BATMainRequest.h"
#import "BATBaseModel.h"
#import "SVProgressHUD.h"

@implementation HTTPTool (BATMainRequest)

#pragma mark -- POST/GET网络请求 --
+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(HTTPRequestType)type
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError * error))failure
{

//    __block BOOL isTooLong = YES;

//    [self bk_performBlock:^{
//        if (isTooLong) {
//            [SVProgressHUD showImage:nil status:@"网络环境不佳"];
//        }
//    } afterDelay:15];

    URLString = [NSString stringWithFormat:@"%@%@",APP_API_URL,URLString];
    [HTTPTool sharedHTTPTool].requestSerializerType = RequestSerializerTypeJSON;

    [HTTPTool baseRequestWithURLString:URLString HTTPHeader:^(HTTPToolSession *requestSession) {

        if (LOGIN_STATION) {

            NSLog(@"%@",LOCAL_TOKEN);
            [requestSession.requestManager.requestSerializer setValue:LOCAL_TOKEN forHTTPHeaderField:@"Token"];
                  //      [requestSession.requestManager.requestSerializer setValue:@"ACCOUNT_593661018b3b5614a0c6d2e5" forHTTPHeaderField:@"Token"];
            
        }
    } parameters:parameters type:type success:^(id responseObject) {
//        isTooLong = NO;

        BATBaseModel *baseModel = [BATBaseModel mj_objectWithKeyValues:responseObject];
        if (baseModel.ResultCode == -2) {

            if (failure) {
                NSError * error = [[NSError alloc] initWithDomain:@"LOGIN_FAILURE" code:-2 userInfo:@{NSLocalizedDescriptionKey:@"登录状态异常，请重新登录",NSLocalizedFailureReasonErrorKey:@"Token无效或为空",NSLocalizedRecoverySuggestionErrorKey:@"重新登录"}];
                failure(error);
            }

            //需要登录
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_FAILURE" object:nil];
            return ;
        }
        
        if (baseModel.ResultCode == 1) {
            if (success) {
                success(responseObject);
            }
            return;
        }
        
        if (baseModel.ResultCode == 2) {
            if (success) {
                success(responseObject);
            }
            return;
        }
        
        if (baseModel.ResultCode == 3) {
            if (success) {
                success(responseObject);
            }
            return;
        }
        
        if (baseModel.ResultCode == 4) {
            if (success) {
                success(responseObject);
            }
            return;
        }
        
        if (baseModel.ResultCode == 5) {
            if (success) {
                success(responseObject);
            }
            return;
        }

        if (baseModel.ResultCode != 0) {
            //失败

            //异常失败
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"resquestStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (failure) {
                NSError * error = [[NSError alloc] initWithDomain:@"CONNECT_FAILURE" code:-2 userInfo:@{NSLocalizedDescriptionKey:baseModel.ResultMessage,NSLocalizedFailureReasonErrorKey:@"未知",NSLocalizedRecoverySuggestionErrorKey:@"未知"}];
                failure(error);
            }
            return ;
        }
        if (baseModel.ResultCode == 0) {
            //成功
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"resquestStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (success) {
                success(responseObject);
            }
        }

    } failure:^(NSError *error) {

//        isTooLong = NO;

        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"resquestStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (failure) {
            NSError * tmpError = [[NSError alloc] initWithDomain:@"CONNECT_FAILURE" code:-3 userInfo:@{NSLocalizedDescriptionKey:@"啊哦，无法连线上网",NSLocalizedFailureReasonErrorKey:@"未知",NSLocalizedRecoverySuggestionErrorKey:@"未知"}];
            failure(tmpError);
        }
        
    }];
}

+ (void)requestVerificationWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(HTTPRequestType)type
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError * error))failure
{
    
    //    __block BOOL isTooLong = YES;
    
    //    [self bk_performBlock:^{
    //        if (isTooLong) {
    //            [SVProgressHUD showImage:nil status:@"网络环境不佳"];
    //        }
    //    } afterDelay:15];
    
    URLString = [NSString stringWithFormat:@"%@%@",APP_API_URL,URLString];
    [HTTPTool sharedHTTPTool].requestSerializerType = RequestSerializerTypeJSON;
    
    [HTTPTool baseRequestWithURLString:URLString HTTPHeader:^(HTTPToolSession *requestSession) {
        
        if (LOGIN_STATION) {
            
            NSLog(@"%@",LOCAL_TOKEN);
            [requestSession.requestManager.requestSerializer setValue:LOCAL_TOKEN forHTTPHeaderField:@"Token"];
            //      [requestSession.requestManager.requestSerializer setValue:@"ACCOUNT_593661018b3b5614a0c6d2e5" forHTTPHeaderField:@"Token"];
            
        }
    } parameters:parameters type:type success:^(id responseObject) {
        //        isTooLong = NO;
        
        BATBaseModel *baseModel = [BATBaseModel mj_objectWithKeyValues:responseObject];
        if (baseModel.ResultCode == -2) {
            
            if (failure) {
                NSError * error = [[NSError alloc] initWithDomain:@"LOGIN_FAILURE" code:-2 userInfo:@{NSLocalizedDescriptionKey:@"登录状态异常，请重新登录",NSLocalizedFailureReasonErrorKey:@"Token无效或为空",NSLocalizedRecoverySuggestionErrorKey:@"重新登录"}];
                failure(error);
            }
            
            //需要登录
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_FAILURE" object:nil];
            return ;
        }
        
        if (baseModel.ResultCode != 0 && baseModel.ResultCode != -1) {
            if (success) {
                success(responseObject);
            }
            return ;
        }
        if (baseModel.ResultCode == 0) {
            //成功
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"resquestStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (success) {
                success(responseObject);
            }
        }
        
    } failure:^(NSError *error) {
        
        //        isTooLong = NO;
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"resquestStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (failure) {
            NSError * tmpError = [[NSError alloc] initWithDomain:@"CONNECT_FAILURE" code:-3 userInfo:@{NSLocalizedDescriptionKey:@"啊哦，无法连线上网",NSLocalizedFailureReasonErrorKey:@"未知",NSLocalizedRecoverySuggestionErrorKey:@"未知"}];
            failure(tmpError);
        }
        
    }];
}


+ (void)requestWithUploadURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(HTTPRequestType)type
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError * error))failure
{
    
    //    __block BOOL isTooLong = YES;
    
    //    [self bk_performBlock:^{
    //        if (isTooLong) {
    //            [SVProgressHUD showImage:nil status:@"网络环境不佳"];
    //        }
    //    } afterDelay:15];
    
    URLString = [NSString stringWithFormat:@"%@%@",@"http://upload.jkbat.com/bigfile",URLString];
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [HTTPTool sharedHTTPTool].requestSerializerType = RequestSerializerTypeJSON;
    
    [HTTPTool baseRequestWithURLString:URLString HTTPHeader:^(HTTPToolSession *requestSession) {
        
        if (LOGIN_STATION) {
            
            NSLog(@"%@",LOCAL_TOKEN);
            [requestSession.requestManager.requestSerializer setValue:LOCAL_TOKEN forHTTPHeaderField:@"Token"];
            //      [requestSession.requestManager.requestSerializer setValue:@"ACCOUNT_593661018b3b5614a0c6d2e5" forHTTPHeaderField:@"Token"];
            
        }
    } parameters:parameters type:type success:^(id responseObject) {
        //        isTooLong = NO;
        
        BATBaseModel *baseModel = [BATBaseModel mj_objectWithKeyValues:responseObject];
        if (baseModel.ResultCode == -2) {
            
            if (failure) {
                NSError * error = [[NSError alloc] initWithDomain:@"LOGIN_FAILURE" code:-2 userInfo:@{NSLocalizedDescriptionKey:@"登录状态异常，请重新登录",NSLocalizedFailureReasonErrorKey:@"Token无效或为空",NSLocalizedRecoverySuggestionErrorKey:@"重新登录"}];
                failure(error);
            }
            
            //需要登录
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_FAILURE" object:nil];
            return ;
        }
        
        if (baseModel.ResultCode == 1) {
            if (success) {
                success(responseObject);
            }
            return;
        }
        
        if (baseModel.ResultCode == 2) {
            if (success) {
                success(responseObject);
            }
            return;
        }
        
        if (baseModel.ResultCode == 3) {
            if (success) {
                success(responseObject);
            }
            return;
        }
        
        if (baseModel.ResultCode == 4) {
            if (success) {
                success(responseObject);
            }
            return;
        }
        
        if (baseModel.ResultCode == 5) {
            if (success) {
                success(responseObject);
            }
            return;
        }
        
        if (baseModel.ResultCode != 0) {
            //失败
            
            //异常失败
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"resquestStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (failure) {
                NSError * error = [[NSError alloc] initWithDomain:@"CONNECT_FAILURE" code:-2 userInfo:@{NSLocalizedDescriptionKey:baseModel.ResultMessage,NSLocalizedFailureReasonErrorKey:@"未知",NSLocalizedRecoverySuggestionErrorKey:@"未知"}];
                failure(error);
            }
            return ;
        }
        if (baseModel.ResultCode == 0) {
            //成功
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"resquestStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (success) {
                success(responseObject);
            }
        }
        
    } failure:^(NSError *error) {
        
        //        isTooLong = NO;
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"resquestStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (failure) {
            NSError * tmpError = [[NSError alloc] initWithDomain:@"CONNECT_FAILURE" code:-3 userInfo:@{NSLocalizedDescriptionKey:@"啊哦，无法连线上网",NSLocalizedFailureReasonErrorKey:@"未知",NSLocalizedRecoverySuggestionErrorKey:@"未知"}];
            failure(tmpError);
        }
        
    }];
}

@end
