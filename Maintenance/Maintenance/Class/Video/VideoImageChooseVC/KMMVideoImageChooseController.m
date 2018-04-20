//
//  KMMVideoImageChooseController.m
//  Maintenance
//
//  Created by kmcompany on 2017/7/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMVideoImageChooseController.h"

#import <AVFoundation/AVAssetImageGenerator.h>
#import <MediaPlayer/MediaPlayer.h>

#import "KMMVideoImageCell.h"

#import "KMMImageInfoModel.h"

#import "BATMyFindEqualCellFlowLayout.h"

@interface KMMVideoImageChooseController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSURL *localURL;

@property (nonatomic,strong) UIImageView *posterImage;

@property (nonatomic,strong) UIButton *clickBtn;

@property (nonatomic,assign) NSInteger selectCount;

@end

@implementation KMMVideoImageChooseController

- (void)dealloc {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
}

#pragma mark - pageLayout
- (void)pageLayout {

    self.title = @"编辑视频";
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArr = [NSMutableArray array];
    

//    NSString *lastCompont = [self.filePath lastPathComponent];
  //  NSString *PATH_MOVIE_FILE = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",self.fileName]];
   // NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:self.fileName];
    if (self.enablePreView) {
        self.localURL = [NSURL fileURLWithPath:self.fileURL];
    }else {
    self.localURL = [NSURL URLWithString:self.fileURL];
    }
    WEAK_SELF(self);
    UIButton *customBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10.5, 20)];
    [customBtn setImage:[UIImage imageNamed:@"icon-fh"] forState:UIControlStateNormal];

    [customBtn bk_whenTapped:^{
        STRONG_SELF(self);
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];

    CGFloat time = self.time/10.0;
    NSInteger count = 0;
    for (CGFloat i=0 ; i<self.time; i+=time) {
        count += 1;
        KMMImageInfoModel *model = [KMMImageInfoModel new];
        if (i == 0) {
            model.isSelect = YES;
        }
        
        [self thumbnailImageRequest:i witModel:model];
        if (count >=10) {
            break;
        }
    }

    [self.view addSubview:self.collectionView];
    
    UIImageView *leftBut = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"but-left"]];
    leftBut.frame = CGRectMake(0, 200, 14.5, 73);
    [self.view addSubview:leftBut];
    
    UIImageView *RightBut = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"but-right"]];
    RightBut.frame = CGRectMake(SCREEN_WIDTH - 14.5, 200, 14.5, 73);
    [self.view addSubview:RightBut];
    
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    [self.view addSubview:view];
    
    
    self.posterImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 0, 200, 200)];
    if (self.dataArr.count >0) {
        self.posterImage.image = [self.dataArr[0] VideoImage];
    }
    [view addSubview:self.posterImage];
    
    
    UILabel *tipsLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 308, SCREEN_WIDTH, 30)];
    tipsLb.text = @"点击方框选择封面";
    tipsLb.font = [UIFont systemFontOfSize:18];
    tipsLb.textColor = UIColorFromHEX(0X999999, 1);
    tipsLb.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipsLb];
    
    self.clickBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50-64, SCREEN_WIDTH, 50)];
    [self.clickBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.clickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.clickBtn.backgroundColor = BASE_COLOR;
    [self.clickBtn addTarget:self action:@selector(clickBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clickBtn];
    
}

- (void)clickBtnAction {

    UIImage *image = [self.dataArr[self.selectCount] VideoImage];
    if (self.ImageBlock) {
        self.ImageBlock(image);
    }
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    KMMVideoImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KMMVideoImageCell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(69, 73);

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    self.posterImage.image = [self.dataArr[indexPath.row] VideoImage];
    self.selectCount = indexPath.row;
    for (int i=0; i<self.dataArr.count; i++) {
        KMMImageInfoModel *model = self.dataArr[i];
        model.isSelect = NO;
        if (i == indexPath.row) {
            model.isSelect = YES;
        }
    }
    [self.collectionView reloadData];
}


#pragma mark - Lazy Load
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(14.5, 200, SCREEN_WIDTH - 29, 73) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[KMMVideoImageCell class] forCellWithReuseIdentifier:@"KMMVideoImageCell"];
    }
    return _collectionView;
}

-(void)thumbnailImageRequest:(CGFloat )timeBySecond witModel:(KMMImageInfoModel *)model{
    //创建URL
    NSURL *url=self.localURL;
    //根据url创建AVURLAsset
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    /*截图
     * requestTime:缩略图创建时间
     * actualTime:缩略图实际生成的时间
     */
    NSError *error=nil;
    CMTime time=CMTimeMakeWithSeconds(timeBySecond, 10);//CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    CMTimeShow(actualTime);
    UIImage *image=[UIImage imageWithCGImage:cgImage];//转化为UIImage
    //保存到相册
    // UIImageWriteToSavedPhotosAlbum(image,nil, nil, nil);
    model.VideoImage = image;
    [self.dataArr addObject:model];
    CGImageRelease(cgImage);
}


@end
