//
//  KMMCompleteVideoInfoController.m
//  Maintenance
//
//  Created by kmcompany on 2017/7/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "TZImagePickerController.h"
#import "TZImageManager.h"


#import "KMMCompleteVideoInfoController.h"
#import "KMMCompletTitleCell.h"
#import "KMMCompletContentCell.h"

#import "KMMEnumsModel.h"
#import "BATMyFindEqualCellFlowLayout.h"
#import "KMMKeyWordCell.h"
#import "KMMCourseFooterCell.h"
#import "KMMCourseHeaderCell.h"

#import "KMMVideoImageChooseController.h"

#import "KMMUpLoadListController.h"

#import "JQFMDB.h"

#import "UploadTable.h"
#import "KMMCompressionVideoTool.h"

#import "KMMGetURLFileLengthTool.h"

#import "KMMVideoPickerController.h"
#import "KMMPreviewController.h"

@interface KMMCompleteVideoInfoController ()<UITableViewDelegate,UITableViewDataSource,KMMCompletTitleCellDelegate,KMMCompletContentCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{

}

@property (nonatomic,strong) KMMEnumsModel *listModel;

@property (nonatomic,strong) UITableView *fillTab;

@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) UIButton *locoalBtn;

@property (nonatomic,strong) UIButton *pickerBtn;

@property (nonatomic,strong) UIImageView *posterImage;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSString *CourseName;

@property (nonatomic,strong) NSString *CourseID;

@property (nonatomic,strong) UIControl *backView;

@property (nonatomic,strong) UIButton *footerBtn;

@property (nonatomic,strong) EnumsArr *enumsArr;

@end

@implementation KMMCompleteVideoInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self pageLayout];
}

- (void)popAction {
   
        UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"关闭课程将导致编辑内容无法找回,确认关闭?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *action1  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alterVC addAction:action];
        [alterVC addAction:action1];
        
        [self.navigationController presentViewController:alterVC animated:YES completion:nil];
        
    
}

#pragma mark - pageLayout
- (void)pageLayout {

    self.title = self.classModel? @"修改视频信息":@"编辑视频信息";
    [self.view addSubview:self.fillTab];
    [self tableFooterView];
    
    [self.backView addSubview:self.collectionView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
    self.backView.hidden = YES;
    [self getCourseCategorygetRequest];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon-fh"] style:UIBarButtonItemStyleDone target:self action:@selector(popAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    if (self.classModel) {
        self.CourseName = self.classModel.CourseCategoryAlias;
        self.CourseID = self.classModel.CourseCategory;
    }
}

