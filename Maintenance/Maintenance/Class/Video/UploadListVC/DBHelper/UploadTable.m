//
//  UploadTable.m
//  uploadTest
//
//  Created by mac on 2017/6/29.
//  Copyright © 2017年 sword. All rights reserved.
//

#import "UploadTable.h"

@implementation UploadTable

@synthesize upload_id = _upload_id;
@synthesize upload_name = _upload_name;
@synthesize upload_type = _upload_type;
@synthesize upload_text = _upload_text;
@synthesize upload_img_name = _upload_img_name;
@synthesize upload_img_sys = _upload_img_sys;
@synthesize upload_progress = _upload_progress;
@synthesize upload_status = _upload_status;
@synthesize upload_show_text = _upload_show_text;
@synthesize starting = _starting;
@synthesize upload_photo_path = _upload_photo_path;
@synthesize upload_file_path = _upload_file_path;
@synthesize upload_file_token = _upload_file_token;
@synthesize upload_file_name = _upload_file_name;
@synthesize upload_file_videoURL = _upload_file_videoURL;
@synthesize isNoNet = _isNoNet;

-(BOOL)isStarting{
    return _starting;
}

@end
