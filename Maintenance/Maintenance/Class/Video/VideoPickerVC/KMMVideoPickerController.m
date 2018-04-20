//
//  KMMVideoPickerController.m
//  Maintenance
//
//  Created by kmcompany on 2017/7/3.
//  Copyright © 2017年 KM. All rights reserved.
//
#import "KMMVideoPickerController.h"
#import "KMMCompleteVideoInfoController.h"
#import "KMMPreviewController.h"

#import "AlbumVideoInfo.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#import "KMMVideoTitleReusableView.h"
#import "KMMVideoCell.h"
#import "KMMSizeTipsView.h"

#import "KMMBlockModel.h"

#import "BATMyFindEqualCellFlowLayout.h"

#import "KMMCompressionVideoTool.h"


@interface KMMVideoPickerController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) NSMutableArray *cwArr;

@property (nonatomic,strong) NSMutableArray *allDataArr;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) UICollectionView *VideoCollectionView;

@property (strong,nonatomic) UIImagePickerController *imagePicker;

@property (nonatomic,strong) NSString *urlString;

@property (nonatomic,strong) NSData *data;

@property (nonatomic,strong) NSString *fileNames;

@property (nonatomic,strong) NSString *filePath;

@property (nonatomic,assign) NSInteger time;

@property (nonatomic,strong) KMMBlockModel *blockModel;

@property (nonatomic,strong) KMMSizeTipsView *tipsView;


@end

@implementation KMMVideoPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WEAK_SELF(self);
    self.title = @"上传视频";
    
    self.tipsView = [[[NSBundle mainBundle] loadNibNamed:@"KMMSizeTipsView" owner:nil options:nil] lastObject];
    self.tipsView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.tipsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    

    [self.tipsView setCancelBlock:^{
        STRONG_SELF(self);
        self.tipsView.hidden = YES;
    }];
    
    [self.tipsView setReloadBlock:^{
        STRONG_SELF(self);
        self.tipsView.hidden = YES;
       [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    
    self.tipsView.hidden = YES;
   

    
    UIButton *customBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10.5, 20)];
    [customBtn setImage:[UIImage imageNamed:@"icon-fh"] forState:UIControlStateNormal];
    
    
    [customBtn bk_whenTapped:^{
        STRONG_SELF(self);
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    
    
    //获取视频授权
    if (![self isCanUsePhotos]) {
        UIAlertController *alterContor = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请在iPhone的\"设置-隐私-照片\"中允许访问照片." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alterContor addAction:action];
        
        [self.navigationController presentViewController:alterContor animated:YES completion:nil];
        
        return;
    }
    
    
    
        
        self.cwArr = [NSMutableArray array];
        self.allDataArr = [NSMutableArray array];
        self.dataArr = [NSMutableArray array];
        self.view.backgroundColor = [UIColor whiteColor];
        
        [self loadVideosWithSuccessBlock:^{
            STRONG_SELF(self);
            [self.VideoCollectionView reloadData];
        }];
    
    
//        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44 - 64, SCREEN_WIDTH, 44)];
        UIView *bottomView = [[UIView alloc]init];
    
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bottomView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor grayColor];
        [bottomView addSubview:lineView];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [btn setTitle:@"拍摄新视频" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = BASE_COLOR;
        [btn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:btn];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        STRONG_SELF(self);
        make.left.right.bottom.equalTo(self.view).offset(0);
        make.height.mas_equalTo(44);
        
    }];
    
    [self.view addSubview:self.VideoCollectionView];
    [self.VideoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.top.equalTo(self.view).offset(0);
        make.bottom.equalTo(bottomView.mas_top).equalTo(0);
        
    }];
}

- (BOOL)isCanUsePhotos {
    

        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
    
    return YES;
}

#pragma mark -UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//如果是录制视频

        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr=[url path];
        self.urlString = urlStr;
        
//        NSInteger fileSize = [self getVideoInfoWithSourcePath:self.urlString];
//        if (fileSize>80) {
//            self.tipsView.hidden = NO;
//            [[UIApplication sharedApplication].keyWindow addSubview:self.tipsView];
//        }else {
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
                //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
            }
