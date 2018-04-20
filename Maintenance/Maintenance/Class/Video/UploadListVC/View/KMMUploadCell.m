//
//  KMMUploadCell.m
//  Maintenance
//
//  Created by kmcompany on 2017/7/5.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMUploadCell.h"

#import "KMMUploadTool.h"

@interface KMMUploadCell()

@property (nonatomic,strong) UIView *blackView;

@end

@implementation KMMUploadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.image.clipsToBounds = YES;
    self.image.layer.borderWidth = 1;
    self.image.layer.borderColor = UIColorFromHEX(0Xe0e0e0, 1).CGColor;
    self.image.layer.cornerRadius = 5;
    
    self.blackView = [[UIView alloc]init];
    self.blackView.hidden = YES;
    self.blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.image addSubview:self.blackView];
    
    WEAK_SELF(self);
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.image);
    }];
    
    

    self.statusBtn.clipsToBounds = YES;
    self.statusBtn.layer.cornerRadius = 3;
    self.statusBtn.layer.borderWidth = 1;
    
    self.upLoadStatus.font = [UIFont systemFontOfSize:11];
    self.upLoadStatus.textColor = UIColorFromHEX(0X999999, 1);
    
    self.uploadRate.font = [UIFont systemFontOfSize:11];
    self.uploadRate.textColor = UIColorFromHEX(0X999999, 1);
    
    self.titleLb.font = [UIFont systemFontOfSize:15];
    self.titleLb.textColor = UIColorFromHEX(0X333333, 1);
    
    self.uploadProgress.trackTintColor= UIColorFromRGB(184, 191, 230, 1);
    
    //设置轨道的颜色
    
    self.uploadProgress.progressTintColor= BASE_COLOR;
    
    //设置进度的颜色
    
    [self setBottomBorderWithColor:BASE_BACKGROUND_COLOR width:SCREEN_WIDTH height:0];
    

}

- (void)setTableData:(UploadTable *)tableData {
    
    _tableData = tableData;
    
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:tableData.upload_photo_path] placeholderImage:[UIImage new]];
    self.titleLb.text = tableData.upload_name;
    
    if (tableData.upload_status) {
        
        
        
        [self.statusBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
        self.statusBtn.layer.borderColor = BASE_COLOR.CGColor;
        self.uploadProgress.progress = tableData.upload_progress;
        self.uploadRate.text = tableData.upload_show_text;
        
        if (tableData.isNoNet) {
            self.upLoadStatus.text = @"等待中";
            self.blackView.hidden = NO;
        }else {
            self.upLoadStatus.text = @"上传中";
            self.blackView.hidden = YES;
        }
        
        
    }else {
        
        if(tableData.isCanStart) {
            
            [self.statusBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
            self.statusBtn.layer.borderColor = BASE_COLOR.CGColor;
            
        }else {
        
            self.statusBtn.layer.borderColor = [UIColor grayColor].CGColor;
            [self.statusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

        }
        
        if (tableData.isNoNet) {
            self.upLoadStatus.text = @"等待中";
            self.blackView.hidden = NO;
        }else {
        self.upLoadStatus.text = @"排队等待上传";
            self.blackView.hidden = YES;
        }
        
        [self.statusBtn setTitle:@"上传" forState:UIControlStateNormal];
        self.uploadRate.text = @"";
       
        self.uploadProgress.progress = tableData.upload_progress;
       
    }
    
}

- (IBAction)clickBtn:(id)sender {

    if ([self.delegate respondsToSelector:@selector(KMMUploadCellDelegateDeleteDataStartOrStopWithRowPath:)]) {
        [self.delegate KMMUploadCellDelegateDeleteDataStartOrStopWithRowPath:self.rowPath];
    }
    
}
@end
