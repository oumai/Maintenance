//
//  KMMUserFeedbackController.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/7.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMUserFeedbackController.h"
#import "TZImagePickerController.h"
#import <AVFoundation/AVFoundation.h>
#import "BATPhotoBrowserController.h"

//CELL
#import "KMMFeedBackContentCell.h"
#import "BATAddPicTableViewCell.h"
#import "KMMMailCell.h"
#import "KMMFeedFooterCell.h"

// NSObject
#import "TZImageManager.h"
#import "NSString+Common.h"

@interface KMMUserFeedbackController ()<UITableViewDelegate,UITableViewDataSource,BATAddPicTableViewCellDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,KMMFeedBackContentCellDelegate,KMMMailCellDelegate,KMMFeedBackContentCellDelegate>

@property (nonatomic,strong) UITableView *feedTab;

@property (nonatomic,strong) NSMutableArray *picDataSource;

@property (nonatomic,strong) NSMutableArray *picAsset;

@property (nonatomic,strong) NSMutableArray *tempPicArray;

@property (nonatomic,strong) NSMutableArray *dynamicImgArray;

@property (nonatomic,strong) NSString *contentString;

@property (nonatomic,strong) NSString *MailString;

@end

@implementation KMMUserFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self pageLayout];
}

- (void)pageLayout {

    self.title = @"意见反馈";
    self.picDataSource = [NSMutableArray array];
//    self.picAsset = [NSMutableArray array];
    self.tempPicArray = [NSMutableArray array];
    self.dynamicImgArray = [NSMutableArray array];
    
    [self.view addSubview:self.feedTab];

}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        KMMFeedBackContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMFeedBackContentCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
        return cell;
    }else if(indexPath.row == 1) {
    
        BATAddPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAddPicTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
        cell.PicCount = 4;
        [cell reloadCollectionViewData:_picDataSource];
        return cell;
    }else if(indexPath.row == 2) {
    
        KMMMailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMMailCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
        return cell;
    }else {
        KMMFeedFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMFeedFooterCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        WEAK_SELF(self);
        [cell setClickBtnBlock:^{
            STRONG_SELF(self);
            [self feedBackRequest];
        }];
        return cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        return 140;
    }else if(indexPath.row == 1) {
        NSInteger picCount = _picDataSource.count < 4 ? _picDataSource.count + 1 : _picDataSource.count;
        
        if (picCount <= 4) {
            return ItemWidth + 30;
        } else if (picCount <= 8) {
            return 2 * ItemWidth + 10 + 30;
        } else {
            return 3 * ItemWidth + 20 + 30;
        }
    }else {
        return UITableViewAutomaticDimension;
    }
}

#pragma mark - KMMFeedBackContentCellDelegate
- (void)KMMFeedBackContentCellTextViewDidChange:(UITextView *)textView {

    if (textView.text.length >100) {
        
        UITextRange *markeRange = [textView markedTextRange];
        if (markeRange) {
            return;
        }
        [self showText:@"反馈内容不得超过100个字!"];
        NSRange range = [textView.text rangeOfComposedCharacterSequenceAtIndex:100];
        textView.text = [textView.text substringToIndex:range.location];
    }
    self.contentString = textView.text;
    
}

#pragma mark - KMMMailCellDelegate
- (void)KMMMailCellTextFieldDidChange:(UITextField *)textField {

    self.MailString = textField.text;
}

#pragma mark - BATAddPicTableViewCellDelegate
- (void)collectionViewItemClicked:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.row == _picDataSource.count) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        WEAK_SELF(self);
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF(self);
            [self getPhotosFromCamera];
        }];
        
        UIAlertAction *photoGalleryAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF(self);
            [self getPhotosFromLocal];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:cameraAction];
        [alertController addAction:photoGalleryAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [self deletePic:indexPath];
        
        
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [[info objectForKey:UIImagePickerControllerEditedImage] copy];
    
    [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error) {
        if (!error) {
            [_tempPicArray removeAllObjects];
            [_tempPicArray addObject:image];
            [self requestUpdateImages];
        }
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - praviet math
#pragma mark - 从相机中获取图片
- (void)getPhotosFromCamera
{
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
    
    switch (AVstatus) {
        case AVAuthorizationStatusAuthorized:
            DDLogDebug(@"Authorized");
            break;
        case AVAuthorizationStatusDenied:
        {
            DDLogDebug(@"Denied");
            //提示开启相机
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"相机权限已关闭" message:@"请到设置->隐私->相机开启权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
                
                return ;
            }];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
            break;
        case AVAuthorizationStatusNotDetermined:
            DDLogDebug(@"not Determined");
            break;
        case AVAuthorizationStatusRestricted:
            DDLogDebug(@"Restricted");
            break;
        default:
            break;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        NSLog(@"模拟器中无法打开相机，请在真机中使用");
    }
}

#pragma mark - 从本地相册获取图片
- (void)getPhotosFromLocal
{
    WEAK_SELF(self);
    TZImagePickerController *tzImagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:4-_picDataSource.count delegate:self];
    tzImagePickerVC.allowPickingVideo = NO;
    if (_picDataSource.count > 0) {
        tzImagePickerVC.selectedAssets = _picAsset;
    }
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [tzImagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        STRONG_SELF(self);
        [_tempPicArray removeAllObjects];
        if (photos.count > 0) {
            for (UIImage *image in photos) {
                //对图片进行压缩处理
                if (!isSelectOriginalPhoto) {
                    UIImage *imageCompress = [Tools compressImageWithImage:image ScalePercent:0.05];
                    [_tempPicArray addObject:imageCompress];
                } else {
                    [_tempPicArray addObject:image];
                }
            }
            
            [self requestUpdateImages];
        }
        
    }];
    
    [self presentViewController:tzImagePickerVC animated:YES completion:nil];
    
}

