//
//  HTTPTool+BATNetworkMedicalUploadImage.m
//  HealthBAT_Pro
//
//  Created by cjl on 2016/10/26.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool+BATNetworkMedicalUploadImage.h"
#import "SVProgressHUD.h"
#import "BATKmApiconfigModel.h"
#import "BATNetworkMedicalAppTokenModel.h"

@implementation HTTPTool (BATNetworkMedicalUploadImage)

+ (void)requestUploadImageToKMWithParams:(NSArray *)dataArray
                                 success:(void(^)(NSArray *severImageArray))success
                                 failure:(void(^)(NSError *error))failure
                       fractionCompleted:(void(^)(double count))fractionCompleted
{

    dispatch_group_t group = dispatch_group_create();

    NSMutableArray *array = [NSMutableArray array];

    for (int i = 0; i < dataArray.count; i++) {

        NSData *imageData = dataArray[i];

        dispatch_group_enter(group);

        [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetKmApiconfig" parameters:nil type:kPOST success:^(id responseObject) {


            BATKmApiconfigModel *batKmApiconfigModel = [BATKmApiconfigModel mj_objectWithKeyValues:responseObject];

            NSString *URL = batKmApiconfigModel.Data.imgupload;

            [HTTPTool baseUploadFileWithURLString:URL HTTPHeader:^(HTTPToolSession *requestSession) {

                [requestSession.requestManager.requestSerializer setValue:batKmApiconfigModel.Data.apptoken forHTTPHeaderField:@"apptoken"];
                [requestSession.requestManager.requestSerializer setValue:batKmApiconfigModel.Data.noncestr forHTTPHeaderField:@"noncestr"];
                [requestSession.requestManager.requestSerializer setValue:batKmApiconfigModel.Data.userid forHTTPHeaderField:@"userid"];
                [requestSession.requestManager.requestSerializer setValue:batKmApiconfigModel.Data.sign forHTTPHeaderField:@"sign"];

            } WithParams:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

                [formData appendPartWithFileData:imageData
                                            name:[NSString stringWithFormat:@"dynamic_picture%d",i]
                                        fileName:[NSString stringWithFormat:@"dynamic_picture%d.jpg",i]
                                        mimeType:@"multipart/form-data"];

            } success:^(id dic) {

                if ([[dic objectForKey:@"Status"] integerValue] == 0) {
                    [array addObject:dic];
                }
                else {
                    [HTTPTool cancelRequest];

                    if (failure) {
                        if (failure) {
                            [SVProgressHUD showErrorWithStatus:@"请求失败，稍后再试！"];
                            failure(nil);
                        }
                    }
                }
                dispatch_group_leave(group);

            } failure:^(NSError *error) {

                [HTTPTool cancelRequest];

                if (failure) {
                    if (failure) {
                        [SVProgressHUD showErrorWithStatus:@"请求失败，稍后再试！"];
                        failure(nil);
                    }
                }
                dispatch_group_leave(group);

            } fractionCompleted:^(double count) {

            }];


        }failure:^(NSError *error) {

            dispatch_group_leave(group);

        }];
    
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (array.count == dataArray.count) {
            if (success) {
                success(array);
            }
        } else {
            if (failure) {
                if (failure) {
                    [SVProgressHUD showErrorWithStatus:@"啊哦，无法连线上网"];
                    failure(nil);
                }
            }
        }
    });
}



@end
