//
//  KMMUpLoadListController.m
//  Maintenance
//
//  Created by kmcompany on 2017/7/5.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMUpLoadListController.h"


#import "KMMUploadCell.h"
#import "UploadTable.h"

#import "JQFMDB.h"

#import "KMMNetworkSpeed.h"

#import "HTTPTool+BATUploadImage.h"

#import "KMMUploadTool.h"

#import "KMMNetworkSpeed.h"

#import "KMMClassDefaultView.h"

#import "KMMGetURLFileLengthTool.h"

#define Person_AccountID [NSString stringWithFormat:@"Person%@",[Tools getCurrentID]]


@interface KMMUpLoadListController ()<UITableViewDelegate,UITableViewDataSource,KMMUploadCellDelegate> {
    JQFMDB *jqModelDB;
}

@property (nonatomic,strong) UITableView *listTab;

@property (nonatomic,strong) NSMutableArray *tableData;

@property (nonatomic,strong) KMMUploadTool *upLoadTool;

@property (nonatomic,strong) KMMNetworkSpeed *networkSpeed;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) KMMClassDefaultView *defaultView;

@property (nonatomic,strong) KMMGetURLFileLengthTool *netTool;

@property (nonatomic,assign) BOOL isExistUpload_Status;


@end

@implementation KMMUpLoadListController

static KMMUpLoadListController *_instance = nil;
static dispatch_once_t onceToken0;
static dispatch_once_t onceToken1;
//NSString *accountID = [Tools getCurrentID];
+ (instancetype)defaultMainVideoVC{
    if (_instance == nil) {
        dispatch_once(&onceToken0, ^{
            _instance = [[KMMUpLoadListController alloc] init];
        });
    }
    return _instance;
}