#pragma mark 删除图片11
- (void)deletePic:(NSIndexPath *)indexPath
{
    
    //设置容器视图,父视图
    BATPhotoBrowserController *browserVC = [[BATPhotoBrowserController alloc]init];
    browserVC.BrowserPicAssetArr = _picAsset;
    browserVC.BrowserPicDataSourceArr = _picDataSource;
    browserVC.BrowserDynamicImgArray = _dynamicImgArray;
    browserVC.index = indexPath.item;
    browserVC.iSReloadBlock = ^(NSMutableArray *BrowserPicDataSourceArr,NSMutableArray *BrowserDynamicImgArray,NSMutableArray *BrowserPicAssetArr) {
        
        _picDataSource = BrowserPicDataSourceArr;
        _picAsset = BrowserPicAssetArr;
        _dynamicImgArray = BrowserDynamicImgArray;
        
        [_feedTab reloadData];
    };
    [self.navigationController pushViewController:browserVC animated:YES];
    
}

#pragma mark - NET

#pragma mark - 批量上传图片
- (void)requestUpdateImages
{
    [HTTPTool requestUploadImageToBATWithParams:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 将本地的文件上传至服务器
        for (int i = 0; i < [_tempPicArray count]; i++) {
            UIImage *image = [_tempPicArray objectAtIndex:i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            [formData appendPartWithFileData:imageData
                                        name:[NSString stringWithFormat:@"dynamic_picture%d",i]
                                    fileName:[NSString stringWithFormat:@"dynamic_picture%d.jpg",i]
                                    mimeType:@"multipart/form-data"];
        }
    } success:^(NSArray *imageArray) {
        
        [self dismissProgress];
        
        DDLogDebug(@"imageArray %@",imageArray);
        [_picDataSource addObjectsFromArray:_tempPicArray];
        [_dynamicImgArray addObjectsFromArray:[BATImage mj_objectArrayWithKeyValuesArray:imageArray]];
        [_feedTab reloadData];
    } failure:^(NSError *error) {
        
    } fractionCompleted:^(double count) {
        
        [self showProgres:count];
        
    }];
    
}

- (void)feedBackRequest {
    
    if (self.contentString == nil || [self.contentString isEqualToString:@""] || [[self.contentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [self showText:@"请填写反馈内容!"];
        return;
    }
    
    if ([[self.contentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<5) {
        [self showText:@"反馈内容不得少于5个字"];
        return;
    }

    if (self.MailString == nil) {
        self.MailString = @"";
    }
    
    if (![self.MailString isEqualToString:@""]) {
        if (![self.MailString isEmail]) {
            [self showText:@"请输入正确的邮箱"];
            return;
        }
    }
    
    
    NSMutableArray *dynamicImg = [[NSMutableArray alloc] init];
    
    for (BATImage *batImage in _dynamicImgArray) {
        [dynamicImg addObject:batImage.url];
    }
    
    
    [self showProgressWithText:@"正在提交反馈信息"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.MailString forKey:@"Email"];
    [dict setValue:@"" forKey:@"Title"];
    [dict setValue:self.contentString forKey:@"Content"];
    [dict setValue:[dynamicImg componentsJoinedByString:@","] forKey:@"Images"];
    [dict setValue:@"ios" forKey:@"Source"];
    [dict setValue:@"3.11" forKey:@"Version"];
    
    [HTTPTool requestWithURLString:@"/api/account/feedback" parameters:dict type:kPOST success:^(id responseObject) {
        [self showSuccessWithText:@"提交成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
    }];
    
}

#pragma mark - Lazy Load
- (UITableView *)feedTab {

    if (!_feedTab) {
        _feedTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _feedTab.delegate = self;
        _feedTab.dataSource = self;
        [_feedTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _feedTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

        _feedTab.estimatedRowHeight = 250;
        _feedTab.rowHeight = UITableViewAutomaticDimension;
        [_feedTab registerNib:[UINib nibWithNibName:@"KMMFeedBackContentCell" bundle:nil] forCellReuseIdentifier:@"KMMFeedBackContentCell"];
        [_feedTab registerClass:[BATAddPicTableViewCell class] forCellReuseIdentifier:@"BATAddPicTableViewCell"];
        [_feedTab registerNib:[UINib nibWithNibName:@"KMMMailCell" bundle:nil] forCellReuseIdentifier:@"KMMMailCell"];
        [_feedTab registerNib:[UINib nibWithNibName:@"KMMFeedFooterCell" bundle:nil] forCellReuseIdentifier:@"KMMFeedFooterCell"];
    }
    return _feedTab;
}

@end
