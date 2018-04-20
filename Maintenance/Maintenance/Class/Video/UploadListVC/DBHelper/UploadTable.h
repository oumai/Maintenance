//
//  UploadTable.h
//  uploadTest
//
//  Created by mac on 2017/6/29.
//  Copyright © 2017年 sword. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadTable : NSObject


@property (nonatomic, strong) NSString *upload_id;//协议、工单、临时工单的ID
@property (nonatomic, strong) NSString *upload_name;//协议、工单、临时工单的商户名称
@property (nonatomic, strong) NSString *upload_type;//协议：0;工单:1;临时工单：2
@property (nonatomic, strong) NSString *upload_text;//文字信息格式json
@property (nonatomic, strong) NSString *upload_img_name;//图片的名字格式json
@property (nonatomic, strong) NSString *upload_img_sys;//图片同步数据
@property float upload_progress;//UI的同步状态  1上传中  0 等待上传
@property int upload_status;//线程中使用  0:未处理 1:文字已上传  2:图片已上传  3:同步成功
@property (nonatomic, strong) NSString *upload_show_text;//上传显示文字的进度
@property (nonatomic, getter = isStarting) BOOL starting; // 任务是否正在进行
@property (nonatomic,strong) NSString *upload_photo_path;
@property (nonatomic,strong) NSString *upload_file_path;
@property (nonatomic,strong) NSString *upload_file_token;
@property (nonatomic,strong) NSString *upload_file_name;
@property (nonatomic,strong) NSString *upload_file_videoURL;
@property (nonatomic,assign) BOOL isCanStart;

@property (nonatomic,assign) BOOL isNoNet;

@end
