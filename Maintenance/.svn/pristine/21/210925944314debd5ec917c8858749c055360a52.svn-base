//
//  KMMCompressionVideoTool.m
//  Maintenance
//
//  Created by kmcompany on 2017/8/11.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMCompressionVideoTool.h"

#define CompressionVideoPaht [NSHomeDirectory() stringByAppendingFormat:@"/Documents"]

@implementation KMMCompressionVideoTool

+ (void)compressedVideoOtherMethodWithURL:(NSURL *)url fileName:(NSString *)fileName compressionType:(NSString *)compressionType compressionResultPath:(CompressionSuccessBlock)resultPathBlock {
    
    NSString *resultPath;
    
    //  NSData *data = [NSData dataWithContentsOfURL:url];
    
    //   CGFloat totalSize = (float)data.length / 1024 / 1024;
    
    NSMutableString *string = [[NSMutableString alloc]init];
    
    NSMutableArray *nameArr = [NSMutableArray arrayWithArray:[fileName componentsSeparatedByString:@"."]];
    [nameArr removeLastObject];
    for (NSString *subName in nameArr) {
        [string appendString:subName];
    }
    
//    NSString *nameString = 
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    // 所支持的压缩格式中是否有 所选的压缩格式
    if ([compatiblePresets containsObject:compressionType]) {
        
        
      //  NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
        
       // [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        BOOL isExists = [manager fileExistsAtPath:CompressionVideoPaht];
        
        if (!isExists) {
            
            [manager createDirectoryAtPath:CompressionVideoPaht withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *filePathString = [CompressionVideoPaht stringByAppendingPathComponent:[NSString stringWithFormat:@"KMM%@.mp4",string]];
        BOOL isExistsFile = [manager fileExistsAtPath:filePathString];
        if (isExistsFile) {
            if (resultPathBlock) {
                resultPathBlock(filePathString,0);
            }
            return;
        }
        
        resultPath = [CompressionVideoPaht stringByAppendingPathComponent:[NSString stringWithFormat:@"KMM%@.mp4",string]];
        
        NSLog(@"压缩文件路径 resultPath = %@",resultPath);
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:compressionType];

        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         
         {
             if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                 
                // NSData *data = [NSData dataWithContentsOfFile:resultPath];
                 
                 //float memorySize = (float)data.length / 1024 / 1024;
                 //NSLog(@"视频压缩后大小 %f", memorySize);
                 NSString *PATH_MOVIE_FILE = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",fileName]];
                 
                 [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];

                 resultPathBlock (resultPath, 0);
                 
             } else {
                 
                 NSLog(@"压缩失败");
             }
             
         }];
        
    } else {
        //        JFLog(@"不支持 %@ 格式的压缩", compressionType);
    }
}


@end
