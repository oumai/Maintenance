//
//  KMMPreviewController.m
//  Maintenance
//
//  Created by kmcompany on 2017/7/13.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMPreviewController.h"
#import "KMMCompleteVideoInfoController.h"

//#import <AVFoundation/AVFoundation.h>

#import "ZFPlayer.h"

@interface KMMPreviewController ()<ZFPlayerDelegate>


@property (nonatomic,strong) ZFPlayerControlView *controlView;

@property (nonatomic,strong) UIView *fatherView;

@property (nonatomic,strong) ZFPlayerView *playerView;

@end

@implementation KMMPreviewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   

    WEAK_SELF(self);
    [self.view addSubview:self.fatherView];
    [self.fatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT - 64);
    }];
    
    
    
   
    
    ZFPlayerModel *model = [[ZFPlayerModel alloc] init];
    model.title = @"";
    model.videoURL = self.fileURL;
    model.fatherView = self.fatherView;
    
    [self.playerView playerControlView:self.controlView playerModel:model];
    
    
    self.playerView.hasPreviewView = YES;
    
    // 自动播放
    [self.playerView autoPlayTheVideo];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 64)];
    [btn setTitle:@"使用视频" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.backgroundColor = UIColorFromRGB(23, 22, 20, 1);
    [btn bk_whenTapped:^{
        STRONG_SELF(self);
        
        if (!self.fileURL) {
            [self showText:@"该视频暂不可用,请选择其他视频"];
            return;
        }
        
//        NSArray *assetResources = [PHAssetResource assetResourcesForAsset:self.model.asset];
//        PHAssetResource *resource;
//        
//        for (PHAssetResource *assetRes in assetResources) {
//            if (assetRes.type == PHAssetResourceTypePairedVideo ||
//                assetRes.type == PHAssetResourceTypeVideo) {
//                resource = assetRes;
//            }
//        }
//        NSString *fileName = @"tempAssetVideo.mov";
//        if (resource.originalFilename) {
//            fileName = resource.originalFilename;
//        }
        
//        long long size = [[resource valueForKey:@"fileSize"] longLongValue]/1024/1024;
        
        
        [self.playerView pause];
        KMMCompleteVideoInfoController *completVC = [[KMMCompleteVideoInfoController alloc]init];
        completVC.fileName = self.fileName;
        completVC.filePath = self.fileURL.absoluteString;
        completVC.time = self.time;
        completVC.model = self.model;
        [self.navigationController pushViewController:completVC animated:YES];
        
        
    }];
    
    
    [self.view addSubview:btn];
}

//读取文件大小，暂时不用
- (NSInteger)getVideoInfoWithSourcePath:(NSString *)path{
    
    long long   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    
    return fileSize/1024/1024;
}

/** 返回按钮事件 */
- (void)zf_playerBackAction {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)fatherView
{
    if (_fatherView == nil) {
        _fatherView = [[UIView alloc] init];
        _fatherView.backgroundColor = [UIColor blackColor];
    }
    return _fatherView;
}

- (ZFPlayerView *)playerView
{
    if (_playerView == nil) {
        _playerView = [[ZFPlayerView alloc] init];
        _playerView.delegate = self;
        
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView
{
    if (_controlView == nil) {
        _controlView = [[ZFPlayerControlView alloc] init];
        _controlView.fullScreenBtn.hidden = YES;
    }
    return _controlView;
}

@end
