//
//  KMMUploadTool.m
//  Maintenance
//
//  Created by kmcompany on 2017/7/10.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMUploadTool.h"

#import <MobileCoreServices/MobileCoreServices.h>

#import "JQFMDB.h"

#import "UploadTable.h"

#import "AppDelegate.h"

#define CompletionHandlerName       "completionHandler"

#define Person_AccountID [NSString stringWithFormat:@"Person%@",[Tools getCurrentID]]


@interface KMMUploadTool()<NSURLSessionDelegate>



@property (nonatomic,strong) NSURLSession *session;

@property (nonatomic,strong) KMMBlockModel *blockModel;

@property (nonatomic,strong) NSString *tempFilePath;

@end

@implementation KMMUploadTool

- (void)dealloc {
    
    //   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

static KMMUploadTool *_shareInstance;

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[self alloc]init];
        
    });
    return _shareInstance;
}

- (void)KMMStopUploadAction {
    
//    [self.uploadTask cancel];
    
    [self.session getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> * _Nonnull tasks) {
       
        for (NSURLSessionUploadTask *uploadTask in tasks) {
            [uploadTask cancel];
        }
    }];
    
}

#pragma mark - 获取文件Token
- (void)loadTokenWithFilePaht:(NSString *)filePath tableData:(UploadTable *)table success:(void (^)(NSString *token))success {
    
    NSDictionary *sizeDic = [self getVideoInfoWithSourcePath:filePath];
    
    //先根据文件大小获取唯一的token
    [HTTPTool requestWithUploadURLString:@"/" parameters:@{@"fileSize":sizeDic[@"fileSize"]} type:kGET success:^(id responseObject) {
        
        if (success) {
            success(responseObject[@"token"]);
        }
        
        NSString *lastToken = table.upload_file_token;
        table.upload_file_token = responseObject[@"token"];
        
        if ([[JQFMDB shareDatabase] jq_updateTable:Person_AccountID dicOrModel:table whereFormat:[NSString stringWithFormat:@"where upload_file_token = '%@'",lastToken]]) {
            NSLog(@"更改成功");
            
        }else {
            NSLog(@"更改失败");
        }
        
        NSArray *arr =  [[JQFMDB shareDatabase] jq_lookupTable:Person_AccountID dicOrModel:[UploadTable new] whereFormat:@""];
        NSLog(@"%@",arr);
        
        
        //  NSLog(@"%@",responseObject);
        //根据token获取上传的块信息
        // [self getBlockInfoRequestWithToken:responseObject[@"token"] success:nil failure:nil];
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 获取文件Block信息
- (void)getBlockInfoRequestWithToken:(NSString *)token
                             success:(void (^)(KMMBlockModel *model,NSString *token))success
                             failure:(void (^)(NSError * error))failure {
    
    [HTTPTool requestWithUploadURLString:[NSString stringWithFormat:@"/%@",token] parameters:nil type:kGET success:^(id responseObject) {
        
        
        KMMBlockModel *model = [KMMBlockModel mj_objectWithKeyValues:responseObject];
        
        if (success) {
            success(model,model.Token);
        }
        
        //开始真正上传数据
  //      [self startUploadWithModel:model filePath:self.filePath];
        
    } failure:^(NSError *error) {
        
        if(failure){
        
            failure(error);
        }
        
    }];
    
}


- (void)startUploadWithModel:(KMMBlockModel *)model filePath:(NSString *)filePath {
    
    self.blockModel = model;
    self.tempFilePath = filePath;
    
    if (!self.table.upload_status) {
        [self.session getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> * _Nonnull tasks) {
            
            for (NSURLSessionUploadTask *uploadTask in tasks) {
                [uploadTask cancel];
            }
        }];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",@"http://upload.jkbat.com/bigfile",model.Token,model.incomplete.blockIndex];
    
    //转为URL
    NSURL * url = [NSURL URLWithString:path];
    //初始化请求
    NSMutableURLRequest * reuqest = [NSMutableURLRequest requestWithURL:url];
    //设置请求方式
    [reuqest setHTTPMethod:@"POST"];
    
    
    NSData *data = [self readDataWithFilePath:filePath fileStart:[model.incomplete.start integerValue] fileEnd:[model.incomplete.end integerValue]];
    
    NSString *PATH_MOVIE_FILE = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",@"data.data"]];
    
    //设置为POST请求
    if ( [data writeToFile:PATH_MOVIE_FILE atomically:YES]) {
        self.uploadTask = [self.session uploadTaskWithRequest:reuqest fromFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]];
        //启动上传
        [self.uploadTask resume];
    }else {
        NSLog(@"写入失败");
    }
    
    
}

- (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path{
    
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    
    NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    
    return @{@"fileSize" : @(fileSize),
             @"duration" : @(seconds)};
}

-(NSData *)readDataWithFilePath:(NSString *)filePath fileStart:(NSUInteger)start fileEnd:(NSUInteger)End{
    
    NSString *lastCompont = [filePath lastPathComponent];
    NSString *PATH_MOVIE_FILE = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",lastCompont]];
    
    
    @autoreleasepool
    {
        //   NSData *data;
        NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:PATH_MOVIE_FILE];
        [readHandle seekToFileOffset:start];
        NSData *data = [readHandle readDataOfLength:End - start];
        [readHandle closeFile];
        
        return data;
        
    }
    
}

#pragma mark - NSURLSessionDelegate
//收到服务器响应
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //  NSLog(@"%@",response);
    completionHandler(NSURLSessionResponseAllow);
}


//上传结束时候调用
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{

    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSString *PATH_MOVIE_FILE = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",@"data.data"]];
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:PATH_MOVIE_FILE];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:PATH_MOVIE_FILE error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
    
    if (data) {
        NSHTTPURLResponse *tempResponse = (NSHTTPURLResponse *)dataTask.response;
        if (tempResponse.statusCode == 200) {
            NSLog(@"成功");
            NSLog(@"tempRes ponse.statusCode%zd",tempResponse.statusCode);
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"upload : %@",dict);
           
            
            KMMBlockModel *model = [KMMBlockModel mj_objectWithKeyValues:dict];
            
            if (self.UploadFinshBlock) {
//                [dataTask cancel];
//                [self.uploadTask cancel];
                self.UploadFinshBlock(model);
            }
        }else {
        
            if (self.UploadFailureBlock) {
                self.UploadFailureBlock(nil);
            }
        }
        
        
    }
}

//结束之后的错误信息
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        NSLog(@"%@",error);
        if (error.code == -1) {
            [self startUploadWithModel:self.blockModel filePath:self.tempFilePath];
        }
    }
    
}

- (NSURLSession *)session

{
    
    //Use dispatch_once_t to create only one background session. If you want more than one session, do with different identifier
    
    static NSURLSession *session = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.Maintenance.appali"];
        
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
    });
    
    return session;
    
}







@end