//        }

       
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)getVideoInfoWithSourcePath:(NSString *)path{
    
    NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    
    return fileSize/1024/1024;
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
     //   NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
        
       // [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    }else{
     //   NSLog(@"视频保存成功.");
        //录制完之后自动播放

        [self.allDataArr removeAllObjects];
        [self.cwArr removeAllObjects];
        [self.dataArr removeAllObjects];
        
        
        [self loadVideosWithSuccessBlock:^{
            
            
            
            if (self.allDataArr.count>0) {
                if ([self.allDataArr[0] count]>0) {
                    AlbumVideoInfo *model = [self.allDataArr[0] lastObject];
                    

                    WEAK_SELF(self);
                    [self getVideoPathFromPHAsset:model.asset Complete:^(NSString *filePaht, NSString *filenNaem) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            STRONG_SELF(self);
                            KMMCompleteVideoInfoController *completVC = [[KMMCompleteVideoInfoController alloc]init];
                            completVC.enablePreView = YES;
                            completVC.time = model.duration;
                            completVC.model = model;
                            completVC.filePath = filePaht;
                            completVC.fileName = [filePaht lastPathComponent];
                            [self.navigationController pushViewController:completVC animated:YES];
                        });
                    }];

                    
                }
            }
            
            
            
            
           
        }];
        
        
        

    }
}

- (void)clickAction {
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

//加载视频
- (void)loadVideosWithSuccessBlock:(void(^)())success{
    
    NSOperationQueue *queen = [[NSOperationQueue alloc]init];
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        
        
        PHFetchOptions * fetchOptions = [[PHFetchOptions alloc] init];
        PHFetchResult * fetchResult =[PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:fetchOptions];
        
        NSMutableArray *assetArray = [NSMutableArray array];
        [fetchResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop){
            
            
                 [assetArray addObject:asset];
          
            
        }];
        
        for (int i=0; i<assetArray.count; i++) {
            
            PHAsset *asset = assetArray[i];
            AlbumVideoInfo *info = [[AlbumVideoInfo alloc]init];
            info.asset = asset;
            NSString *creatDate = [self getFormatedDateStringOfDate:asset.creationDate];
            info.creatDate = creatDate;
            info.duration = asset.duration;
            [self.dataArr addObject:info];
        }
        
        for (AlbumVideoInfo *model in _dataArr) {
            // 是否包含
            BOOL isContains = NO;
            for (NSMutableArray * arr in _allDataArr) {
                for (AlbumVideoInfo * m in arr) {
                    if ([m.creatDate isEqualToString:model.creatDate]) {
                        // 将包含设置为YES
                        isContains = YES;
                        // 赋值给全局的arr 用于出了for循环的作用域进行操作
                        _cwArr = arr;
                        break;
                    }
                }
                if (isContains) {
                    break;
                }
            }
            if (isContains) {
                [_cwArr addObject:model];
            }else{
                NSMutableArray * categoryArr = [NSMutableArray array];
                [categoryArr addObject:model];
                [_allDataArr addObject:categoryArr];
            }
            
        }
        
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        
        for (NSMutableArray *arr in self.allDataArr) {
            for (AlbumVideoInfo *videoInfo in arr) {
                [imageManager requestImageForAsset:videoInfo.asset
                 
                                        targetSize:CGSizeMake(320, 320)
                 
                                       contentMode:PHImageContentModeAspectFit
                 
                                           options:nil
                 
                                     resultHandler:^(UIImage *result, NSDictionary *info) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             
                                             if ([[info valueForKey:@"PHImageResultIsDegradedKey"]integerValue]==1){
                                                 videoInfo.videoImage =  result;
                                                 
                                             }
                                             
                                         });
                                         
                                }];
                
            }
        }
        
        
       
        
        
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        PHVideoRequestOptions *videofetchOptions = [[PHVideoRequestOptions alloc] init];
        
        for (NSMutableArray *arr in self.allDataArr) {
            for (AlbumVideoInfo *videoInfo in arr) {
                
                                         
                    [imageManager requestAVAssetForVideo:videoInfo.asset options:videofetchOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                                             
                            NSString *videoURLStr = [NSString stringWithFormat:@"%@",((AVURLAsset *)asset).URL];
                            videoInfo.videoURL = [NSURL URLWithString:videoURLStr];
                                             
                        }];
              }
        }
    }];
    
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSArray *array = [[self.allDataArr reverseObjectEnumerator] allObjects];
            [self.allDataArr removeAllObjects];
            [self.allDataArr addObjectsFromArray:array];
            
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.view addSubview:self.VideoCollectionView];
//            });
            
            [self.VideoCollectionView reloadData];
            
            if (success) {
                success();
            }
        });
        
    }];
    
    [operation2 addDependency:operation1];
    [operation3 addDependency:operation2];
    
    [queen addOperation:operation1];
    [queen addOperation:operation2];
    [queen addOperation:operation3];
    
    
    
    
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KMMVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KMMVideoCell" forIndexPath:indexPath];
    cell.videoModel = self.allDataArr[indexPath.section][indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.allDataArr.count;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.allDataArr[section] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    KMMVideoTitleReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KMMVideoTitleReusableView" forIndexPath:indexPath];
    
    NSString *title = [self.allDataArr[indexPath.section][0] creatDate];
    header.titleLabel.text = title;
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((SCREEN_WIDTH-50)/3, 93);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    
    CGSize size = CGSizeZero;
    size = CGSizeMake(SCREEN_WIDTH, 32.5);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumVideoInfo *model = self.allDataArr[indexPath.section][indexPath.row];
    
        KMMPreviewController *previewVC = [[KMMPreviewController alloc]init];
        previewVC.fileURL = model.videoURL;
        previewVC.fileName = [model.videoURL.absoluteString lastPathComponent];
        previewVC.time = model.duration;
        previewVC.model = model;
        [self.navigationController pushViewController:previewVC animated:YES];

}