/** 注意苹果不建议重写此方法但是不重写此方法就不能是一个真实的单例 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_instance == nil) {
        dispatch_once(&onceToken1, ^{
            _instance = [super allocWithZone:zone];
        });
    }
    return _instance;
}


- (void)dealloc {

    NSLog(@"111");
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
     [self pageLayout];
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    
    [self.networkSpeed stopMonitoringNetworkSpeed];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NetStateChangeAction:) name:@"NetStateChange" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUploadState) name:@"STARTUPLOAD" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutAction) name:@"logoutAction" object:nil];
    
    [self.view addSubview:self.listTab];
   
}


//退出登录时应该停止任务，并且重置状态
- (void)logoutAction {

    
    NSArray *arr =  [[JQFMDB shareDatabase] jq_lookupTable:Person_AccountID dicOrModel:[UploadTable new] whereFormat:@""];
    NSLog(@"%@",arr);
    NSMutableArray *dataArr = [NSMutableArray array];
    [dataArr addObjectsFromArray:arr];
    
    BOOL isExistUpload = NO;
    for (int i=0; i<dataArr.count; i++) {
        UploadTable *table = dataArr[i];
        if (table.upload_status) {
            isExistUpload = YES;
            break;
        }
    }
    
    
    if (isExistUpload) {
        
        [[KMMUploadTool shareInstance] KMMStopUploadAction];
        for (UploadTable *table in dataArr) {
            table.upload_status = 0;
            table.isCanStart = YES;
            if ([[JQFMDB shareDatabase] jq_updateTable:Person_AccountID dicOrModel:table whereFormat:[NSString stringWithFormat:@"where upload_file_token = '%@'",table.upload_file_token]]) {
                NSLog(@"更改成功");
                
            }else {
                NSLog(@"更改失败");
            }
            
        }
        
        self.tableData = dataArr;
        [self.listTab reloadData];
        
    }
    

}

#pragma mark -网络环境变化通知事件
- (void)NetStateChangeAction:(NSNotification *)sender {

    NSDictionary *dict = (NSDictionary *)sender.object;
    
    NSString *netSateString = dict[@"NetState"];
    
    if([netSateString isEqualToString:@"phoneNet"]){
        NSLog(@"手机自带网络");
        BOOL tempTest = NO;
        for (int i=0; i<self.tableData.count; i++) {
            UploadTable *table = self.tableData[i];
            table.isNoNet = NO;
            if (table.upload_status) {
                tempTest = YES;
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowTips"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (tempTest) {
            [[KMMNetworkSpeed shareNetworkSpeed] stopMonitoringNetworkSpeed];
            [[KMMUploadTool shareInstance] KMMStopUploadAction];
            
     
            
           BOOL enableShowTips = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isShowTips"] boolValue];
            
            
            if (!enableShowTips) {
                UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"流量提醒" message:@"当前网络环境是非WiFi状态,上传视频可能要耗费4G/3G/2G流量,确定上传?" preferredStyle:UIAlertControllerStyleAlert];
                
                WEAK_SELF(self);
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    //   STRONG_SELF(self);
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPage inSection:0];
                    KMMUploadCell *cell = (KMMUploadCell *)[self.listTab cellForRowAtIndexPath:indexPath];
                    
                    [self.networkSpeed stopMonitoringNetworkSpeed];
                    cell.uploadRate.text = @"";
                    
                    for (UploadTable *tempTable in self.tableData) {
                        tempTable.upload_status = 0;
                        tempTable.isCanStart = YES;
                        [self uploadTableMathWith:tempTable];
                    }
                    
                    [self.listTab reloadData];
                }];
                
                
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    STRONG_SELF(self);
                    
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowTips"];
                    [[NSUserDefaults standardUserDefaults] synchronize];

                    
                    [[KMMNetworkSpeed shareNetworkSpeed] startMonitoringNetworkSpeed];
                    for (int i =0; i<self.tableData.count; i++) {
                        UploadTable *table = self.tableData[i];
                        if (i == self.currentPage) {
                            table.isNoNet = NO;
                            table.upload_status = 1;
                            table.isCanStart = YES;
                        }else {
                            table.upload_status = 0;
                            table.isCanStart = NO;
                            
                        }
                        [self uploadTableMathWith:table];
                    }
                    
                    [self.listTab reloadData];
                    
                    if (self.tableData.count >0) {
                        
                        UploadTable *table = self.tableData[self.currentPage];
                        if (table.upload_status) {
                            
                            [[KMMNetworkSpeed shareNetworkSpeed] stopMonitoringNetworkSpeed];
                            if ([table.upload_file_token rangeOfString:@"TokenRandom"].location !=NSNotFound) {
                                
                                [[KMMUploadTool shareInstance]loadTokenWithFilePaht:table.upload_file_path tableData:table success:^(NSString *token) {
                                    //   STRONG_SELF(self);
                                    [[KMMUploadTool shareInstance]getBlockInfoRequestWithToken:token success:^(KMMBlockModel *model, NSString *token) {
                                        //  STRONG_SELF(self);
                                        [KMMUploadTool shareInstance].table = table;
                                        [[KMMUploadTool shareInstance]startUploadWithModel:model filePath:table.upload_file_path];
                                        [self.networkSpeed startMonitoringNetworkSpeed];
                                    } failure:^(NSError *error) {
                                        
                                    }];
                                    
                                }];
                                
                                
                                
                            }else {
                                
                                [[KMMUploadTool shareInstance]getBlockInfoRequestWithToken:table.upload_file_token success:^(KMMBlockModel *model, NSString *token) {
                                    // STRONG_SELF(self);
                                    [KMMUploadTool shareInstance].table = table;
                                    [[KMMUploadTool shareInstance]startUploadWithModel:model filePath:table.upload_file_path];
                                    [self.networkSpeed startMonitoringNetworkSpeed];
                                } failure:^(NSError *error) {
                                    
                                }];
                                
                            }
                        }
                    }
                    
                    
                }];
                
                [alterVC addAction:action1];
                [alterVC addAction:action2];
                
                [self.navigationController presentViewController:alterVC animated:YES completion:nil];
            }
            
        }
        
    }else if([netSateString isEqualToString:@"NoNet"]) {
        NSLog(@"没有网络(断网)");
        
        
        [[KMMNetworkSpeed shareNetworkSpeed] stopMonitoringNetworkSpeed];
        [[KMMUploadTool shareInstance] KMMStopUploadAction];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPage inSection:0];
        KMMUploadCell *cell = (KMMUploadCell *)[self.listTab cellForRowAtIndexPath:indexPath];
        
        
        cell.uploadRate.text = @"0.0KB/S";
        
        BOOL tempTest = NO;
        for (int i=0; i<self.tableData.count; i++) {
            UploadTable *table = self.tableData[i];
            if (table.upload_status) {
                tempTest = YES;
            }
        }
        
        if (tempTest) {
            [self showText:@"网络开小差了，请检查后重试!"];
            for (int i =0; i<self.tableData.count; i++) {
                UploadTable *table = self.tableData[i];
                
                if (i == self.currentPage) {
                    table.upload_status = 1;
                    table.isNoNet =  YES;
                    table.isCanStart = YES;
                }else {
                    table.upload_status = 0;
                    table.isNoNet =  NO;
                    table.isCanStart = NO;
                }
                
                [self uploadTableMathWith:table];
                
            }
        }else {
            for (UploadTable *tempTable in self.tableData) {
                tempTable.upload_status = 0;
                tempTable.isCanStart = YES;
                tempTable.isNoNet = NO;
                [self uploadTableMathWith:tempTable];
            }
        }
        
        
        
        
        
        [self.listTab reloadData];
        
    }else if([netSateString isEqualToString:@"WIFI"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowTips"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"WIFI");
        BOOL tempTest = NO;
        for (int i=0; i<self.tableData.count; i++) {
            UploadTable *table = self.tableData[i];
            if (table.upload_status) {
                tempTest = YES;
            }
        }
        
        if (tempTest) {
            for (int i =0; i<self.tableData.count; i++) {
                UploadTable *table = self.tableData[i];
                if (i == self.currentPage) {
//                    table.isNoNet = NO;
                    table.upload_status = 1;
                    table.isCanStart = YES;
                }else {
                    table.upload_status = 0;
                    table.isCanStart = NO;
//                    table.isNoNet = NO;
                    
                }
                
                [self uploadTableMathWith:table];
            }
            
            
            
            if (self.tableData.count >0) {
                
                UploadTable *table = self.tableData[self.currentPage];
                if (table.upload_status) {
                    
                    [[KMMNetworkSpeed shareNetworkSpeed] stopMonitoringNetworkSpeed];
                    if ([table.upload_file_token rangeOfString:@"TokenRandom"].location !=NSNotFound) {
                        
                        [[KMMUploadTool shareInstance]loadTokenWithFilePaht:table.upload_file_path tableData:table success:^(NSString *token) {
                            //   STRONG_SELF(self);
                            [[KMMUploadTool shareInstance]getBlockInfoRequestWithToken:token success:^(KMMBlockModel *model, NSString *token) {
                                //  STRONG_SELF(self);
                                [KMMUploadTool shareInstance].table = table;
                                [[KMMUploadTool shareInstance]startUploadWithModel:model filePath:table.upload_file_path];
                                [self.networkSpeed startMonitoringNetworkSpeed];
                            } failure:^(NSError *error) {
                                
                            }];
                            
                        }];
                        
                        
                        
                    }else {
                        
                        [[KMMUploadTool shareInstance]getBlockInfoRequestWithToken:table.upload_file_token success:^(KMMBlockModel *model, NSString *token) {
                            // STRONG_SELF(self);
                            [KMMUploadTool shareInstance].table = table;
                            [[KMMUploadTool shareInstance]startUploadWithModel:model filePath:table.upload_file_path];
                            [self.networkSpeed startMonitoringNetworkSpeed];
                        } failure:^(NSError *error) {
                            
                        }];
                        
                    }
                }
            }
        }
        [self.listTab reloadData];
    }
}

- (void)changeUploadState {


    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"uploadStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (void)pageLayout {
    
 
    
    
   jqModelDB = [JQFMDB shareDatabase];
    
   NSArray *arr =  [jqModelDB jq_lookupTable:Person_AccountID dicOrModel:[UploadTable new] whereFormat:@""];
    NSLog(@"%@",arr);
    
    
    self.tableData = [NSMutableArray array];
    [self.tableData addObjectsFromArray:arr];
    
     WEAK_SELF(self);
    [self.tableData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        STRONG_SELF(self);
        UploadTable *table = (UploadTable *)obj;
        NSString *PATH_MOVIE_FILE = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",table.upload_file_name]];
        table.upload_file_path = PATH_MOVIE_FILE;
        [self uploadTableMathWith:table];
        
    }];
    [self.listTab reloadData];
    
    
//   <--------------这段是测试token失效时候的代码------------------->
//    UploadTable *table = arr[0];
//    NSString *PATH_MOVIE_FILE = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",table.upload_file_name]];
//    table.upload_file_path = PATH_MOVIE_FILE;
//   
//    NSString *tempToken11 = table.upload_file_token;
//     table.upload_file_token = @"111223";
//    if ([[JQFMDB shareDatabase] jq_updateTable:Person_AccountID dicOrModel:table whereFormat:[NSString stringWithFormat:@"where upload_file_token = '%@'",tempToken11]]) {
//        NSLog(@"更改成功");
//        
//    }else {
//        NSLog(@"更改失败");
//    }
//   <--------------这段是测试token失效时候的代码------------------->
    
    
    
  //  进来先判断有没有保存到草稿箱失败的，有的话，自动发布到草稿箱
    [self.tableData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        STRONG_SELF(self);
        UploadTable *table = (UploadTable *)obj;
        NSInteger progress = table.upload_progress;
        if (progress == 1) {
            [self uploadInformationRequestWithVideoPath:table.upload_file_videoURL model:table];
        }
    }];
    
    BOOL isExistUpload = NO;
    for (int i=0; i<self.tableData.count; i++) {
         UploadTable *table = self.tableData[i];
        if (table.upload_status) {
            isExistUpload = YES;
        }
    }

    BOOL uploadStatus = [[[NSUserDefaults standardUserDefaults] valueForKey:@"uploadStatus"] boolValue];
    
    if (!isExistUpload) {
        
        if (uploadStatus) {
            self.currentPage = self.tableData.count - 1;
            
            for (int i=0; i<self.tableData.count; i++) {
                
                UploadTable *table = self.tableData[i];
                if (i == self.currentPage) {
                    table.upload_status = 1;
                    table.isCanStart = 1;
                }else {
                    table.upload_status = 0;
                    table.isCanStart = 0;
                }
                
                [self uploadTableMathWith:table];
                
            }
        }
        

    }
    
    self.title = @"上传中";
    
    //进来先判断是否有任务在进行，有，先取消
    if ([KMMUploadTool shareInstance].uploadTask.state == NSURLSessionTaskStateRunning) {
        [[KMMUploadTool shareInstance]KMMStopUploadAction];
    }
    
    //失败回调
    [[KMMUploadTool shareInstance] setUploadFailureBlock:^(KMMBlockModel *model){
       
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPage inSection:0];
        KMMUploadCell *cell = (KMMUploadCell *)[self.listTab cellForRowAtIndexPath:indexPath];
        [self.networkSpeed stopMonitoringNetworkSpeed];
        [[KMMUploadTool shareInstance] KMMStopUploadAction];
        cell.uploadRate.text = @"";
        
        for (UploadTable *tempTable in self.tableData) {
            tempTable.upload_status = 0;
            tempTable.isCanStart = YES;
            [self uploadTableMathWith:tempTable];
        }
        
        [self.listTab reloadData];
        
    }];
    
    //成功回调
    [[KMMUploadTool shareInstance] setUploadFinshBlock:^(KMMBlockModel *model){
        STRONG_SELF(self);
        
        if (self.tableData.count >0) {
           
            if ([model.BlockSize isEqualToString:@""] || model.BlockSize == nil || [model.FileSize isEqualToString:@""] || model.FileSize == nil) {
                [[KMMUploadTool shareInstance] KMMStopUploadAction];
                 [self.networkSpeed stopMonitoringNetworkSpeed];
                for (UploadTable *table in self.tableData) {
                    table.upload_status = 0;
                    table.isCanStart = YES;
                    [self uploadTableMathWith:table];
                }
                [self.listTab reloadData];
                return;
            }
            
            UploadTable *table = self.tableData[self.currentPage];
            table.upload_progress = [model.Progress floatValue];
            
            [self uploadTableMathWith:table];
            
            
            if (model.incomplete) {
                [KMMUploadTool shareInstance].table = table;
                if (!table.upload_status) {
                    table.isCanStart = YES;
                    table.upload_status = 0;
                    [self uploadTableMathWith:table];
                    [[KMMUploadTool shareInstance] KMMStopUploadAction];
                    return;
                }
                [[KMMUploadTool shareInstance]startUploadWithModel:model filePath:table.upload_file_path];
            }else {
                
                if ([model.Progress integerValue] == 1) {
                      [self sendFileNameRequestToken:table.upload_file_token fileName:table.upload_file_name model:table];
                }
              

            }
            
            
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPage inSection:0];
            KMMUploadCell *cell = (KMMUploadCell *)[self.listTab cellForRowAtIndexPath:indexPath];
            
            cell.uploadProgress.progress = [model.Progress floatValue];
            
           
            
        }
        
    }];
    
    
    if (self.tableData.count >0) {
        
        UploadTable *table = arr[self.currentPage];
        
        if (table.upload_status) {
            if ([table.upload_file_token rangeOfString:@"TokenRandom"].location !=NSNotFound) {
                
                [[KMMUploadTool shareInstance]loadTokenWithFilePaht:table.upload_file_path tableData:table success:^(NSString *token) {
                    //   STRONG_SELF(self);
                    [[KMMUploadTool shareInstance]getBlockInfoRequestWithToken:token success:^(KMMBlockModel *model, NSString *token) {
                        //  STRONG_SELF(self);
                        [KMMUploadTool shareInstance].table = table;
                        [[KMMUploadTool shareInstance]startUploadWithModel:model filePath:table.upload_file_path];
                        [self.networkSpeed startMonitoringNetworkSpeed];
                    } failure:^(NSError *error) {
                        
                    }];
                    
                }];
                
                
                
            }else {
                
                [[KMMUploadTool shareInstance]getBlockInfoRequestWithToken:table.upload_file_token success:^(KMMBlockModel *model, NSString *token) {
                    // STRONG_SELF(self);
                    if ([model.Progress integerValue] == 1) {
                         [self sendFileNameRequestToken:table.upload_file_token fileName:table.upload_file_name model:table];
                    }else {
                    [KMMUploadTool shareInstance].table = table;
                    [[KMMUploadTool shareInstance]startUploadWithModel:model filePath:table.upload_file_path];
                    [self.networkSpeed startMonitoringNetworkSpeed];
                    }
                } failure:^(NSError *error) {
                    
                    NSString *tempToken = table.upload_file_token;
                    
                    NSString *randomString = [NSString stringWithFormat:@"TokenRandom%@",[Tools randomArray]];
                    table.upload_file_token = randomString;
                    table.upload_progress = 0;
                    
                    if ([[JQFMDB shareDatabase] jq_updateTable:Person_AccountID dicOrModel:table whereFormat:[NSString stringWithFormat:@"where upload_file_token = '%@'",tempToken]]) {
                        NSLog(@"更改成功");
                        
                    }else {
                        NSLog(@"更改失败");
                    }
                    
                    [self.listTab reloadData];
                    
                    [[KMMUploadTool shareInstance]loadTokenWithFilePaht:table.upload_file_path tableData:table success:^(NSString *token) {
                        //   STRONG_SELF(self);
                        [[KMMUploadTool shareInstance]getBlockInfoRequestWithToken:token success:^(KMMBlockModel *model, NSString *token) {
                            //  STRONG_SELF(self);
                            [KMMUploadTool shareInstance].table = table;
                            [[KMMUploadTool shareInstance]startUploadWithModel:model filePath:table.upload_file_path];
                            [self.networkSpeed startMonitoringNetworkSpeed];
                        } failure:^(NSError *error) {
                            
                        }];
                        
                    }];
                    
                }];
                
            }
        }
    }
   
    self.networkSpeed = [KMMNetworkSpeed shareNetworkSpeed];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(speedChange:) name:kNetworkSendSpeedNotification object:nil];
    
    if (self.tableData.count == 0) {
        self.defaultView.hidden = NO;
    }else {
        self.defaultView.hidden = YES;
    }
    

}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    KMMUploadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMUploadCell"];
    cell.delegate = self;
    cell.rowPath = indexPath;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.tableData = self.tableData[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 112;

}

#pragma mark - KMMUploadCellDelegate
- (void)KMMUploadCellDelegateDeleteDataStartOrStopWithRowPath:(NSIndexPath *)rowPath {
    
    NSString *netSateString = [[NSUserDefaults standardUserDefaults] valueForKey:@"NetState"];
    
    BOOL enableShowTips = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isShowTips"] boolValue];
    
    
    if([netSateString isEqualToString:@"phoneNet"]){
        if (!enableShowTips) {
            UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"检测到当前网络是非wifi状态,上传视频可能要耗费4G/3G/2G流量,确定上传?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowTips"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self startUploadMathWithRowPath:rowPath];
                
            }];
            
            [alterVC addAction:action];
            [alterVC addAction:action1];
            
            [self.navigationController presentViewController:alterVC animated:YES completion:nil];
            
        }else {
            
            
            [self startUploadMathWithRowPath:rowPath];
        }
 
    }else if([netSateString isEqualToString:@"NoNet"]){
    
        [self showText:@"当前无网络"];
    
    }else if([netSateString isEqualToString:@"WIFI"]){
       
        [self startUploadMathWithRowPath:rowPath];
    }

    
    
   
}

- (void)startUploadMathWithRowPath:(NSIndexPath *)rowPath {

    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"uploadStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // WEAK_SELF(self);
    
    
    UploadTable *table = self.tableData[rowPath.row];
    
    if (table.isCanStart) {
        
        self.currentPage = rowPath.row;
        
        [[KMMUploadTool shareInstance]KMMStopUploadAction];
        
        if (table.upload_status == 1) {
            
            [self.networkSpeed stopMonitoringNetworkSpeed];
            table.upload_show_text = @"";
            table.upload_status = 0;
            table.isNoNet = NO;
            
            
            [self uploadTableMathWith:table];
            
            NSArray *arr =  [[JQFMDB shareDatabase] jq_lookupTable:Person_AccountID dicOrModel:[UploadTable new] whereFormat:@""];
            NSLog(@"%@",arr);
            
            for (int i =0; i<self.tableData.count; i++) {
                UploadTable *table = self.tableData[i];
                
                table.isCanStart = YES;
                table.isNoNet = NO;
                [self uploadTableMathWith:table];
                
            }
            
            NSArray *arr1 =  [[JQFMDB shareDatabase] jq_lookupTable:Person_AccountID dicOrModel:[UploadTable new] whereFormat:@""];
            NSLog(@"%@",arr1);
            
            [self.listTab reloadData];
            
        }else {
            
            self.currentPage = rowPath.row;
            
            [self.networkSpeed startMonitoringNetworkSpeed];
            table.upload_status = 1;
            
            [self uploadTableMathWith:table];
            
            for (int i =0; i<self.tableData.count; i++) {
                UploadTable *table = self.tableData[i];
                if (i != rowPath.row) {
                    table.isCanStart = NO;
                    table.isNoNet = NO;
                    [self uploadTableMathWith:table];
                }
            }
            
            if ([table.upload_file_token rangeOfString:@"TokenRandom"].location !=NSNotFound) {
                
                [[KMMUploadTool shareInstance]loadTokenWithFilePaht:table.upload_file_path tableData:table success:^(NSString *token) {
                    //  STRONG_SELF(self);
                    [[KMMUploadTool shareInstance]getBlockInfoRequestWithToken:token success:^(KMMBlockModel *model, NSString *token) {
                        //    STRONG_SELF(self);
                        [KMMUploadTool shareInstance].table = table;
                        [[KMMUploadTool shareInstance]startUploadWithModel:model filePath:table.upload_file_path];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    
                }];
                
            }else {
                
                if (table.upload_progress == 1.0) {
                    if (table.upload_file_videoURL) {
                     [self uploadInformationRequestWithVideoPath:table.upload_file_videoURL model:table];
                    }else {
                     [self sendFileNameRequestToken:table.upload_file_token fileName:table.upload_file_name model:table];
                    }
                    return;
                }
                
                [[KMMUploadTool shareInstance]getBlockInfoRequestWithToken:table.upload_file_token success:^(KMMBlockModel *model, NSString *token) {
                    // STRONG_SELF(self);
                    if ([model.Progress integerValue] == 1) {
                        [self sendFileNameRequestToken:table.upload_file_token fileName:table.upload_file_name model:table];
                    }else {
                        
                        [KMMUploadTool shareInstance].table = table;
                        [[KMMUploadTool shareInstance]startUploadWithModel:model filePath:table.upload_file_path];
                    }
                } failure:^(NSError *error) {
                    
                    NSString *tempToken = table.upload_file_token;
                    
                    NSString *randomString = [NSString stringWithFormat:@"TokenRandom%@",[Tools randomArray]];
                    table.upload_file_token = randomString;
                    table.upload_progress = 0;
                    
                    if ([[JQFMDB shareDatabase] jq_updateTable:Person_AccountID dicOrModel:table whereFormat:[NSString stringWithFormat:@"where upload_file_token = '%@'",tempToken]]) {
                        NSLog(@"更改成功");
                        
                    }else {
                        NSLog(@"更改失败");
                    }
                    
                    [self.listTab reloadData];
                    
                    [[KMMUploadTool shareInstance]loadTokenWithFilePaht:table.upload_file_path tableData:table success:^(NSString *token) {
                        //   STRONG_SELF(self);
                        [[KMMUploadTool shareInstance]getBlockInfoRequestWithToken:token success:^(KMMBlockModel *model, NSString *token) {
                            //  STRONG_SELF(self);
                            [KMMUploadTool shareInstance].table = table;
                            [[KMMUploadTool shareInstance]startUploadWithModel:model filePath:table.upload_file_path];
                            [self.networkSpeed startMonitoringNetworkSpeed];
                        } failure:^(NSError *error) {
                            
                        }];
                        
                    }];
                    
                }];
                
            }
        }
        
        
        [self.listTab reloadData];
    }

}

#pragma mark - 网速监控
- (void)speedChange:(NSNotification *)sender {
    
    NSDictionary *dict = (NSDictionary *)sender.object;

    if (self.tableData.count >0) {
        //UploadTable *table = self.tableData[self.currentPage];
        
       // table.upload_show_text = dict[@"send"];
        
        
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPage inSection:0];
        KMMUploadCell *cell = (KMMUploadCell *)[self.listTab cellForRowAtIndexPath:indexPath];
        
   
        cell.uploadRate.text = dict[@"send"];
    }
    
}

#pragma mark - 上传完毕后，需要再调用接口告诉服务器这个文件的名字
- (void)sendFileNameRequestToken:(NSString *)token fileName:(NSString *)fileName model:(UploadTable *)table {
    
    [HTTPTool requestWithUploadURLString:[NSString stringWithFormat:@"/%@/?filename=%@",token,fileName] parameters:nil type:kGET success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        table.upload_file_videoURL = responseObject[@"url"];
        
        [self uploadTableMathWith:table];
        
//        NSFileManager* fileManager=[NSFileManager defaultManager];
//        BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:table.upload_file_path];
//        if (!blHave) {
//            NSLog(@"no  have");
//        }else {
//            NSLog(@" have");
//            BOOL blDele= [fileManager removeItemAtPath:table.upload_file_path error:nil];
//            if (blDele) {
//                NSLog(@"dele success");
//            }else {
//                NSLog(@"dele fail");
//            }
//            
//        }
        
        [self uploadInformationRequestWithVideoPath:responseObject[@"url"] model:table];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 上传资料的草稿箱
- (void)uploadInformationRequestWithVideoPath:(NSString *)videoPath model:(UploadTable *)table{
    
    if (![HTTPTool currentNetStatus]) {
        [self showText:@"保存失败  请连网后重试"];
        return;
    }
    
    
    
    if (table.upload_id == nil || [table.upload_id isEqualToString:@""]) {
        [self showText:@"请选择类别"];
        return;
    }
    
//    NSString *lastComponts = [videoPath lastPathComponent];
//    
//    NSRange range = [lastComponts rangeOfString:@"."];
//    NSString *videoName =  [NSString stringWithFormat:@"%@.mp4",[lastComponts substringToIndex:range.location]];
//    
//    videoPath = [videoPath stringByReplacingOccurrencesOfString:lastComponts withString:videoName];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"" forKey:@"Id"];
    [dict setValue:table.upload_id forKey:@"CourseCategory"];
    [dict setValue:table.upload_name forKey:@"CourseTitle"];
    [dict setValue:table.upload_text forKey:@"CourseDesc"];
    [dict setValue:@"20" forKey:@"ClassHour"]; //固定20
    [dict setValue:table.upload_photo_path forKey:@"Poster"];
    [dict setValue:videoPath forKey:@"AttachmentUrl"];
    [dict setValue:@(0) forKey:@"Auditing"];
    [dict setValue:@"" forKey:@"CourseType"];
    [dict setValue:@"" forKey:@"MainContent"];
    
    
    
    [HTTPTool requestWithURLString:@"/api/Course/EditCourse" parameters:dict type:kPOST success:^(id responseObject) {
        
        
        [self showSuccessWithText:@"上传成功!\n请在草稿箱中查看课程"];
        
        NSArray *arr1 =  [jqModelDB jq_lookupTable:Person_AccountID dicOrModel:[UploadTable new] whereFormat:@""];
        NSLog(@"%@",arr1);

        
        if([jqModelDB jq_deleteTable:Person_AccountID whereFormat:[NSString stringWithFormat:@"where upload_file_token = '%@'",table.upload_file_token]]) {
            NSArray *arr =  [jqModelDB jq_lookupTable:Person_AccountID dicOrModel:[UploadTable new] whereFormat:@""];
            NSLog(@"%@",arr);
            [self.tableData removeAllObjects];
            [self.tableData addObjectsFromArray:arr];
        }
        
        
        


        
        if (self.tableData.count == 0) {
            KMMNetworkSpeed *speed = [KMMNetworkSpeed shareNetworkSpeed];
            [speed stopMonitoringNetworkSpeed];
        }
        
        if (self.tableData.count >0) {
            
            [[KMMNetworkSpeed shareNetworkSpeed] startMonitoringNetworkSpeed];
            
            self.currentPage = 0;
            
            for (int i=0; i<self.tableData.count; i++) {
                UploadTable *table = self.tableData[i];
                if (i == 0) {
                    table.upload_status = 1;
                    table.isCanStart = YES;
                }else {
                    table.upload_status = 0;
                    table.isCanStart = NO;
                }
                
                [self uploadTableMathWith:table];
            }
            
            UploadTable *table = self.tableData[0];
            
            if ([table.upload_file_token rangeOfString:@"TokenRandom"].location !=NSNotFound) {
                
                [[KMMUploadTool shareInstance]loadTokenWithFilePaht:table.upload_file_path tableData:table success:^(NSString *token) {
                    
                    [[KMMUploadTool shareInstance]getBlockInfoRequestWithToken:token success:^(KMMBlockModel *model, NSString *token) {
                        [KMMUploadTool shareInstance].table = table;
                        [[KMMUploadTool shareInstance]startUploadWithModel:model filePath:table.upload_file_path];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    
                }];
                
            }else {
                
                [[KMMUploadTool shareInstance]getBlockInfoRequestWithToken:table.upload_file_token success:^(KMMBlockModel *model, NSString *token) {
                    
                    if ([model.Progress integerValue] == 1) {
                        [self sendFileNameRequestToken:table.upload_file_token fileName:table.upload_file_name model:table];
                    }else {

                    [KMMUploadTool shareInstance].table = table;
                    [[KMMUploadTool shareInstance]startUploadWithModel:model filePath:table.upload_file_path];
                    }
                } failure:^(NSError *error) {
                    
                    NSString *tempToken = table.upload_file_token;
                    
                    NSString *randomString = [NSString stringWithFormat:@"TokenRandom%@",[Tools randomArray]];
                    table.upload_file_token = randomString;
                    table.upload_progress = 0;
                    
                    if ([[JQFMDB shareDatabase] jq_updateTable:Person_AccountID dicOrModel:table whereFormat:[NSString stringWithFormat:@"where upload_file_token = '%@'",tempToken]]) {
                        NSLog(@"更改成功");
                        
                    }else {
                        NSLog(@"更改失败");
                    }
                    
                    [self.listTab reloadData];
                    
                    [[KMMUploadTool shareInstance]loadTokenWithFilePaht:table.upload_file_path tableData:table success:^(NSString *token) {
                        //   STRONG_SELF(self);
                        [[KMMUploadTool shareInstance]getBlockInfoRequestWithToken:token success:^(KMMBlockModel *model, NSString *token) {
                            //  STRONG_SELF(self);
                            [KMMUploadTool shareInstance].table = table;
                            [[KMMUploadTool shareInstance]startUploadWithModel:model filePath:table.upload_file_path];
                            [self.networkSpeed startMonitoringNetworkSpeed];
                        } failure:^(NSError *error) {
                            
                        }];
                        
                    }];

                    
                }];
                
            }
            
        }
        
        if (self.tableData.count == 0) {
            self.defaultView.hidden = NO;
        }else {
            self.defaultView.hidden = YES;
        }
        
        
        
        [self.listTab reloadData];
        
        
        
    } failure:^(NSError *error) {
    
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPage inSection:0];
        KMMUploadCell *cell = (KMMUploadCell *)[self.listTab cellForRowAtIndexPath:indexPath];
        [self.networkSpeed stopMonitoringNetworkSpeed];
        [[KMMUploadTool shareInstance] KMMStopUploadAction];
        cell.uploadRate.text = @"";
        
        for (UploadTable *tempTable in self.tableData) {
            tempTable.upload_status = 0;
            tempTable.isCanStart = YES;
            [self uploadTableMathWith:tempTable];
        }
        
        [self.listTab reloadData];

      //   [self.networkSpeed stopMonitoringNetworkSpeed];
        [self showText:@"服务器开小差啦    请重新保存"];
        
    }];
}

#pragma mark - 更新数据库
- (void)uploadTableMathWith:(UploadTable *)table {

    if ([[JQFMDB shareDatabase] jq_updateTable:Person_AccountID dicOrModel:table whereFormat:[NSString stringWithFormat:@"where upload_file_token = '%@'",table.upload_file_token]]) {
        NSLog(@"更改成功");
        
    }else {
        NSLog(@"更改失败");
    }
}

#pragma mark - LayLoad
- (UITableView *)listTab {

    if (!_listTab) {
        _listTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64-49 - 45) style:UITableViewStylePlain];
        _listTab.delegate = self;
        _listTab.dataSource = self;
        _listTab.estimatedRowHeight = 250;
        _listTab.rowHeight = UITableViewAutomaticDimension;
        [_listTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_listTab registerNib:[UINib nibWithNibName:@"KMMUploadCell" bundle:nil] forCellReuseIdentifier:@"KMMUploadCell"];
        WEAK_SELF(self);
        _listTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            
            [self.tableData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                STRONG_SELF(self);
                UploadTable *table = (UploadTable *)obj;
                
                if (table.upload_progress == 1.0) {
                    [self uploadInformationRequestWithVideoPath:table.upload_file_videoURL model:table];
                }
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.listTab.mj_header endRefreshing];
            });
           
        }];
    }
    return _listTab;
}

- (KMMClassDefaultView *)defaultView {
    
    if (!_defaultView) {
        _defaultView = [[[NSBundle mainBundle] loadNibNamed:@"KMMClassDefaultView" owner:nil options:nil] lastObject];
        _defaultView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44);
        _defaultView.hidden = YES;
         _defaultView.titleLb.text = @"没有上传中的课程";
        [self.view addSubview:_defaultView];
    }
    return _defaultView;
}

@end
