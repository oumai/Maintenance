//
//  KMMVideoImageCell.h
//  Maintenance
//
//  Created by kmcompany on 2017/7/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMMImageInfoModel.h"

@interface KMMVideoImageCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *posterImage;

@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) KMMImageInfoModel *model;

@end
