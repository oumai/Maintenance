//
//  KMMUploadCell.h
//  Maintenance
//
//  Created by kmcompany on 2017/7/5.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadTable.h"

#import "KMMBlockModel.h"

@protocol KMMUploadCellDelegate <NSObject>

- (void)KMMUploadCellDelegateDeleteDataStartOrStopWithRowPath:(NSIndexPath *)rowPath;

@end

@interface KMMUploadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@property (nonatomic,strong) UploadTable *tableData;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *upLoadStatus;
@property (weak, nonatomic) IBOutlet UILabel *uploadRate;
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgress;

@property (nonatomic,strong) KMMBlockModel *blockModel;

@property (nonatomic,strong) NSString *filePath;
@property (nonatomic,strong) NSString *fileName;

@property (nonatomic,strong) NSIndexPath *rowPath;

@property (nonatomic,strong) id <KMMUploadCellDelegate> delegate;

@end