#pragma mark - 获取课程分类
- (void)getCourseCategorygetRequest {
    
    [HTTPTool requestWithURLString:@"/api/Teacher/GetEnums" parameters:@{@"category":@"CourseCategory"} type:kGET success:^(id responseObject) {
        self.listModel = [KMMEnumsModel mj_objectWithKeyValues:responseObject];
        //  NSLog(@"%@",[self.listModel.Data[0] Name]);
        [self.collectionView reloadData];
        KMMCourseFooterCell *cell2 = (KMMCourseFooterCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        CGFloat collectionViewHeight2 = CGRectGetMaxY(cell2.frame);
        self.collectionView.frame = CGRectMake((SCREEN_WIDTH - 300)/2, 190, 300, collectionViewHeight2);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0 || indexPath.row == 2) {
        return 44;
    }
    
    if (indexPath.row == 1) {
        return 127;
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row != 1) {
        KMMCompletTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMCompletTitleCell"];
        cell.pathRow = indexPath;
        cell.delegate = self;
        if (indexPath.row == 0) {
            cell.titleLb.text = @"课程标题:";
            cell.yyTextView.placeholder = @"请输入20字以内的课程标题";
            cell.yyTextView.userInteractionEnabled = YES;
            if (self.classModel) {
                cell.yyTextView.text = self.classModel.CourseTitle;
            }
            

        }else {
            cell.titleLb.text = @"课程分类:";
            cell.yyTextView.placeholder = @"请选择课程分类";
            cell.yyTextView.userInteractionEnabled = NO;

            if (self.classModel) {
                cell.yyTextView.text = self.classModel.CourseCategoryAlias;
            }else {
                cell.yyTextView.text = self.CourseName;
            }
        }
        return cell;
    }
    
    KMMCompletContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMCompletContentCell"];
    cell.titleLb.text = @"课程简介:";
    cell.yyTextView.placeholderText = @"请选择50字以内的课程简介";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (self.classModel) {
        cell.yyTextView.text = self.classModel.CourseDesc;
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2) {
        [self.view endEditing:YES];
        self.backView.hidden = NO;

    }
}

#pragma mark - KMMCompletTitleCellDelegate
- (void)KMMCompletTitleCellWithContent:(UITextField *)yytextView {

    if (yytextView.tag == 0) {
        if (yytextView.text.length >20) {
            
            UITextRange *markeRange = [yytextView markedTextRange];
            if (markeRange) {
                return;
            }
            [self showText:@"请输入4-20字的课程标题"];
            NSRange range = [yytextView.text rangeOfComposedCharacterSequenceAtIndex:20];
            yytextView.text = [yytextView.text substringToIndex:range.location];
            if (self.classModel) {
                self.classModel.CourseTitle = yytextView.text;
            }
        }else {
            if (self.classModel) {
                self.classModel.CourseTitle = yytextView.text;
            }
        }
    }
    
    
    
}

#pragma mark - KMMCompletContentCellDelegate
- (void)KMMCompletContentCellWithContent:(YYTextView *)yytextView {
    if (yytextView.text.length >50) {
        
//        UITextRange *markeRange = [yytextView markedTextRange];
//        if (markeRange) {
//            return;
//        }
        [self showText:@"请输入10-50字的课程简介"];
        NSRange range = [yytextView.text rangeOfComposedCharacterSequenceAtIndex:50];
        yytextView.text = [yytextView.text substringToIndex:range.location];
        if (self.classModel) {
            self.classModel.CourseDesc = yytextView.text;
        }
        
    }else {
        if (self.classModel) {
            self.classModel.CourseDesc = yytextView.text;
        }
    }
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return self.listModel.Data.count;
    }
    if (section == 2) {
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        KMMCourseHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KMMCourseHeaderCell" forIndexPath:indexPath];
        return cell;
    }
    
    if (indexPath.section == 2) {
        KMMCourseFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KMMCourseFooterCell" forIndexPath:indexPath];
        WEAK_SELF(self);
        [cell.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cell.RightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [cell setClickBlock:^(NSInteger tag,UIButton *btn){
            STRONG_SELF(self);
            
            if (tag == 1) {
                
                self.CourseName = self.enumsArr.Text;
                self.CourseID = self.enumsArr.Code;
                
                if (self.CourseID == nil || [self.CourseID isEqualToString:@""]) {
                    [self showText:@"请选择类别"];
                    return;
                }
                
                for (EnumsArr *enumsModel in self.listModel.Data) {
                    enumsModel.isSelect = NO;
                    [self.collectionView reloadData];
                }
               
                if (self.classModel) {
                    self.classModel.CourseCategoryAlias = self.CourseName;
                }
                
                self.backView.hidden = YES;
                [self.fillTab reloadData];
            }
            
            if (tag == 0) {
                for (EnumsArr *enumsModel in self.listModel.Data) {
                    enumsModel.isSelect = NO;
                    [self.collectionView reloadData];
                }
                self.backView.hidden = YES;
               // self.CourseID = nil;
            }
            
        }];
        return cell;
    }
    
    KMMKeyWordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KMMKeyWordCell" forIndexPath:indexPath];
    
    if (self.listModel.Data.count > 0) {
        
        EnumsArr *data = self.listModel.Data[indexPath.row];
        
        cell.keyLabel.text = data.Text;
        
        if (data.isSelect) {
            cell.keyLabel.textColor = [UIColor whiteColor];
            cell.layer.borderColor = BASE_COLOR.CGColor;
            cell.backgroundColor = BASE_COLOR;
        }else {
            cell.layer.borderColor = BASE_BACKGROUND_COLOR.CGColor;
            cell.keyLabel.textColor = UIColorFromHEX(0X333333, 1);
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.listModel.Data.count > 0) {
            EnumsArr *data = self.listModel.Data[indexPath.row];
            
            CGSize textSize = [data.Text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
            return CGSizeMake(textSize.width+20, 30);
        }
    }
    
    if (indexPath.section == 0) {
        return CGSizeMake(300, 42.5);
    }
    
    if (indexPath.section == 2) {
        return CGSizeMake(300, 42.5);
    }
    
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section == 1) {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.listModel.Data.count > 0) {
            
            for (EnumsArr *data in self.listModel.Data) {
                data.isSelect = NO;
            }
            
            EnumsArr *data = self.listModel.Data[indexPath.row];
            data.isSelect = YES;
            self.enumsArr = data;
//            self.CourseName = data.Text;
//            self.CourseID = data.Code;
            [self.collectionView reloadData];
            
        }
    }
    
}


#pragma mark - Lazy Load
- (UITableView *)fillTab {

    if (!_fillTab) {
        _fillTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _fillTab.tableHeaderView = [self tableheaderView];
        _fillTab.dataSource = self;
        _fillTab.delegate = self;
        [_fillTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _fillTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_fillTab registerClass:[KMMCompletTitleCell class] forCellReuseIdentifier:@"KMMCompletTitleCell"];
        [_fillTab registerClass:[KMMCompletContentCell class] forCellReuseIdentifier:@"KMMCompletContentCell"];
        
    }
    return _fillTab;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        BATMyFindEqualCellFlowLayout * flowLayout = [[BATMyFindEqualCellFlowLayout alloc] init];
        flowLayout.maximumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 190, 300, 100) collectionViewLayout:flowLayout];
        _collectionView.clipsToBounds = YES;
        _collectionView.layer.cornerRadius = 5;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[KMMKeyWordCell class] forCellWithReuseIdentifier:@"KMMKeyWordCell"];
        
        [_collectionView registerClass:[KMMCourseHeaderCell class] forCellWithReuseIdentifier:@"KMMCourseHeaderCell"];
        
        [_collectionView registerClass:[KMMCourseFooterCell class] forCellWithReuseIdentifier:@"KMMCourseFooterCell"];
    }
    return _collectionView;
}

