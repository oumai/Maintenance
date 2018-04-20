//
//  HTTPTool+BATDomainAPI.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/8/15.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool+BATDomainAPI.h"
#import "BATDomainModel.h"

@implementation HTTPTool (BATDomainAPI)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
+ (void)getDomain {

#ifdef DEBUG
    //开发｀

    [HTTPToolLogger sharedHTTPToolLogger].level = AFLoggerLevelDebug;

    //H5
    [[NSUserDefaults standardUserDefaults] setValue:@"http://test.jkbat.com" forKey:@"AppDomainUrl"];
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.29:9999" forKey:@"AppDomainUrl"];//李秋萍


    //.net
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.65:1030" forKey:@"AppApiUrl"];//张玮
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.198:9998" forKey:@"AppApiUrl"];//金迪
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.83:9998" forKey:@"AppApiUrl"];//催扬
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://121.15.153.63:8124" forKey:@"AppApiUrl"];//李何苗
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.205:80" forKey:@"AppApiUrl"];//王立军
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.29:9998" forKey:@"AppApiUrl"];//李秋萍
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.test.jkbat.com" forKey:@"AppApiUrl"];//测试



    //java
    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.181:8081" forKey:@"searchdominUrl"];//郭关荣
//    [[NSUserDefaults standardUserDefaults]setValue:@"http://10.2.21.82:8083" forKey:@"searchdominUrl"];//连自杰
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.59:8081" forKey:@"searchdominUrl"];//陈珊
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.test.jkbat.com" forKey:@"searchdominUrl"];

    //商城
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];

#elif TESTING
    //开发&内测

    [HTTPToolLogger sharedHTTPToolLogger].level = AFLoggerLevelDebug;

//    [[NSUserDefaults standardUserDefaults] setValue:@"http://test.jkbat.com" forKey:@"AppDomainUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://yhs-api.test.jkbat.com" forKey:@"AppApiUrl"];
  //  [[NSUserDefaults standardUserDefaults] setValue:@"http://hc013tn-api.chinacloudsites.cn" forKey:@"AppApiUrl"];
//       [[NSUserDefaults standardUserDefaults] setValue:@"http://api.yanghushi.net" forKey:@"AppApiUrl"];
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://121.15.153.63:8124" forKey:@"AppApiUrl"];//李何苗
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.29.99:8080" forKey:@"AppApiUrl"];

//    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.test.jkbat.com" forKey:@"searchdominUrl"];
   //   [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.83:9998" forKey:@"AppApiUrl"];
//    [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.198:9998" forKey:@"AppApiUrl"];
  //  [[NSUserDefaults standardUserDefaults] setValue:@"http://api.jkbat.com" forKey:@"AppApiUrl"];
 //   [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.65:1030" forKey:@"AppApiUrl"];//张玮

  //  [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];
  //  [[NSUserDefaults standardUserDefaults] setValue:@"http://10.2.21.181:8081" forKey:@"searchdominUrl"];//郭关荣

#elif PUBLICRELEASE
    //测试
    [HTTPToolLogger sharedHTTPToolLogger].level = AFLoggerLevelOff;

    //测试环境
    [[NSUserDefaults standardUserDefaults] setValue:@"http://test.jkbat.com" forKey:@"AppDomainUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.test.jkbat.com" forKey:@"AppApiUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.test.jkbat.com" forKey:@"searchdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.yanghushi.net" forKey:@"AppApiUrl"];
#elif PRERELEASE
    //预发布
    [HTTPToolLogger sharedHTTPToolLogger].level = AFLoggerLevelDebug;

    //预发布环境
    [[NSUserDefaults standardUserDefaults] setValue:@"http://preview.jkbat.com" forKey:@"AppDomainUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.preview.jkbat.com" forKey:@"AppApiUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"searchdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];

#elif ENTERPRISERELEASE
    //企业无线发布（蒲公英）
    [HTTPToolLogger sharedHTTPToolLogger].level = AFLoggerLevelOff;
    
    [[NSUserDefaults standardUserDefaults] setValue:@"http://www.jkbat.com" forKey:@"AppDomainUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.jkbat.com" forKey:@"AppApiUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"searchdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.yanghushi.net" forKey:@"AppApiUrl"];

#elif RELEASE
    //正式（APPSTORE）
    [HTTPToolLogger sharedHTTPToolLogger].level = AFLoggerLevelOff;

    [[NSUserDefaults standardUserDefaults] setValue:@"http://www.jkbat.com" forKey:@"AppDomainUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.jkbat.com" forKey:@"AppApiUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"searchdominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://search.jkbat.com" forKey:@"malldomainUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://api.yanghushi.net" forKey:@"AppApiUrl"];
#endif


    [[HTTPToolLogger sharedHTTPToolLogger] startLogging];

    [[NSUserDefaults standardUserDefaults] setValue:@"http://www.jkbat.com:8080" forKey:@"storedominUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:@"http://www.jkbat.com:8080" forKey:@"hotquestionUrl"];

    [[NSUserDefaults standardUserDefaults] synchronize];

#ifdef RELEASE
    //正式环境
//    [HTTPTool domainRequest];
#endif
}

+ (void)domainRequest {
//    AFHTTPSessionManager *manager = [HTTPTool managerWithBaseURL:nil sessionConfiguration:NO];
//    NSString * URL = @"http://www.jkbat.com/api/GetAppDominUrl";
//    [manager GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        DDLogVerbose(@"\nGET返回值---\n%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
//        id dic = [HTTPTool responseConfiguration:responseObject];
//
//        BATDomainModel * urlModel = [BATDomainModel mj_objectWithKeyValues:dic];
//        if (urlModel.ResultCode == 0) {
//            [[NSUserDefaults standardUserDefaults] setValue:urlModel.Data.appdominUrl forKey:@"appdominUrl"];
//            [[NSUserDefaults standardUserDefaults] setValue:urlModel.Data.storedominUrl forKey:@"storedominUrl"];
//            [[NSUserDefaults standardUserDefaults] setValue:urlModel.Data.hotquestionUrl forKey:@"hotquestionUrl"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];

}

@end
