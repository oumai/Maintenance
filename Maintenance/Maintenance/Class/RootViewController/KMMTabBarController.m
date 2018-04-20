//
//  KMMTabBarController.m
//  Maintenance
//
//  Created by kmcompany on 2017/8/7.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMTabBarController.h"

#import "KMMTabBar.h"

#import "TZImagePickerController.h"
#import "TZImageManager.h"

#import "KMMEditorViewController.h"
#import "KMMWebUploadController.h"
#import "KMMVideoPickerController.h"

#import "JQFMDB.h"
#import "UploadTable.h"

@interface KMMTabBarController()<UITabBarControllerDelegate,CAAnimationDelegate,KMMTabBarViewDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) KMMTabBar *tabbar;

@property (nonatomic,strong) NSMutableArray *picDataSource;

@property (nonatomic,strong) NSMutableArray *picAsset;

@property (nonatomic,strong) NSMutableArray *tempPicArray;

@property (nonatomic,strong) NSMutableArray *dynamicImgArray;

@end

@implementation KMMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _picDataSource = [NSMutableArray array];
    //    _picAsset = [NSMutableArray array];
    _tempPicArray = [NSMutableArray array];
    _dynamicImgArray = [NSMutableArray array];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeControllerPage) name:@"STARTUPLOAD" object:nil];
    
    self.delegate = self;
    /************************隐藏tabbar上的黑色线条***************************/
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
    
    self.tabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab-_白色透明背景渐变"]];
    
    UITabBarItem *item1 = [[UITabBarItem alloc]initWithTitle:@"首页" image:[[UIImage imageNamed:@"icon-nor-kc"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    item1.selectedImage = [[UIImage imageNamed:@"icon-pre-kc"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSDictionary *dictHome = [NSDictionary dictionaryWithObject:BASE_COLOR forKey:NSForegroundColorAttributeName];
    [item1 setTitleTextAttributes:dictHome forState:UIControlStateSelected];
    
    UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:@"" image:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    
    UITabBarItem *item3 = [[UITabBarItem alloc]initWithTitle:@"我的" image:[[UIImage imageNamed:@"icon-nor-Center"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    item3.selectedImage = [[UIImage imageNamed:@"icon-pre-wd"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSDictionary *dictHome3 = [NSDictionary dictionaryWithObject:BASE_COLOR forKey:NSForegroundColorAttributeName];
    [item3 setTitleTextAttributes:dictHome3 forState:UIControlStateSelected];
    
    NSArray *controllers = @[@"KMMHomeViewController",@"KMMTempController",@"KMMeViewController"];
    for (int i = 0; i < 3; i++) {
        Class cls = NSClassFromString([NSString stringWithFormat:@"%@",controllers[i]]);
        UIViewController *controller = (UIViewController *)[[cls alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:controller];
        nc.tabBarItem = @[item1,item2,item3][i];
        [self addChildViewController:nc];
    }
    
    KMMTabBar *tabBar = [[KMMTabBar alloc] init];
    tabBar.tabbarDelegate = self;
    tabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab-_白色透明背景渐变"]];
    [tabBar setItems: @[item1,item2,item3]];
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
}

- (void)changeControllerPage {
    
    if (self.selectedIndex !=0) {
        self.selectedIndex = 0;
    }
}

#pragma mark - CYTabBarDelegate
- (void)tabbar:(KMMTabBar *)tabbar clickWithTag:(NSInteger)tag {
    
    switch (tag) {
        case 0: {
            [self getPhotosFromLocal];
        }
            break;
        case 1: {
             NSString *accountID = [NSString stringWithFormat:@"Person%@",[Tools getCurrentID]];
            NSArray *arr =  [[JQFMDB shareDatabase] jq_lookupTable:accountID dicOrModel:[UploadTable new] whereFormat:@""];
            if (arr.count >= 5) {
                [self showText:@"最多只能上传五个视频课程"];
                return;
            }
            //            NSLog(@"%@",arr);
            
            
            KMMVideoPickerController *VideoPickerVC = [[KMMVideoPickerController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VideoPickerVC];
            //  [self.navigationController pushViewController:VideoPickerVC animated:YES];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 2: {
            KMMWebUploadController *webViewVC = [[KMMWebUploadController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:webViewVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController != self.viewControllers[1]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateThreeImage" object:nil];
    }
    return YES;
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


#pragma mark - 从本地相册获取图片
- (void)getPhotosFromLocal
{
    WEAK_SELF(self);
    TZImagePickerController *tzImagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:(9) delegate:self];
    tzImagePickerVC.allowPickingVideo = NO;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [tzImagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        STRONG_SELF(self);
        //        [_picAsset removeAllObjects];
        //        [_picDataSource removeAllObjects];
        //        [_picAsset addObjectsFromArray:assets];
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


#pragma mark - 批量上传图片
- (void)requestUpdateImages
{
    WEAK_SELF(self);
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
        STRONG_SELF(self);
        [self dismissProgress];
        
        DDLogDebug(@"imageArray %@",imageArray);
        [_picDataSource addObjectsFromArray:_tempPicArray];
        [_dynamicImgArray addObjectsFromArray:[BATImage mj_objectArrayWithKeyValuesArray:imageArray]];
        
        NSMutableArray *dynamicImg = [[NSMutableArray alloc] init];
        
        for (BATImage *batImage in _dynamicImgArray) {
            [dynamicImg addObject:batImage.url];
        }
        [_dynamicImgArray removeAllObjects];
        
        KMMEditorViewController *lmVC = [KMMEditorViewController new];
        lmVC.title = @"编辑课程";
        lmVC.isCanEdit = YES;
        lmVC.imageArr = dynamicImg;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:lmVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        
        
    } failure:^(NSError *error) {
        
    } fractionCompleted:^(double count) {
        
        [self showProgres:count];
        
    }];
    
}
@end