- (void)getVideoPathFromPHAsset:(PHAsset *)asset Complete:(void(^)(NSString *filePaht,NSString *filenNaem))result {
    
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    
    for (PHAssetResource *assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo ||
            assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }
    NSString *fileName = @"tempAssetVideo.mov";
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }
    
   // long long size = [[resource valueForKey:@"fileSize"] longLongValue];

    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        NSString *PATH_MOVIE_FILE = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",fileName]];
        
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 result(nil, nil);
                                                             } else {
                                                                 
                                                          //  NSInteger size = [self getVideoInfoWithSourcePath:PATH_MOVIE_FILE];
                                                                 [KMMCompressionVideoTool compressedVideoOtherMethodWithURL:[NSURL fileURLWithPath:PATH_MOVIE_FILE] fileName:fileName  compressionType:AVAssetExportPresetMediumQuality compressionResultPath:^(NSString *resultPath, float memorySize) {
                                                                     
                                                                     NSMutableString *string = [[NSMutableString alloc]init];
                                                                     
                                                                     NSMutableArray *nameArr = [NSMutableArray arrayWithArray:[fileName componentsSeparatedByString:@"."]];
                                                                     [nameArr removeLastObject];
                                                                     for (NSString *subName in nameArr) {
                                                                         [string appendString:subName];
                                                                     }
                                                                     
                                                                     NSString *realName = [NSString stringWithFormat:@"KMM%@.mp4",string];

                                                                     long long size =     [self getVideoInfoWithSourcePath:resultPath];
                                                                     
                                                                    
                                                                     if (size > 80) {
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                         UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"文件过大" message:@"上传的视频大小不得超过80M,\n请重新选择视频进行上传" preferredStyle:UIAlertControllerStyleAlert];
                                                                         
                                                                         
                                                                         
                                                                         UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"重新拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                             
                                                                             
                                                                           
                                                                            
                                                                            
                                                                                   [[NSFileManager defaultManager] removeItemAtPath:resultPath error:nil];
                                                                                 [self presentViewController:self.imagePicker animated:YES completion:nil];
                                                                          
                                                                             
                                                                             
                                                                         }];
                                                                         
                                                                         [alterVC addAction:action1];
                                                                         
                                                                         [self.navigationController presentViewController:alterVC animated:YES completion:nil];
                                                                         
                                                                         return;
                                                                     });
                                                                          
                                                                     }else {
                                                                     if (result) {
                                                                         result(resultPath,realName);
                                                                        }
                                                                     }
                                                                 }];
                                                             }
                                                         }];
    } else {
        result(nil, nil);
    }
}

#pragma mark - Lazy Load
- (UICollectionView *)VideoCollectionView {
    if (_VideoCollectionView == nil) {
        
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _VideoCollectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-64 - 50) collectionViewLayout:flowLayout];
        _VideoCollectionView.backgroundColor = [UIColor whiteColor];
        _VideoCollectionView.delegate = self;
        _VideoCollectionView.dataSource = self;
        [_VideoCollectionView registerClass:[KMMVideoTitleReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KMMVideoTitleReusableView"];
        [_VideoCollectionView registerNib:[UINib nibWithNibName:@"KMMVideoCell" bundle:nil] forCellWithReuseIdentifier:@"KMMVideoCell"];
        
        
    }
    return _VideoCollectionView;
    
}

-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker=[[UIImagePickerController alloc]init];
        _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;//设置image picker的来源，这里设置为摄像头
        _imagePicker.cameraDevice=UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像头
        _imagePicker.mediaTypes=@[(NSString *)kUTTypeMovie];
        _imagePicker.videoQuality=UIImagePickerControllerQualityTypeMedium;
        _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
        _imagePicker.delegate=self;//设置代理，检测操作
    }
    return _imagePicker;
}

-(NSString*)getFormatedDateStringOfDate:(NSDate*)date{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy.MM"]; //注意时间的格式：MM表示月份，mm表示分钟，HH用24小时制，小hh是12小时制。
    NSString* dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (UIImage*)getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