- (UIControl *)backView {
    
    if (!_backView) {
        _backView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [_backView addSubview:self.collectionView];
        
      //  [_backView addTarget:self action:@selector(dismissViewAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backView;
}

- (void)dismissViewAction {

    self.backView.hidden = YES;
    self.CourseID = nil;
    
    for (EnumsArr *enumsModel in self.listModel.Data) {
        enumsModel.isSelect = NO;
        [self.collectionView reloadData];
    }
    
}

- (void)tableFooterView {
    
//    self.footerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50-64, SCREEN_WIDTH, 50)];
    self.footerBtn = [[UIButton alloc]init];
    if (self.classModel) {
         [self.footerBtn setTitle:@"完 成" forState:UIControlStateNormal];
    }else {
     [self.footerBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
   
    [self.footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.footerBtn.backgroundColor = BASE_COLOR;
//    btn.layer.borderWidth = 1;
//    btn.layer.borderColor = BASE_BACKGROUND_COLOR.CGColor;
    
   
    WEAK_SELF(self);
    [self.footerBtn bk_whenTapped:^{
        
        
       
        STRONG_SELF(self);
        
        if (self.posterImage.image == nil) {
            [self showText:@"请上传封面"];
            return;
        }
        
        KMMCompletTitleCell *cell = (KMMCompletTitleCell *)[self.fillTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (cell.yyTextView.text == nil || [cell.yyTextView.text isEqualToString:@""] || [[cell.yyTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
            [self showText:@"请输入4-20字的课程标题"];
            return;
        }
        
        if ([[cell.yyTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] <4) {
            [self showText:@"请输入4-20字的课程标题"];
            return;
        }
        
        KMMCompletContentCell *contentCell = (KMMCompletContentCell *)[self.fillTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        if (contentCell.yyTextView.text == nil || [contentCell.yyTextView.text isEqualToString:@""] || [[contentCell.yyTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
            [self showText:@"请输入10-50字的课程简介"];
            return;
        }
        
        if (contentCell.yyTextView.text.length <10) {
            [self showText:@"请输入10-50字的课程简介"];
            return;
        }
        
        KMMCompletTitleCell *catagaryCell = (KMMCompletTitleCell *)[self.fillTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        if (catagaryCell.yyTextView.text == nil || [catagaryCell.yyTextView.text isEqualToString:@""] || [[catagaryCell.yyTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0 || self.CourseID == nil) {
            [self showText:@"请选择课程分类"];
            return;
        }
        
       
        
        if (self.classModel) {
            self.footerBtn.userInteractionEnabled = NO;
            WEAK_SELF(self);
            [HTTPTool requestUploadImageToBATWithParams:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                // 将本地的文件上传至服务器
                
                UIImage *image = self.posterImage.image;
                NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
                [formData appendPartWithFileData:imageData
                                            name:@"dynamic_picture"
                                        fileName:@"dynamic_picture.jpg"
                                        mimeType:@"multipart/form-data"];
                
            } success:^(NSArray *imageArray) {
                
                BATImage *imageModel = [[BATImage mj_objectArrayWithKeyValuesArray:imageArray] lastObject];
                
                self.classModel.Poster = imageModel.url;
                STRONG_SELF(self);
                [self uploadClassRequest:self.footerBtn title:cell.yyTextView.text content:contentCell.yyTextView.text];
                
            } failure:^(NSError *error) {
                self.footerBtn.userInteractionEnabled = YES;
            } fractionCompleted:^(double count) {
                
            }];
            
            
            
        }else {
            self.footerBtn.userInteractionEnabled = NO;
            
            NSString *netSateString = [[NSUserDefaults standardUserDefaults] valueForKey:@"NetState"];
            
             BOOL enableShowTips = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isShowTips"] boolValue];
        
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowTips"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
                if([netSateString isEqualToString:@"phoneNet"]){
                    
                    if (!enableShowTips) {
                        UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"检测到当前网络是非wifi状态,上传视频可能要耗费4G/3G/2G流量,确定上传?" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            self.footerBtn.userInteractionEnabled = YES;
                        }];
                        
                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                            
                            [self showProgressWithText:@"正在提交文件"];
                            [self getVideoPathFromPHAsset:self.model.asset Complete:^(NSString *filePaht, NSString *filenNaem) {
                                self.filePath = filePaht;
                                self.fileName = filenNaem;
                                [self dismissProgress];
                                [self uploadPosterImage];
                            }];
                        }];
                        
                        [alterVC addAction:action];
                        [alterVC addAction:action1];
                        
                        [self.navigationController presentViewController:alterVC animated:YES completion:nil];
                    }else {
                        [self showProgressWithText:@"正在提交文件"];
                        [self getVideoPathFromPHAsset:self.model.asset Complete:^(NSString *filePaht, NSString *filenNaem) {
                            self.filePath = filePaht;
                            self.fileName = filenNaem;
                            [self dismissProgress];
                            [self uploadPosterImage];
                        }];
                    }
                    
                    
                    
                }else if([netSateString isEqualToString:@"NoNet"]) {
                    
                    [self showText:@"当前无网络"];
                    self.footerBtn.userInteractionEnabled = YES;
                    
                }else if([netSateString isEqualToString:@"WIFI"]) {
                    
                    [self showProgressWithText:@"正在提交文件"];
                    [self getVideoPathFromPHAsset:self.model.asset Complete:^(NSString *filePaht, NSString *filenNaem) {
                        self.filePath = filePaht;
                        self.fileName = filenNaem;
                        [self dismissProgress];
                         [self uploadPosterImage];
                    }];
                   
                }

        }
    
       
        
    }];
    [self.view addSubview:self.footerBtn];
    [self.footerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        STRONG_SELF(self);
        make.bottom.left.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(40);
        
    }];
}

#pragma 将视频文件写入本地
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
//                                                                 result(PATH_MOVIE_FILE, fileName);
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
                                                                         UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"文件过大" message:@"上传的视频大小不得超过80M,\n请重新选择视频进行上传" preferredStyle:UIAlertControllerStyleAlert];
                                                                         
                                                                         
                                                                         
                                                                         UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去选择新视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                             
                                                                             
                                                                             [[NSFileManager defaultManager] removeItemAtPath:resultPath error:nil];
                                                                             
                                                                             NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
                                                                             for (UIViewController *vc in marr) {
                                                                                 if ([vc isKindOfClass:[KMMPreviewController class]]) {
                                                                                     [marr removeObject:vc];
                                                                                     break;
                                                                                 }
                                                                             }
                                                                             self.navigationController.viewControllers = marr;
                                                                             
                                                                             [self.navigationController popViewControllerAnimated:YES];
                                                                             
                                                                         }];
                                                                        
                                                                         [alterVC addAction:action1];
                                                                         
                                                                         [self.navigationController presentViewController:alterVC animated:YES completion:nil];
                                                                         
                                                                         return;
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

- (NSInteger)getVideoInfoWithSourcePath:(NSString *)path{
    
    long long   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    
    return fileSize/1024/1024;
}


#pragma mark - 更新视频课程
- (void)uploadClassRequest:(UIButton *)btn title:(NSString *)title content:(NSString *)content {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.classModel.Id forKey:@"Id"];
    [dict setValue:self.CourseID forKey:@"CourseCategory"];
    [dict setValue:title forKey:@"CourseTitle"];
    [dict setValue:content forKey:@"CourseDesc"];
    [dict setValue:@"20" forKey:@"ClassHour"]; //固定20
    [dict setValue:self.classModel.Poster forKey:@"Poster"];
    [dict setValue:self.classModel.AttachmentUrl forKey:@"AttachmentUrl"]; //传空
    [dict setValue:@(0) forKey:@"Auditing"];
    [dict setValue:@"" forKey:@"CourseType"];
    [dict setValue:@"" forKey:@"MainContent"];
    
    
    [HTTPTool requestWithURLString:@"/api/Course/EditCourse" parameters:dict type:kPOST success:^(id responseObject) {
        self.footerBtn.userInteractionEnabled = YES;
        for (EnumsArr *enumsModel in self.listModel.Data) {
            enumsModel.isSelect = NO;
            [self.collectionView reloadData];
        }
        [self showSuccessWithText:@"编辑成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        self.footerBtn.userInteractionEnabled = YES;
        btn.userInteractionEnabled = YES;
        for (EnumsArr *enumsModel in self.listModel.Data) {
            enumsModel.isSelect = NO;
            [self.collectionView reloadData];
        }
        
        [self showText:@"服务器开小差啦    请重新保存"];
        
    }];

}

- (UIView *)tableheaderView {


    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor whiteColor];
    
    self.posterImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
    self.posterImage.userInteractionEnabled = YES;
    
    if (self.classModel) {
        [self.posterImage sd_setImageWithURL:[NSURL URLWithString:self.classModel.Poster] placeholderImage:[UIImage new]];
    }
    [backView addSubview:self.posterImage];
    
    
    self.locoalBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4-60, 95, 120, 30)];
    self.locoalBtn.backgroundColor = UIColorFromHEX(0Xe5e5e5, 1);
    [self.locoalBtn setTitle:@"本地上传封面" forState:UIControlStateNormal];
    [self.locoalBtn setTitleColor:UIColorFromHEX(0X000000, 1) forState:UIControlStateNormal];
    self.locoalBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.locoalBtn.clipsToBounds = YES;
    self.locoalBtn.layer.cornerRadius = 5;
    WEAK_SELF(self);
    [self.locoalBtn bk_whenTapped:^{
        STRONG_SELF(self);
        [self getPhotosFromLocal];

    }];
    [self.posterImage addSubview:self.locoalBtn];
    
    self.pickerBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+SCREEN_WIDTH/4-70, 95, 140, 30)];
    self.pickerBtn.backgroundColor = UIColorFromHEX(0Xe5e5e5, 1);
    [self.pickerBtn setTitle:@"从视频中选取封面" forState:UIControlStateNormal];
     [self.pickerBtn setTitleColor:UIColorFromHEX(0X000000, 1) forState:UIControlStateNormal];
    self.pickerBtn.clipsToBounds = YES;
     self.pickerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.pickerBtn.layer.cornerRadius = 5;
    [self.pickerBtn bk_whenTapped:^{
        STRONG_SELF(self);
        KMMVideoImageChooseController *videoImageVC = [[KMMVideoImageChooseController alloc]init];
        videoImageVC.fileName = self.fileName;
        videoImageVC.time = self.time;
        videoImageVC.fileURL = self.filePath;
        videoImageVC.enablePreView = self.enablePreView;
        [videoImageVC setImageBlock:^(UIImage *image){
            self.posterImage.image = image;
        }];
        [self.navigationController pushViewController:videoImageVC animated:YES];
    }];
    [self.posterImage addSubview:self.pickerBtn];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 210, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    [self.posterImage addSubview:lineView];
    
    if (self.isEdit) {
        [self.locoalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.equalTo(backView.mas_centerX);
            make.centerY.equalTo(backView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(120, 30));
            
        }];
        self.pickerBtn.hidden = YES;
    }
    
    return backView;
}

#pragma mark - 从本地相册获取图片
- (void)getPhotosFromLocal
{
    WEAK_SELF(self);
    TZImagePickerController *tzImagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:(1) delegate:self];
    tzImagePickerVC.allowPickingVideo = NO;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [tzImagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        STRONG_SELF(self);
        self.posterImage.image = photos[0];
    }];
    
    [self presentViewController:tzImagePickerVC animated:YES completion:nil];
    
}


#pragma mark - 上传封面
- (void)uploadPosterImage {

    WEAK_SELF(self);
    [HTTPTool requestUploadImageToBATWithParams:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 将本地的文件上传至服务器

      //  dispatch_async(dispatch_get_main_queue(), ^{
             UIImage *image = self.posterImage.image;
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            [formData appendPartWithFileData:imageData
                                        name:@"dynamic_picture"
                                    fileName:@"dynamic_picture.jpg"
                                    mimeType:@"multipart/form-data"];
      //  });
        
    
    } success:^(NSArray *imageArray) {
        STRONG_SELF(self);
        [self dismissProgress];
       

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"uploadStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        BATImage *imageModel = [[BATImage mj_objectArrayWithKeyValuesArray:imageArray] lastObject];
        
        KMMCompletTitleCell *TitleCell = (KMMCompletTitleCell *)[self.fillTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        KMMCompletContentCell *contentCell = (KMMCompletContentCell *)[self.fillTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
  
        dispatch_async(dispatch_get_main_queue(), ^{
            UploadTable *table1 = [[UploadTable alloc] init];
            table1.upload_name = TitleCell.yyTextView.text;
            table1.upload_text = contentCell.yyTextView.text;
            table1.upload_progress = 0;
            table1.upload_id = self.CourseID;
            table1.upload_photo_path = imageModel.url;
            table1.upload_status = 0;
            table1.upload_file_path = self.filePath;
            
            NSString *randomString = [NSString stringWithFormat:@"TokenRandom%@",[Tools randomArray]];
            
            table1.upload_file_token = randomString;
            table1.upload_file_name = self.fileName;
            
            JQFMDB *modelDB = [JQFMDB shareDatabase];
            
            NSString *accountID = [NSString stringWithFormat:@"Person%@",[Tools getCurrentID]];
            
            if ([modelDB jq_createTable:accountID dicOrModel:[UploadTable new]]) {
                NSLog(@"yes");
            }else {
                NSLog(@"no");
            }
            
          //  [modelDB jq_deleteAllDataFromTable:@"upLoadTable"];
            
            if ( [modelDB jq_insertTable:accountID dicOrModel:table1]) {
                NSLog(@"插入成功");
                dispatch_async(dispatch_get_main_queue(), ^{

//                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [self backToRootViewController];
                    
                });
                
            }else {
                NSLog(@"插入失败");
            }
           
            
            
        });
        

        
        

        
        
        
    } failure:^(NSError *error) {
         self.footerBtn.userInteractionEnabled = YES;
    } fractionCompleted:^(double count) {
        
        [self showProgres:count];
        
    }];
}

- (void)backToRootViewController{
    
    self.footerBtn.userInteractionEnabled = YES;
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STARTUPLOAD" object:nil];
    

    
}


@end
